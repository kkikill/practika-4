import 'package:flutter/material.dart';

import '../models/feature_item.dart';

// ===== Данные каталога (ПР №7) =====
// Файл с данными в виде коллекции List (по аналогии с terms_data.dart
// из методички). Внешний слой данных (БД, сеть) не подключается —
// список пунктов каталога и изображений хранится прямо в этом файле.
// Раньше эти списки лежали внутри home_page.dart (ПР №4–№6), теперь
// они вынесены в слой data, а на экран попадают только через
// состояние BLoC.

// Пункты каталога — карточки на вкладке «Главная» основного экрана
const List<FeatureItem> features = [
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

// Изображения видеокарт для горизонтальной ленты (assets из ПР №3/№4)
const List<String> gpuImages = [
  'assets/images/gpu1.png',
  'assets/images/gpu2.png',
  'assets/images/gpu3.png',
  'assets/images/gpu4.png',
  'assets/images/gpu5.png',
];
