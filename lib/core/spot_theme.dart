import 'package:flutter/material.dart';

abstract final class SpotColors {
  static const ink = Color(0xFF000618);
  static const blue = Color(0xFF558AF8);
  static const pink = Color(0xFFEE558B);
  static const green = Color(0xFF43EC9B);
  static const canvas = Color(0xFFEDF1F5);
  static const muted = Color(0xFF666B78);
  static const lavender = Color(0xFFD3E0F8);
  static const rose = Color(0xFFF2D7E3);
  static const mint = Color(0xFFCFF3E5);
}

ThemeData spotTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: SpotColors.blue,
    primary: SpotColors.blue,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 14, color: SpotColors.ink, height: 1.45),
  ),
  splashFactory: InkSparkle.splashFactory,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF4F5F7),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    isDense: true,
  ),
);
