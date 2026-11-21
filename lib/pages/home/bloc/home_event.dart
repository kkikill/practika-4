part of 'home_bloc.dart';

// ===== События BLoC основного экрана (ПР №7) =====
// События — входные данные блока: действия пользователя или системы,
// которые требуют изменения состояния основного экрана.

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

// Событие: загрузить данные каталога. Отправляется сразу после
// создания блока на маршруте /home (main.dart: HomeBloc()..add(...))
final class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

// Событие: повторить загрузку данных после ошибки
// (кнопка «Повторить» на экране ошибки)
final class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}
