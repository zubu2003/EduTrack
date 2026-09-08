import 'package:flutter/material.dart';
import 'package:edutrack/common/widget/logo/app_logo.dart';  // ✅ Correct path
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
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
          // App Logo (Circular, Small)
          const SAppLogo(
            size: 40,
            showText: false,
            isCircular: true,
          ),
          const SizedBox(width: SSize.xs),
          // App Name
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
        // Profile Icon with Dropdown
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'profile') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navigate to Profile'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (value == 'logout') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
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
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Iconsax.logout, color: SColors.error),
                  SizedBox(width: SSize.sm),
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