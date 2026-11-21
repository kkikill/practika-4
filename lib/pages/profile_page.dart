import 'package:flutter/material.dart';

import '../routes.dart';
import '../widgets/text_field.dart';

// Вкладка «Профиль» основного экрана.
// В ПР №6 профиль — не отдельный экран, а вторая вкладка NavigationBar:
// он встраивается в IndexedStack основного экрана (без своего Scaffold
// и AppBar — их даёт основной экран). Имя и email приходят через
// конструктор с данными маршрута /home.
class ProfileView extends StatelessWidget {
  final String fullName;
  final String email;

  const ProfileView({super.key, this.fullName = "", required this.email});

  @override
  Widget build(BuildContext context) {
    // Имя заполнено только после регистрации; при входе по email его нет
    final hasName = fullName.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Аватар
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.only(top: 16, bottom: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorCard,
            border: Border.all(color: colorGreen, width: 2),
          ),
          child: const Icon(Icons.person, size: 72, color: colorGreen),
        ),

        // Имя (если есть) и email
        if (hasName)
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: colorPurple),
        ),
        const SizedBox(height: 24),

        // Выход — возврат на экран авторизации (с заменой маршрута)
        ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.login),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorCard,
            foregroundColor: colorGreen,
            side: const BorderSide(color: colorGreen),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text("Выйти"),
        ),
      ],
    );
  }
}
