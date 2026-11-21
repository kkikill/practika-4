import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/feature_item.dart';
import '../../routes.dart';
import '../../theme/app_colors.dart';
import '../profile_page.dart';
import 'bloc/home_bloc.dart';

// ===== Основной экран приложения (ПР №7) =====
// Страница Home_page переработана под архитектурный паттерн BLoC:
//   1) данные каталога вынесены в слои models/ (модель FeatureItem) и
//      data/ (коллекция List), на экран они попадают ТОЛЬКО через
//      состояние блока — прямых обращений к данным здесь больше нет;
//   2) вкладка «Главная» построена в BlocBuilder<HomeBloc, HomeState>:
//      по состояниям initial / loading / loaded / error показываются
//      разные виджеты (заглушка, индикатор, каталог, ошибка);
//   3) сам блок создаётся в main.dart на маршруте /home через
//      BlocProvider — на каждый вход на экран свой экземпляр блока,
//      который закрывается автоматически при уходе с маршрута;
//   4) всё остальное из ПР №6 сохранено: NavigationBar с вкладками
//      «Главная» и «Профиль», IndexedStack, переход на детализацию
//      через arguments, адаптивный дизайн (GridView при ширине > 600,
//      увеличенные отступы на десктопе и вебе).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // активная вкладка NavigationBar

  @override
  Widget build(BuildContext context) {
    // Данные пользователя, переданные с экрана авторизации через arguments
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String fullName =
        args is Map ? (args['fullName'] ?? '') as String : '';
    final String email = args is Map ? (args['email'] ?? '') as String : '';

    return Scaffold(
      backgroundColor: deepBlack,
      appBar: AppBar(
        // Заголовок меняется вместе с выбранной вкладкой
        title: Text(
          _selectedIndex == 0 ? 'МИР ВИДЕОКАРТ' : 'ПРОФИЛЬ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: neonGreen,
            letterSpacing: 2,
            fontFamily: 'OpenSans',
          ),
        ),
        centerTitle: true,
        backgroundColor: cardBlack,
        elevation: 0,
      ),
      // IndexedStack: обе вкладки уже построены, при переключении
      // через NavigationBar их состояние не теряется
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const _CatalogView(), // вкладка «Главная» (состояние BLoC)
          ProfileView(fullName: fullName, email: email), // вкладка «Профиль»
        ],
      ),
      // Нижняя панель навигации (Material 3)
      bottomNavigationBar: NavigationBar(
        backgroundColor: cardBlack,
        indicatorColor: neonGreen.withOpacity(0.3),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

// ===== Вкладка «Главная»: каталог под управлением BLoC =====
// BlocBuilder подписан на HomeBloc и перестраивает эту часть UI
// при каждом изменении состояния блока. Вкладка «Профиль» при этом
// не перестраивается — BlocBuilder обёрнут только вокруг каталога.
class _CatalogView extends StatelessWidget {
  const _CatalogView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      // Перестройка UI при изменении состояния (как в методичке)
      builder: (context, state) {
        // Sealed-класс состояний: компилятор проверяет, что обработаны
        // все четыре состояния блока
        switch (state) {
          case HomeInitial():
            // Данных ещё нет (стартовое состояние блока)
            return const Center(
              child: Text(
                'Данные ещё не загружены',
                style: TextStyle(color: textWhite),
              ),
            );

          case HomeLoading():
            // Индикатор загрузки
            return const Center(
              child: CircularProgressIndicator(color: neonGreen),
            );

          case HomeError(:final message):
            // Сообщение об ошибке и кнопка «Повторить»:
            // в блок отправляется новое событие через context.read
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: neonPurple, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: const TextStyle(color: textWhite, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<HomeBloc>()
                        .add(const RefreshHomeDataEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cardBlack,
                      foregroundColor: neonGreen,
                      side: const BorderSide(color: neonGreen),
                    ),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );

          case HomeLoaded(:final features, :final images):
            // Успешная загрузка: строим каталог по данным из состояния
            return _CatalogList(features: features, images: images);
        }
      },
    );
  }
}

// ===== Каталог (код ПР №4/№6 + адаптив), данные приходят извне =====
class _CatalogList extends StatelessWidget {
  final List<FeatureItem> features; // пункты каталога из HomeLoaded
  final List<String> images; // изображения ленты из HomeLoaded

