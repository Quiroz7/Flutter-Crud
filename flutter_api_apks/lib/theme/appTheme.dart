import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary = Color.fromARGB(255, 44, 75, 131);
  static const Color secundary = Color.fromARGB(255, 28, 101, 134);
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.indigo,
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation : 0
    ),

    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color.fromARGB(255, 78, 156, 67))),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secundary
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),
          topRight: Radius.circular(10))
        )
    )
  );
}