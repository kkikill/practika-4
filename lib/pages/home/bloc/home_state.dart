part of 'home_bloc.dart';

// ===== Состояния BLoC основного экрана (ПР №7) =====
// Состояние — данные, которые определяют, как выглядит интерфейс в
// данный момент. Sealed-класс ограничивает набор возможных состояний
// и позволяет компилятору проверять полноту их обработки в switch
// (как TermsState в методичке).

@immutable
sealed class HomeState {
  const HomeState();
}

// Ничего не загружено (стартовое состояние блока)
final class HomeInitial extends HomeState {
  const HomeInitial();
}

// Идёт загрузка данных
final class HomeLoading extends HomeState {
  const HomeLoading();
}

// Данные загружены: список пунктов каталога и лента изображений
final class HomeLoaded extends HomeState {
  final List<FeatureItem> features;
  final List<String> images;

  const HomeLoaded(this.features, this.images);
}

// Ошибка при загрузке
final class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
