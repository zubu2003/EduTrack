import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';
import 'add_details_bottom_sheet.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Edit Profile Button (Outline - Primary)
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.editProfile);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: SColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: SSize.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.edit,
                  color: SColors.primary,
                  size: SSize.iconMd,
                ),
                const SizedBox(width: SSize.sm),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: SColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: SSize.spaceBtwItems),

        // Add Details Button (Filled - Secondary/Accent Color)
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddDetailsBottomSheet(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: SSize.md),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.add,
                  color: SColors.white,
                  size: SSize.iconMd,
                ),
                const SizedBox(width: SSize.sm),
                Text(
                  'Add Details',
                  style: TextStyle(
                    color: SColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}