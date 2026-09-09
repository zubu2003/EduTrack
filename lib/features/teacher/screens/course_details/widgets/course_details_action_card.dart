import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';

class CourseDetailsActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final String? routeName;
  final Map<String, dynamic>? arguments;
  final VoidCallback? onTap;

  const CourseDetailsActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    this.routeName,
    this.arguments,
    this.onTap,
  });

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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Icon(
              icon,
              color: buttonColor,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
                const SizedBox(height: SSize.sm),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Priority: onTap > routeName > snackbar
                      if (onTap != null) {
                        onTap!();
                      } else if (routeName != null) {
                        Get.toNamed(routeName!, arguments: arguments);
                      } else {
                        Get.snackbar(
                          'Coming Soon',
                          '$title feature coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: SSize.sm,
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: SColors.white,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}