import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class SElevatedButtonTheme {
  SElevatedButtonTheme ._ ();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.light,
      backgroundColor: SColors.primary,
      disabledForegroundColor: SColors.darkerGrey,
      disabledBackgroundColor: SColors.buttonDisabled,
      side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16, color: SColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

    ),
  ); // ElevatedButtonThemeData

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.dark,
      backgroundColor: SColors.primary,
      disabledForegroundColor: SColors.darkerGrey,
      disabledBackgroundColor: Colors.grey,
      side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
          fontSize: 16, color: SColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

    ),
  );
}