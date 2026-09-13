import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class SSnackBarHelpers {
  // Success Snackbar
  static void successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SColors.white,
      backgroundColor: SColors.success,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(SSize.md),
      icon: const Icon(
        Iconsax.tick_circle,
        color: SColors.white,
      ),
    );
  }

  // Error Snackbar
  static void errorSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SColors.white,
      backgroundColor: SColors.error,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(SSize.md),
      icon: const Icon(
        Iconsax.close_circle,
        color: SColors.white,
      ),
    );
  }

  // Warning Snackbar
  static void warningSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: SColors.white,
      backgroundColor: SColors.warning,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(SSize.md),
      icon: const Icon(
        Iconsax.warning_2,
        color: SColors.white,
      ),
    );
  }
}