import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.indigo[900], // Deep Blue
    scaffoldBackgroundColor: const Color(0xFFBBDEFB), // Light Blue
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static LinearGradient appBarGradient = const LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      Color(0xFF536DFE), // Deep Blue
      Color(0xFF448AFF),
    ],
  );
}
