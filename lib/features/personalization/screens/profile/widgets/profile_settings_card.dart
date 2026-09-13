import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';
import 'package:iconsax/iconsax.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  /// Show Logout Confirmation
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SSize.cardRadius),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: SColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeMd,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: SColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              try {
                await AuthenticationRepository.instance.logout();
              } catch (e) {
                SSnackBarHelpers.errorSnackBar(
                  title: 'Error',
                  message: e.toString(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: SColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              Icon(
                Iconsax.setting_2,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
              const SizedBox(width: SSize.sm),
              Text(
                'Settings',
                style: TextStyle(
                  color: SColors.textPrimary,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          Divider(
            color: SColors.grey.withOpacity(0.2),
            height: 1,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Dark Mode
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SSize.xs),
            child: Row(
              children: [
                Icon(
                  Iconsax.moon,
                  color: SColors.primary,
                  size: SSize.iconMd,
                ),
                const SizedBox(width: SSize.spaceBtwItems),
                Expanded(
                  child: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    SSnackBarHelpers.warningSnackBar(
                      title: 'Coming Soon',
                      message: 'Dark mode will be available soon',
                    );
                  },
                  activeColor: SColors.primary,
                ),
              ],
            ),
          ),

          // Logout
          InkWell(
            onTap: _showLogoutDialog,
            borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: SSize.xs),
              child: Row(
                children: [
                  Icon(
                    Iconsax.logout,
                    color: SColors.error,
                    size: SSize.iconMd,
                  ),
                  const SizedBox(width: SSize.spaceBtwItems),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: SColors.error,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: SColors.error,
                    size: SSize.iconSm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}