import 'package:flutter/material.dart';

// ===== Палитра приложения (ПР №7) =====
// Тёмная неоновая тема, как в ПР №3/№4. В ПР №7 цвета вынесены в
// отдельный файл: раньше они объявлялись внутри home_page.dart, и
// другие экраны (например, детализация) были вынуждены импортировать
// основной экран ради констант. Теперь слои UI не зависят друг от друга.

const Color deepBlack = Color(0xFF0A0A12); // фон экранов
const Color cardBlack = Color(0xFF16161F); // фон карточек
const Color neonGreen = Color(0xFF00E676); // акцентный зелёный
const Color neonPurple = Color(0xFFB026FF); // акцентный фиолетовый
const Color textWhite = Color(0xFFE5E7EB); // основной текст
