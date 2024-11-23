import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: const Color.fromARGB(255, 21, 21, 21),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.yellow, //Основный акцентный цвет
    brightness: Brightness.dark,  // Темный режим
  ),
  textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.normal,
        color: Colors.white,
      ),
    ),
  

  cardColor: Colors.black.withOpacity(0.1),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow, // Фон кнопок
      foregroundColor: Colors.black, // Текст на кнопках
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Скругленные углы
      ),
      elevation: 4, // Тень кнопок
    ),
  ),
);

