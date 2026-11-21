import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

// Палитра приложения — тёмная неоновая тема, как в прошлых работах.
// Изменение ПР №7: основные константы цветов переехали в отдельный
// файл theme/app_colors.dart. Ниже оставлены прежние имена цветов
// (colorCard, colorGreen, colorPurple из ПР №3–№5), чтобы экраны
// авторизации, регистрации, заставки и профиля не пришлось менять.
const Color colorCard = cardBlack; // фон полей и карточек
const Color colorGreen = neonGreen; // акцентный зелёный
const Color colorPurple = neonPurple; // акцентный фиолетовый

// Тип поля — определяет, какая валидация будет применяться
enum InputFieldType { name, email, password }

// Кастомное текстовое поле: подходит для имени, email, пароля
// и подтверждения пароля. Валидация, иконка слева, у паролей —
// кнопка показа/скрытия текста, переход фокуса к следующему полю.
class CustomTextFormField extends StatefulWidget {
  final InputFieldType inputType; // тип поля (вид валидации)
  final String labelText; // метка поля
  final String hintText; // подсказка
  final Widget prefixIcon; // иконка слева
  final TextEditingController controller; // контроллер поля

  // Контроллер поля «Пароль» — нужен только для подтверждения пароля
  final TextEditingController? compareWith;

  const CustomTextFormField({
    super.key,
    required this.inputType,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.compareWith,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hidePassword = true; // скрыт ли пароль

  // Валидация: возвращает текст ошибки или null, если всё корректно
  String? _validator(String? value) {
    // Поле не может быть пустым и неопределённым
    if (value == null || value.trim().isEmpty) {
      return "Поле не может быть пустым";
    }

    switch (widget.inputType) {
      // Полное имя — только буквы и пробелы
      case InputFieldType.name:
        final reg = RegExp(r'^[A-Za-zА-Яа-яЁё\s]+$');
        if (!reg.hasMatch(value)) {
          return "Полное имя может содержать только буквы и пробелы";
        }

      // Email — текст до @, домен после @, точка в домене
      case InputFieldType.email:
        final reg = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}$');
        if (!reg.hasMatch(value)) {
          return "Некорректный email";
        }

      // Пароль — не менее 6 символов, буквы, цифры и символы (+, _, -)
      case InputFieldType.password:
        final reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[+\-_]).{6,}$');
        if (!reg.hasMatch(value)) {
          return "Не менее 6 символов: буквы, цифры и символы (+, _, -)";
        }
        // Для подтверждения пароля — проверка совпадения
        if (widget.compareWith != null && value != widget.compareWith!.text) {
          return "Пароли не совпадают";
        }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.inputType == InputFieldType.password;

    return TextFormField(
      controller: widget.controller,
      validator: _validator,
      // Маскируем символы у паролей
      obscureText: isPassword && _hidePassword,
      // У email — клавиатура с @ и точкой
      keyboardType: widget.inputType == InputFieldType.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      // Переход фокуса к следующему полю (2 способ из методички)
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: widget.prefixIcon,
        // Кнопка показа/скрытия пароля справа
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _hidePassword = !_hidePassword),
              )
            : null,
        filled: true,
        fillColor: colorCard,
        // Границы поля в разных состояниях
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorPurple, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorGreen, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: colorGreen, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
