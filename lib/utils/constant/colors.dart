import 'package:flutter/material.dart';

class SColors {
  SColors._();

  // Primary Colors (Dark Navy from design)
  static const Color primary = Color(0xFF122244);
  static const Color primaryColor = Color(0xFF122244);
  static const Color secondary = Color(0xFF6C63FF);
  static const Color accent = Color(0xFF4CAF50);

  // Light & Dark Theme Colors
  static const Color light = Color(0xFFF9FAFB);
  static const Color dark = Color(0xFF122244);

  // Text Colors
  static const Color textPrimary = Color(0xFF122244);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Colors.white;
  static const Color textBlack = Colors.black;

  // Background Colors
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF122244);

  // Input Field Background
  static const Color inputFieldBackground = Color(0xFFF1F4F9);

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9CA3AF);
  static const Color darkGrey = Color(0xFF626262);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color yellow = Color(0xFFFFE24B);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF122244);
  static const Color buttonSecondary = Color(0xFF6C63FF);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFFE5E7EB);
  static const Color borderSecondary = Color(0xFFD1D5DB);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFF333333);

  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color shadowLight = Color(0x0A000000);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF122244),
      Color(0xFF6C63FF),
    ],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF122244),
    ],
  );

  // Transparent
  static const Color transparent = Colors.transparent;
}
