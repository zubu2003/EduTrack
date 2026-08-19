import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/size.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColors.darkGrey,
    suffixIconColor: SColors.darkGrey,
    labelStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeMd, color: SColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeSm, color: SColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.black.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: SColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: SColors.darkGrey,
    suffixIconColor: SColors.darkGrey,
    labelStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeMd, color: SColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: SSize.fontSizeSm, color: SColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: SColors.white.withValues(alpha: 0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: SColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: SColors.warning),
    ),
  );
}