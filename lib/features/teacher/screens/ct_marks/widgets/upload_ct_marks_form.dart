import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:iconsax/iconsax.dart';

class UploadCtMarksForm extends StatelessWidget {
  const UploadCtMarksForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Marks Label
        Text(
          'Full Marks',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),

        // Full Marks Value
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SSize.md,
            vertical: SSize.sm,
          ),
          decoration: BoxDecoration(
            color: SColors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
            border: Border.all(
              color: SColors.grey.withOpacity(0.2),
            ),
          ),
          child: const Text(
            '20',
            style: TextStyle(
              color: SColors.textPrimary,
              fontSize: SSize.fontSizeLg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: SSize.spaceBtwSections),

        // Upload Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(SSize.lg),
          decoration: BoxDecoration(
            color: SColors.grey.withOpacity(0.03),
            borderRadius: BorderRadius.circular(SSize.cardRadius),
            border: Border.all(
              color: SColors.grey.withOpacity(0.2),
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Icon
              Icon(
                Iconsax.document_upload,
                color: SColors.primary,
                size: 48,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Title
              Text(
                'Upload Excel File (.xlsx)',
                style: TextStyle(
                  color: SColors.textPrimary,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),

              // Subtitle
              Text(
                'Drag and drop your generated marks sheet here,\nor click to browse your local files.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Browse Button
              OutlinedButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'File browser feature coming soon!',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: SColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.lg,
                    vertical: SSize.md,
                  ),
                ),
                child: Text(
                  'Browse Files',
                  style: TextStyle(
                    color: SColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}