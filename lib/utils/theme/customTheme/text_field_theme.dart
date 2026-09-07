import 'package:flutter/material.dart';
import '../../constant/colors.dart';
import '../../constant/size.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColors.grey,
    suffixIconColor: SColors.grey,
    filled: true,
    fillColor: SColors.inputFieldBackground,
    labelStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeMd, color: SColors.primary),
    hintStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeSm, color: SColors.grey),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.primary.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.primary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: SColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: SColors.grey,
    suffixIconColor: SColors.grey,
    filled: true,
    fillColor: SColors.darkerGrey.withOpacity(0.2),
    labelStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeMd, color: SColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeSm, color: SColors.white.withOpacity(0.5)),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: SColors.error),
    ),
  );
}
