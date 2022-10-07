import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    
    scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromARGB(255, 33, 33, 33),
    ),
    primaryColor: Colors.white,
    snackBarTheme: const SnackBarThemeData(backgroundColor: Colors.white24),
    dialogTheme: const DialogTheme(backgroundColor: Colors.white24),
    
    inputDecorationTheme:const InputDecorationTheme(
      enabledBorder:UnderlineInputBorder(borderSide:  BorderSide(color: Colors.white)),
      hintStyle:TextStyle(color: Colors.white),
      prefixIconColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.cyan,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 59, 59, 59),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
