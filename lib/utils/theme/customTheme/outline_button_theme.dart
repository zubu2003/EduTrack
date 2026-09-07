import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/size.dart';

class SOutlinedButtonTheme {
  SOutlinedButtonTheme._();

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColors.primary,
      side: const BorderSide(color: SColors.primary),
      textStyle: const TextStyle(fontSize: 16, color: SColors.primary, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SSize.buttonRadius)),
    ),
  ); // OutlinedButtonThemeData

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: SColors.light,
      side: const BorderSide(color: SColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: SColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SSize.buttonRadius)),
    ),
  ); // OutlinedButtonThemeData
}
