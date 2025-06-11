// generate app theme provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = StateNotifierProvider<AppThemeProvider, ThemeData>(
  (ref) => AppThemeProvider(),
);

class AppThemeProvider extends StateNotifier<ThemeData> {
  AppThemeProvider() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE30613), // Rotaract Pink
      primary: Colors.pink.shade500,
      secondary: const Color(0xFF9D2449), // Optional: Rotaract Burgundy
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      backgroundColor: Color(0xFFE30613), // Pink
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE30613), // Pink
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFE30613), // Pink
      foregroundColor: Colors.white,
    ),
  );
  static final _darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );

  void toggleTheme() {
    state = state == _lightTheme ? _darkTheme : _lightTheme;
  }
}
