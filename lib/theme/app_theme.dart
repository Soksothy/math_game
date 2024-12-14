import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'LazySmooth',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'LazySmooth'),
        bodyMedium: TextStyle(fontFamily: 'LazySmooth'),
        titleLarge: TextStyle(fontFamily: 'LazySmooth'),
        titleMedium: TextStyle(fontFamily: 'LazySmooth'),
      ),
    );
  }
}