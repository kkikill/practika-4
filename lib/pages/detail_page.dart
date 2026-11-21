import 'package:flutter/material.dart';

import '../models/feature_item.dart';
import '../theme/app_colors.dart';

// Экран детализации пункта основного экрана.
// Пункт (FeatureItem) приходит сюда через arguments маршрута.
// Стрелка «назад» в AppBar появляется сама: в стеке есть основной экран
// (переход делали через Navigator.pushNamed).
// Изменение ПР №7: импорты обновлены — модель данных теперь лежит в
// models/, палитра — в theme/app_colors.dart (раньше и то и другое
// импортировалось из home_page.dart).
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Достаём переданный пункт из параметров маршрута
    final FeatureItem item =
        ModalRoute.of(context)?.settings.arguments as FeatureItem;

    return Scaffold(
      backgroundColor: deepBlack,
      appBar: AppBar(
        backgroundColor: cardBlack,
        centerTitle: true,
        title: const Text(
          'ДЕТАЛИЗАЦИЯ',
          style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Иконка пункта
          Container(
            padding: const EdgeInsets.all(28),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardBlack,
              border: Border.all(color: neonGreen, width: 2),
            ),
            child: Icon(item.icon, size: 72, color: neonGreen),
          ),

          // Название пункта
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cardBlack,
              border: Border.all(color: neonGreen, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: neonGreen,
                letterSpacing: 1.5,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Описание пункта
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBlack,
              border: Border.all(color: neonPurple, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.description,
              style: const TextStyle(
                fontSize: 15,
                color: textWhite,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
