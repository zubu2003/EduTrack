import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String date;
  final bool isEditing;

  const AttendanceHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.date,
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

          // Date + Status Badge
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
              // Status Badge (Editing or New)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.md,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: isEditing
                      ? Colors.amber.withOpacity(0.2)
                      : SColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  border: Border.all(
                    color: isEditing
                        ? Colors.amber.withOpacity(0.3)
                        : SColors.white.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  isEditing ? 'EDITING' : 'NEW',
                  style: TextStyle(
                    color: isEditing ? Colors.amber : SColors.white,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          // Show "Mark All Present" only for new attendance
          if (!isEditing) ...[
            const SizedBox(height: SSize.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mark All Present feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
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
        ],
      ),
    );
  }
}