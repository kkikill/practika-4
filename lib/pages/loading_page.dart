import 'package:flutter/material.dart';

import '../routes.dart';
import '../widgets/text_field.dart';

// Экран заставки.
// Через 4 секунды — автоматический переход на экран авторизации
// С ЗАМЕНОЙ маршрута (pushReplacementNamed): назад с заставки
// вернуться нельзя.
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Имитация инициализации (загрузка настроек, данных)
    Future.delayed(const Duration(seconds: 4), () {
      // mounted — проверяем, что экран ещё открыт
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A12), // deepBlack из ПР №4
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.memory, size: 96, color: colorPurple),
            SizedBox(height: 24),
            Text(
              'МИР ВИДЕОКАРТ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorGreen,
                letterSpacing: 2,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: colorGreen),
          ],
        ),
      ),
    );
  }
}