  const _CatalogList({required this.features, required this.images});

  @override
  Widget build(BuildContext context) {
    // АДАПТИВ 1: ширина экрана больше 600 — карточки пунктов в 2 столбца
    final bool isWide = MediaQuery.sizeOf(context).width > 600;

    // АДАПТИВ 2: десктоп или веб — увеличенные вертикальные отступы
    final bool isDesktop = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
    final double verticalGap = isDesktop ? 50 : 16;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ===== Название видеокарты (без изменений из ПР №4) =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardBlack,
            border: Border.all(color: neonGreen, width: 2),
            boxShadow: [
              BoxShadow(
                color: neonGreen.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'NVIDIA GeForce RTX 4070',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: neonGreen,
              letterSpacing: 1.5,
              fontFamily: 'OpenSans',
            ),
          ),
        ),

        SizedBox(height: verticalGap),

        // ===== Описание (без изменений из ПР №4) =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBlack,
            border: Border.all(color: neonPurple, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Графический процессор — это ключевой компонент компьютера, '
            'отвечающий за преобразование цифровых данных в визуальное '
            'изображение на экране и выполнение параллельных вычислений. '
            'Модель GeForce RTX 4070 базируется на архитектуре Ada Lovelace, '
            'поддерживает аппаратную трассировку лучей в реальном времени '
            'и функцию DLSS 3.',
            style: TextStyle(fontSize: 15, color: textWhite, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ),

        SizedBox(height: verticalGap),

        // Горизонтальная лента изображений (данные из состояния блока)
        ImageCarousel(images: images),

        SizedBox(height: verticalGap),

        // ===== Карточки пунктов: АДАПТИВ =====
        // Широкий экран — сетка GridView в 2 столбца,
        // узкий — обычный вертикальный список (как в ПР №4)
        if (isWide)
          GridView.builder(
            shrinkWrap: true, // высота сетки — по её содержимому
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // два столбца на широком экране
              mainAxisSpacing: 12, // вертикальные отступы между карточками
              crossAxisSpacing: 12,
              childAspectRatio: 3, // пропорции карточки (ширина / высота)
            ),
            itemBuilder: (context, index) =>
                _buildFeatureCard(context, features[index]),
          )
        else
          ListView.builder(
            shrinkWrap: true, // высота списка — по его содержимому
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFeatureCard(context, features[index]),
            ),
          ),

        const SizedBox(height: 8),
        Divider(color: neonGreen.withOpacity(0.5), thickness: 1),
        const SizedBox(height: 8),

        // ===== ФИО и группа (без изменений из ПР №4) =====
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardBlack,
                border: Border.all(color: neonGreen, width: 1.5),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.person, size: 32, color: neonGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cardBlack,
                  border: Border.all(color: neonPurple, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Половинкин Кирилл ИКБО-62-23',
                  style: TextStyle(fontSize: 15, color: textWhite),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Карточка одного пункта (Card + ListTile из ПР №4).
  // По нажатию — переход на экран детализации по именованному маршруту
  // (как в ПР №6), пункт передаётся целиком через arguments.
  Widget _buildFeatureCard(BuildContext context, FeatureItem item) {
    return Card(
      color: cardBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: neonPurple, width: 1.5),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: neonGreen, size: 32), // иконка слева
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textWhite,
          ),
        ),
        subtitle: Text(
          item.description,
          style: const TextStyle(fontSize: 13, color: textWhite),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: neonPurple,
          size: 18,
        ),
        // Переход на экран детализации: пункт передаётся через arguments
        onTap: () =>
            Navigator.pushNamed(context, Routes.detail, arguments: item),
      ),
    );
  }
}

/// Горизонтальный список изображений (из ПР №4/№6; список картинок
/// теперь приходит параметром — из состояния HomeLoaded).
/// StatefulWidget — хранит ScrollController, чтобы лента
/// реагировала на колёсико мыши и имела видимую полосу прокрутки.
class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Перехватываем колёсико мыши и крутим список по горизонтали
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent && _controller.hasClients) {
          final target = (_controller.offset + event.scrollDelta.dy)
              .clamp(0.0, _controller.position.maxScrollExtent);
          _controller.animateTo(
            target,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      // Видимая полоса прокрутки под лентой
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        child: SizedBox(
          height: 180,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: cardBlack,
                    border: Border.all(color: neonGreen, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
