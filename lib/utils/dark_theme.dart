import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromRGBO(131, 35, 57, 1), // #832339
  scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1), // #121212
  dialogBackgroundColor: const Color.fromRGBO(18, 18, 18, 1), // #121212
  cardColor: const Color.fromARGB(255, 32, 31, 31), // #511922
  dividerColor: const Color.fromRGBO(255, 255, 255, 0.12), // White with 12% opacity
  disabledColor: const Color.fromRGBO(55, 55, 55, 1), // #373737
  hintColor: const Color.fromRGBO(170, 170, 170, 1), // #AAAAAA
  fontFamily: 'peyda',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Colors.white),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromRGBO(131, 35, 57, 1), // #832339
    secondary: Color.fromRGBO(81, 25, 34, 1), // #511922
    surface: Color.fromRGBO(18, 18, 18, 1), // #121212
    onPrimary: Color.fromRGBO(255, 255, 255, 1), // #FFFFFF
    onSecondary: Color.fromRGBO(255, 255, 255, 1), // #FFFFFF
    onSurface: Color.fromRGBO(255, 255, 255, 1), // #FFFFFF
    onError: Color.fromRGBO(0, 0, 0, 1), // #000000
    error: Color.fromRGBO(207, 102, 121, 1), // #CF6679
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromRGBO(131, 35, 57, 1), // #832339
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(131, 35, 57, 1), // #832339
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontFamily: 'peyda'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color.fromRGBO(81, 25, 34, 1), // #511922
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color.fromRGBO(131, 35, 57, 1)), // #832339
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.white),
    ),
    labelStyle: TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)), // #AAAAAA
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(18, 18, 18, 1), // #121212
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Peyda',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
