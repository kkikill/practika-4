import 'package:flutter/material.dart';

import '../routes.dart';
import '../widgets/text_field.dart';

// Экран авторизации (переходы по именованным маршрутам).
// «Нет регистрации» -> pushNamed на экран регистрации (в его AppBar
// сама появится стрелка «назад»). Успешная авторизация ->
// pushReplacementNamed на основной экран, данные пользователя
// передаются через arguments.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Ключ формы — через него вызывается валидация всех полей
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Имя, полученное с экрана регистрации (уйдёт в профиль)
  String _registeredName = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Отправка формы: валидация и переход на основной экран
  void _submit() {
    FocusScope.of(context).unfocus(); // прячем клавиатуру

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Вы успешно авторизованы!")),
      );

      // Успешная авторизация: переход с заменой маршрута (к форме
      // с кнопки «Назад» вернуться нельзя)
      Navigator.pushReplacementNamed(
        context,
        Routes.home,
        arguments: {
          'fullName': _registeredName,
          'email': _emailController.text.trim(),
        },
      );
    }
  }

  // Открытие экрана регистрации. await — ждём закрытия экрана:
  // pushNamed вернёт результат pop (имя и email нового пользователя).
  Future<void> _openRegister() async {
    final result = await Navigator.pushNamed(context, Routes.register);

    // Регистрация успешна: сохраняем имя и подставляем email в поле
    if (result is Map && mounted) {
      setState(() {
        _registeredName = result['fullName'] ?? "";
        _emailController.text = result['email'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12), // deepBlack из ПР №4
      appBar: AppBar(
        backgroundColor: colorCard,
        centerTitle: true,
        title: const Text(
          "АВТОРИЗАЦИЯ",
          style: TextStyle(color: colorGreen, fontWeight: FontWeight.bold),
        ),
      ),
      // SingleChildScrollView — чтобы форма не вылезала за экран при клавиатуре
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Аватар
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorCard,
                  border: Border.all(color: colorGreen, width: 2),
                ),
                child: const Icon(Icons.person, size: 56, color: colorGreen),
              ),

              // Email
              CustomTextFormField(
                inputType: InputFieldType.email,
                labelText: "Email:",
                hintText: "example@mail.com",
                prefixIcon: const Icon(Icons.email, color: colorPurple),
                controller: _emailController,
              ),
              const SizedBox(height: 12),

              // Пароль
              CustomTextFormField(
                inputType: InputFieldType.password,
                labelText: "Пароль:",
                hintText: "Введите пароль",
                prefixIcon: const Icon(Icons.lock, color: colorPurple),
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Войти"),
              ),

              // «Нет регистрации» — переход на экран регистрации
              TextButton(
                onPressed: _openRegister,
                child: const Text(
                  "Нет аккаунта? Зарегистрируйтесь",
                  style: TextStyle(color: colorPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
