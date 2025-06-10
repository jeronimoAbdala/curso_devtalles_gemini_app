import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryBlue = Color(0xFF00B8D4);     // Parte superior del gradiente, botones
const Color lightBlue = Color(0xFFB2EBF2);       // Fondo claro
const Color white = Color(0xFFFFFFFF);           // Textos y fondos
const Color seedColor = Color(0xFF005662);       // Títulos como "Pescador Experto"
const Color statBlue = Color(0xFF00ACC1);        // Iconos circulares de estadísticas
const Color borderBlue = Color(0xFFB2E3F5);      // Bordes de tarjetas

const LinearGradient headerGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF00BCD4),   // Celeste oscuro
    Color(0xFF26C6DA),   // Celeste medio
  ],
);

class AppTheme {
  final bool isDarkMode;

  AppTheme({required this.isDarkMode});

  ThemeData getTheme() => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: seedColor,
  brightness: isDarkMode ? Brightness.dark : Brightness.light,
  scaffoldBackgroundColor: lightBlue,
  cardColor: white,

  listTileTheme: ListTileThemeData(iconColor: statBlue),

  appBarTheme: AppBarTheme(
    backgroundColor: primaryBlue, // lo podés dejar explícito si querés este color exacto
    foregroundColor: white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),

  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: seedColor,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: seedColor),
  ),
);


  static setSystemUIOverlayStyle({required bool isDarkMode}) {
    final themBrightness = isDarkMode ? Brightness.dark : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: themBrightness,
        statusBarIconBrightness: themBrightness,
        systemNavigationBarIconBrightness: themBrightness,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}
