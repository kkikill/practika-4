import 'package:flutter/material.dart';

// ===== Модель данных (ПР №7) =====
// Класс для описания данных — один пункт каталога основного экрана.
// Раньше класс FeatureItem объявлялся прямо внутри home_page.dart
// (ПР №4–№6), теперь он вынесен в отдельный файл слоя models, как
// требует структура проекта с паттерном BLoC.
class FeatureItem {
  /// Заголовок пункта — крупный текст карточки.
  final String title;

  /// Короткое описание пункта — выводится мелким шрифтом в карточке
  /// и на экране детализации.
  final String description;

  /// Иконка, которая отображается перед текстом карточки
  /// и на экране детализации.
  final IconData icon;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
