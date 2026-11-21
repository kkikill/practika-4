import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/detail_page.dart';
import 'pages/home/bloc/home_bloc.dart';
import 'pages/home/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

// Практическая работа №7: управление состоянием основного экрана
// (Home_page) переведено на архитектурный паттерн BLoC (пакет
// flutter_bloc). Таблица маршрутов из ПР №6 сохранена; на маршруте
// /home создаётся HomeBloc, данные каталога приходят на экран только
// через его состояния (initial / loading / loaded / error).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Видеокарты (BLoC)',
      // Стартовый маршрут — экран заставки
      initialRoute: Routes.loading,
      // Таблица именованных маршрутов (императивная навигация, ПР №6)
      routes: {
        Routes.loading: (context) => const LoadingPage(),
        Routes.login: (context) => const LoginPage(),
        Routes.register: (context) => const RegisterPage(),
        // ПР №7: на каждый вход на основной экран создаётся НОВЫЙ
        // экземпляр HomeBloc. Каскадный оператор (..) позволяет сразу
        // вызвать метод у только что созданного объекта: блок создаётся
        // и в его поток сразу добавляется событие загрузки данных
        // каталога. BlocProvider автоматически закроет блок (close()),
        // когда маршрут /home будет удалён из дерева виджетов.
        Routes.home: (context) => BlocProvider(
              create: (_) => HomeBloc()..add(const LoadHomeDataEvent()),
              child: const HomePage(),
            ),
        Routes.detail: (context) => const DetailPage(),
      },
    );
  }
}
