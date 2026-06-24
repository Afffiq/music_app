import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme =
      ThemeData.dark().copyWith(

    scaffoldBackgroundColor:
        const Color(0xFF000000),

    appBarTheme: const AppBarTheme(
      backgroundColor:
          Color(0xFF005A1F),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    cardColor:
        const Color(0xFF002B12),

    colorScheme:
        const ColorScheme.dark(
      primary:
          Color(0xFF23D160),
    ),

    inputDecorationTheme:
        InputDecorationTheme(
      filled: true,
      fillColor:
          const Color(0xFF002B12),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
      ),
    ),
  );
}