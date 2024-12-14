import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'Swiss',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Swiss'),
        bodyMedium: TextStyle(fontFamily: 'Swiss'),
        titleLarge: TextStyle(fontFamily: 'Swiss'),
        titleMedium: TextStyle(fontFamily: 'Swiss'),
      ),
    );
  }
}