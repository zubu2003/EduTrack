import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/logo/app_logo.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';
import 'package:iconsax/iconsax.dart';

class SAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double? elevation;

  const SAppbar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation,
  });

  /// Show Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
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
              Get.back(); // Close dialog first
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

  /// Handle Popup Menu Selection
  void _handleMenuSelection(BuildContext context, String value) {
    if (value == 'profile') {
      // Navigate to profile based on role
      // For now, show snackbar
      SSnackBarHelpers.successSnackBar(
        title: 'Profile',
        message: 'Opening profile...',
      );
      // TODO: Navigate to profile screen
    } else if (value == 'logout') {
      _showLogoutDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: backgroundColor ?? SColors.backgroundColor,
      elevation: elevation ?? 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Iconsax.arrow_left, color: SColors.textPrimary),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      )
          : null,
      title: Row(
        children: [
          const SAppLogo(
            size: 40,
            showText: false,
            isCircular: true,
          ),
          const SizedBox(width: SSize.xs),
          Text(
            STextStrings.appName,
            style: TextStyle(
              color: SColors.primary,
              fontSize: SSize.fontSizeLg,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuSelection(context, value),
          offset: const Offset(0, 45),
          color: SColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
          ),
          elevation: 4,
          child: Container(
            margin: const EdgeInsets.only(right: SSize.md),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: SColors.primary.withOpacity(0.1),
              child: Icon(
                Iconsax.user,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Iconsax.user, color: SColors.textPrimary),
                  SizedBox(width: SSize.sm),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Iconsax.logout, color: SColors.error),
                  const SizedBox(width: SSize.sm),
                  Text(
                    'Logout',
                    style: TextStyle(color: SColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}