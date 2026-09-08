import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AddDetailsBottomSheet extends StatelessWidget {
  const AddDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SSize.defaultSpace),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SSize.cardRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: SColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Title
          Text(
            'Add Details',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SColors.textPrimary,
            ),
          ),
          const SizedBox(height: SSize.xs),

          Text(
            'Add additional information to your profile',
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
          const SizedBox(height: SSize.spaceBtwSections),

          // Form Fields
          _buildField(
            label: 'Student/Teacher ID',
            hint: 'e.g. STU-2024-001',
            icon: Iconsax.document,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          _buildField(
            label: 'Department',
            hint: 'e.g. CSE',
            icon: Iconsax.building,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          _buildField(
            label: 'Batch/Year',
            hint: 'e.g. 2024',
            icon: Iconsax.calendar,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          _buildField(
            label: 'Phone',
            hint: 'e.g. +880 1234 567890',
            icon: Iconsax.call,
          ),
          const SizedBox(height: SSize.spaceBtwSections),

          // Add Button (Accent Color - Purple)
          SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Coming Soon',
                  'Add Details functionality will be added later',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                'Add Details',
                style: TextStyle(
                  color: SColors.white,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: SSize.sm),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: SColors.grey.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: SColors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide(
                color: SColors.grey.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide(
                color: SColors.grey.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}