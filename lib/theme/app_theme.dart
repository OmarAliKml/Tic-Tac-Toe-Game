import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );
}
