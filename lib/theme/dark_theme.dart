import 'package:flutter/material.dart';
import '../constants/color_helpers.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: ColorHelper.primaryColor,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  dividerColor: const Color(0xFF2C2C2C),
  hintColor: ColorHelper.greyColor,
  colorScheme: ColorScheme.dark(
    primary: ColorHelper.primaryColor,
    onPrimary: ColorHelper.whiteColor,
    secondary: ColorHelper.secondaryColor,
    onSecondary: ColorHelper.whiteColor,
    surface: Color(0xFF1E1E1E),
    background: Color(0xFF121212),
    error: ColorHelper.errorColor,
    onError: ColorHelper.whiteColor,
    onSurface: ColorHelper.whiteColor,
    onBackground: ColorHelper.whiteColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: ColorHelper.whiteColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ColorHelper.whiteColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: ColorHelper.borderColor),
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: ColorHelper.whiteColor),
    headlineMedium: TextStyle(color: ColorHelper.whiteColor),
    bodyLarge: TextStyle(color: ColorHelper.whiteColor),
    bodyMedium: TextStyle(color: ColorHelper.greyColor),
  ),
);
