import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = Color(0xFF2196F3);
  Color darkPrimaryColor = Color(0xFF2196F3);
  Color secondaryColor = Color(0xFF3F51B5);
  Color accentColor = Color(0xFF009688);

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      primaryColor: ThemeData.light().scaffoldBackgroundColor,
      colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor,
      ));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primaryColor: ThemeData.dark().scaffoldBackgroundColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xFF2196F3)),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: _themeClass.darkPrimaryColor,
      ));
}

ThemeClass _themeClass = ThemeClass();
