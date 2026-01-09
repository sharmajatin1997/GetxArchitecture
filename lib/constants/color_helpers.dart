import 'package:flutter/material.dart';

class ColorHelper {
  // ===== Primary & Secondary =====
  static Color primaryColor = const Color(0xFF007AFF); // blue
  static Color secondaryColor = const Color(0xFFFF9500); // orange/amber

  // ===== Backgrounds & Surface =====
  static Color bgColor = const Color(0xFFF5F5F5); // light background
  static Color darkBgColor = const Color(0xFF121212); // dark background
  static Color surfaceColor = Colors.white; // card, container
  static Color darkSurfaceColor = const Color(0xFF1E1E1E); // dark card/container
  static Color containerBgColor = const Color(0xFFF1F1F1);

  // ===== Text Colors =====
  static Color textBlackColor = const Color(0xFF1A1A1A);
  static Color blackColor = const Color(0xFF1A1A1A);
  static Color whiteColor = Colors.white;
  static Color greyColor = Colors.grey;
  static Color textGreyColor = Colors.grey[600]!;
  static Color darkGreyColor = const Color(0xFF4A4A4A);

  // ===== Borders =====
  static Color borderColor = const Color(0xFFE0E0E0);

  // ===== Alerts =====
  static Color errorColor = const Color(0xFFFF3B30);
  static Color successColor = const Color(0xFF34C759);
  static Color warningColor = const Color(0xFFFFCC00);

  // ===== Shadows =====
  static Color shadowColor = Colors.black26;

  // ===== Dark Mode Text Colors =====
  static Color darkTextColor = Colors.white;
  static Color darkHintColor = Colors.grey;
}
