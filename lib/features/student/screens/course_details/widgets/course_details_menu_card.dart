import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseDetailsMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const CourseDetailsMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
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
                color: SColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Icon(
                icon,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
            ),
            const SizedBox(width: SSize.spaceBtwItems),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.w600,
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
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: SColors.grey,
              size: SSize.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}