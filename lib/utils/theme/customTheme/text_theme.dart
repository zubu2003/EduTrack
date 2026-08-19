import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class STextTheme {
  STextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: SColors.dark),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: SColors.dark),
    headlineSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SColors.dark),

    titleLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SColors.dark),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: SColors.dark),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: SColors.dark),

    bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: SColors.dark),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: SColors.dark),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: SColors.dark.withOpacity(0.6)),

    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SColors.dark),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: SColors.dark),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: SColors.dark.withOpacity(0.5)),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: SColors.light),
    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: SColors.light),
    headlineSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: SColors.light),

    titleLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SColors.light),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: SColors.light),
    titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: SColors.light),

    bodyLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: SColors.light),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: SColors.light),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: SColors.light.withOpacity(0.6)),

    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: SColors.light),
    labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: SColors.light),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: SColors.light.withOpacity(0.5)),
  );
}