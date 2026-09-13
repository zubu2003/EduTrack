import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String date;
  final bool isEditing;
  final VoidCallback onMarkAllPresent;

  const AttendanceHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.onMarkAllPresent,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF2D2D44),
          ],
        ),
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Course Code
          Text(
            courseCode,
            style: TextStyle(
              color: SColors.white.withOpacity(0.7),
              fontSize: SSize.fontSizeMd,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: SSize.xs),

          // Course Name
          Text(
            courseName,
            style: TextStyle(
              color: SColors.white,
              fontSize: SSize.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Date + Editing Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.calendar,
                    color: SColors.white.withOpacity(0.7),
                    size: SSize.iconSm,
                  ),
                  const SizedBox(width: SSize.xs),
                  Text(
                    date,
                    style: TextStyle(
                      color: SColors.white.withOpacity(0.7),
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
              if (isEditing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.sm,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'EDITING',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: SSize.fontSizeSm,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: SSize.sm),

          // Mark All Present Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onMarkAllPresent,
                style: TextButton.styleFrom(
                  backgroundColor: SColors.white.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.md,
                    vertical: SSize.xs,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.tick_circle,
                      color: SColors.white,
                      size: SSize.iconSm,
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      'Mark All Present',
                      style: TextStyle(
                        color: SColors.white,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}