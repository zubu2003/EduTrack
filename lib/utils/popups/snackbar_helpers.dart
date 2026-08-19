import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constant/colors.dart';
import '../helper/helper_functions.dart';

class SSnackBarHelpers {

  static void customToast({required message}){
    ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: SHelperFunctions.isDarkMode(Get.context!) ? SColors.darkerGrey.withValues(alpha: 0.9) : SColors.grey.withValues(alpha: 0.9)
            ),
            child: Center(child: Text(message,style: Theme.of(Get.context!).textTheme.labelLarge,),),
          ),
        )
    );
  }

  /// Warning Orange Snack bar
  static void warningSnackBar({required title, message = ''}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: SColors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: SColors.white));
  }

  /// Success Green Snack bar
  static void successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: SColors.white,
        backgroundColor: SColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: SColors.white));
  }

  /// Error Red Snack bar
  static void errorSnackBar({required title, message = ''}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: SColors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: SColors.white));
  }
}
