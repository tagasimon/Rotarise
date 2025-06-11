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
      seedColor: Colors.pink,
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 20,
      ),
      centerTitle: false,
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
