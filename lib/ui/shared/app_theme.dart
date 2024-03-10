
import 'package:flutter/material.dart';

class AppTheme {
  static const double bodynormalFontSize = 14;
  static const double smallFontSize = 16;
  static const double normalFontSize = 22;
  static const double largeFontSize = 24;

  static final ThemeData normalTheme = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: TextTheme(
        bodySmall: TextStyle(fontSize: bodynormalFontSize),
        displaySmall: TextStyle(fontSize: smallFontSize, color: Colors.black87),
        displayMedium: TextStyle(fontSize: normalFontSize, color: Colors.black87),
        labelLarge: TextStyle(fontSize: largeFontSize, color: Colors.black87),
      )
  );
}