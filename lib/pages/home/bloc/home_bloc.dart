import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/features_data.dart';
import '../../../models/feature_item.dart';

part 'home_event.dart';
part 'home_state.dart';

// ===== BLoC основного экрана (ПР №7) =====
// Компонент бизнес-логики: принимает события (HomeEvent) на вход и
// преобразует их в состояния (HomeState) на выходе. Блок ничего не
// знает про UI — он только обрабатывает события и публикует новые
// состояния, а BlocBuilder в home_page.dart перестраивает интерфейс
// в зависимости от текущего состояния.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Начальное состояние при создании блока — ничего не загружено
  HomeBloc() : super(const HomeInitial()) {
    // Регистрируются обработчики событий
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onLoadHomeData);
  }

  // Обработка события загрузки: событие последовательно превращается
  // в состояния HomeLoading -> HomeLoaded (или HomeError при сбое).
  Future<void> _onLoadHomeData(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Новое состояние «идёт загрузка» — UI покажет индикатор
    emit(const HomeLoading());
    try {
      // Слой данных не подключается: имитируем задержку получения
      // данных (как Future.delayed в примере методички)
      await Future.delayed(const Duration(milliseconds: 500));
      // Данные из слоя data упаковываются в состояние HomeLoaded
      emit(const HomeLoaded(features, gpuImages));
    } catch (e) {
      // При сбое — состояние ошибки с сообщением для пользователя
      emit(const HomeError('Не удалось загрузить данные каталога'));
    }
  }
}
