import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GpuPage(),
    );
  }
}

// Модель одного пункта списка: заголовок, короткое описание и иконка
class FeatureItem {
  final String title;
  final String description;
  final IconData icon;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// Экран снова StatelessWidget — setState больше не нужен:
// все 5 картинок видны сразу, SnackBar показывается через ScaffoldMessenger
class GpuPage extends StatelessWidget {
  const GpuPage({super.key});

  // ===== Палитра (как в практике №3) =====
  static const Color deepBlack = Color(0xFF0A0A12);
  static const Color cardBlack = Color(0xFF16161F);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color neonPurple = Color(0xFFB026FF);
  static const Color textWhite = Color(0xFFE5E7EB);

  // Список из 5 изображений из ассетов
  static const List<String> _images = [
    'assets/images/gpu1.png',
    'assets/images/gpu2.png',
    'assets/images/gpu3.png',
    'assets/images/gpu4.png',
    'assets/images/gpu5.png',
  ];

  // Пункты для вертикального списка карточек
  static const List<FeatureItem> _features = [
    FeatureItem(
      title: 'Игры',
      description: 'Стабильные 60+ FPS в современных играх',
      icon: Icons.sports_esports,
    ),
    FeatureItem(
      title: 'Нейросети',
      description: 'Локальный запуск ИИ-моделей на ядрах CUDA и Tensor',
      icon: Icons.psychology,
    ),
    FeatureItem(
      title: 'Видеомонтаж',
      description: 'Аппаратное ускорение кодека NVENC',
      icon: Icons.movie,
    ),
    FeatureItem(
      title: '3D-рендер',
      description: 'Быстрый рендер в Blender, Unreal Engine и 3ds Max',
      icon: Icons.view_in_ar,
    ),
    FeatureItem(
      title: 'Трассировка лучей',
      description: 'Реалистичное освещение сцены в реальном времени',
      icon: Icons.light_mode,
    ),
  ];

  // SnackBar с названием выбранного пункта (задание 3)
  void _showItemSnackBar(BuildContext context, FeatureItem item) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // заменяем предыдущее уведомление
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбран пункт: ${item.title}'),
        backgroundColor: cardBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: neonGreen, width: 1.5),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'ЗАКРЫТЬ',
          textColor: neonGreen,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlack,
      appBar: AppBar(
        title: const Text(
          'МИР ВИДЕОКАРТ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: neonGreen,
            letterSpacing: 2,
            fontFamily: 'OpenSans', // кастомный шрифт из практики №3
          ),
        ),
        centerTitle: true,
        backgroundColor: cardBlack,
        elevation: 0,
      ),
      // Внешний ListView прокручивает весь экран
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Название видеокарты =====
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

          const SizedBox(height: 16),

          // ===== Описание =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBlack,
              border: Border.all(color: neonPurple, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Графический процессор — это ключевой компонент компьютера, отвечающий за преобразование цифровых данных в визуальное изображение на экране и выполнение параллельных вычислений. Модель GeForce RTX 4070 базируется на архитектуре Ada Lovelace, поддерживает аппаратную трассировку лучей в реальном времени и функцию DLSS 3.',
              style: TextStyle(fontSize: 15, color: textWhite, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),

          const SizedBox(height: 16),

          // ===== Задание 1: горизонтальный ListView изображений =====
          const ImageCarousel(),

          const SizedBox(height: 16),

          // ===== Задание 2: вертикальный ListView карточек =====
          ListView.builder(
            shrinkWrap: true, // высота списка — по его содержимому
            physics:
            const NeverScrollableScrollPhysics(), // скроллит внешний список
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final item = _features[index];
              return Card(
                color: cardBlack,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: neonPurple, width: 1.5),
                ),
                child: ListTile(
                  leading: Icon(item.icon, color: neonGreen, size: 32), // иконка ПЕРЕД текстом
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textWhite,
                    ),
                  ),
                  subtitle: Text(
                    item.description, // короткое описание
                    style: const TextStyle(fontSize: 13, color: textWhite),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios, // иконка ПОСЛЕ текста
                    color: neonGreen,
                    size: 18,
                  ),
                  // Задание 3: по нажатию — SnackBar с названием пункта
                  onTap: () => _showItemSnackBar(context, item),
                ),
              );
            },
          ),

          const SizedBox(height: 8),
          Divider(color: neonGreen.withOpacity(0.5), thickness: 1),
          const SizedBox(height: 8),

          // ===== ФИО и группа =====
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
      ),
    );
  }
}
/// Горизонтальный список изображений.
/// StatefulWidget — хранит ScrollController, чтобы лента
/// реагировала на колёсико мыши и имела видимую полосу прокрутки.
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

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
            itemCount: GpuPage._images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: GpuPage.cardBlack,
                    border: Border.all(color: GpuPage.neonGreen, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      GpuPage._images[index],
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