import 'package:flutter/material.dart';

import '../widgets/text_field.dart';

// Экран регистрации.
// Открывается с экрана авторизации через pushNamed, поэтому в AppBar
// автоматически появляется стрелка «назад» (возврат по схеме).
// После успешной регистрации — возврат на авторизацию (pop) с передачей
// имени и email через результат: они подставятся в форму входа и попадут
// в профиль после авторизации.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Ключ формы — через него вызывается валидация всех полей
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Отправка формы: валидация и возврат на авторизацию
  void _submit() {
    FocusScope.of(context).unfocus(); // прячем клавиатуру

    if (_formKey.currentState!.validate()) {
      // Уведомление общее (ScaffoldMessenger) — видно и после возврата
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Регистрация прошла успешно!")),
      );

      // «Возврат» на предыдущий экран (авторизацию) с передачей данных
      Navigator.pop(context, {
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
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
          "РЕГИСТРАЦИЯ",
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
                child: const Icon(Icons.person_add, size: 56, color: colorGreen),
              ),

              // Полное имя
              CustomTextFormField(
                inputType: InputFieldType.name,
                labelText: "Полное имя:",
                hintText: "Иванов Иван Иванович",
                prefixIcon: const Icon(Icons.person, color: colorPurple),
                controller: _nameController,
              ),
              const SizedBox(height: 12),

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
                hintText: "Не менее 6 символов",
                prefixIcon: const Icon(Icons.lock, color: colorPurple),
                controller: _passwordController,
              ),
              const SizedBox(height: 12),

              // Подтверждение пароля: compareWith — контроллер поля «Пароль»
              CustomTextFormField(
                inputType: InputFieldType.password,
                labelText: "Подтвердите пароль:",
                hintText: "Повторите пароль",
                prefixIcon: const Icon(Icons.lock_outline, color: colorPurple),
                controller: _confirmController,
                compareWith: _passwordController,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Зарегистрироваться"),
              ),

              // Возврат на авторизацию (стрелка «назад» делает то же самое)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Уже есть аккаунт? Войти",
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
