import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/image_string.dart';
import 'package:edutrack/utils/constant/size.dart';

class SFullScreenLoader {
  static void openLoadingDialog(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: SColors.textPrimary.withOpacity(0.6),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(SSize.lg),
              margin: const EdgeInsets.symmetric(
                horizontal: SSize.lg,
              ),
              decoration: BoxDecoration(
                color: SColors.white,
                borderRadius: BorderRadius.circular(
                  SSize.cardRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: SColors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie Loading Animation
                  Lottie.asset(
                    SImages.loadingAnimation,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),

                  const SizedBox(
                    height: SSize.spaceBtwItems,
                  ),

                  // Loading Message
                  SizedBox(
                    width: 220,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    if (Get.isDialogOpen ?? false) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
