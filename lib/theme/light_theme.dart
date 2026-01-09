import 'package:flutter/material.dart';
import '../constants/color_helpers.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: ColorHelper.primaryColor,
  scaffoldBackgroundColor: ColorHelper.bgColor,
  cardColor: ColorHelper.surfaceColor,
  dividerColor: ColorHelper.borderColor,
  hintColor: ColorHelper.greyColor,
  colorScheme: ColorScheme.light(
    primary: ColorHelper.primaryColor,
    onPrimary: ColorHelper.whiteColor,
    secondary: ColorHelper.secondaryColor,
    onSecondary: ColorHelper.whiteColor,
    surface: ColorHelper.surfaceColor,
    background: ColorHelper.bgColor,
    error: ColorHelper.errorColor,
    onError: ColorHelper.whiteColor,
    onSurface: ColorHelper.blackColor,
    onBackground: ColorHelper.blackColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: ColorHelper.bgColor,
    foregroundColor: ColorHelper.blackColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ColorHelper.blackColor,
    ),
  ),
  inputDecorationTheme:  InputDecorationTheme(
    filled: true,
    fillColor: ColorHelper.whiteColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: ColorHelper.borderColor),
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: ColorHelper.blackColor),
    headlineMedium: TextStyle(color: ColorHelper.blackColor),
    bodyLarge: TextStyle(color: ColorHelper.blackColor),
    bodyMedium: TextStyle(color: ColorHelper.darkGreyColor),
  ),
);
