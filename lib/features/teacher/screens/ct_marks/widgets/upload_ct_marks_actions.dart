import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class UploadCtMarksActions extends StatelessWidget {
  const UploadCtMarksActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Confirm & Upload Button
        SizedBox(
          width: double.infinity,
          height: SSize.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Success',
                'Marks uploaded successfully!',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
            ),
            child: Text(
              'Confirm & Upload',
              style: TextStyle(
                color: SColors.white,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: SSize.spaceBtwItems),

        // Preview Marks Button
        SizedBox(
          width: double.infinity,
          height: SSize.buttonHeight,
          child: OutlinedButton(
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Preview Marks feature coming soon!',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: SColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
            ),
            child: Text(
              'Preview Marks',
              style: TextStyle(
                color: SColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: SSize.fontSizeLg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}