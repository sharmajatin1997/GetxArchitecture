import 'package:flutter/material.dart';
import 'color_helpers.dart';

class StyleHelper {
  // =========================
  // Text Styles
  // =========================
  static TextStyle heading1(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: theme.textTheme.headlineLarge?.color ?? ColorHelper.blackColor,
    );
  }

  static TextStyle heading2(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: theme.textTheme.headlineMedium?.color ?? ColorHelper.blackColor,
    );
  }

  static TextStyle bodyText(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: theme.textTheme.bodyMedium?.color ?? ColorHelper.darkGreyColor,
    );
  }

  static TextStyle bodyTextBold(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: theme.textTheme.bodyLarge?.color ?? ColorHelper.blackColor,
    );
  }

  static TextStyle hintText(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: theme.hintColor,
    );
  }

  static TextStyle inputText(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 16,
      color: theme.textTheme.bodyMedium?.color ?? ColorHelper.blackColor,
    );
  }

  // =========================
  // Button Styles
  // =========================
  static ButtonStyle primaryButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.primaryColor,
      foregroundColor: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static ButtonStyle secondaryButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: ColorHelper.secondaryColor,
      foregroundColor: theme.colorScheme.onSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// AppBar Title
  static Widget appBarTitle({String? title, Color? color, BuildContext? context}) {
    final themeColor = color ??
        (context != null
            ? Theme.of(context).appBarTheme.titleTextStyle?.color
            : ColorHelper.blackColor);

    return Text(
      title ?? "",
      maxLines: 2,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: themeColor,
      ),
    );
  }
}
