import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CourseDetailsHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final int students;
  final String section;

  const CourseDetailsHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.students,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          // Course Code + Section Badge
          Row(
            children: [
              Text(
                courseCode,
                style: TextStyle(
                  color: SColors.white.withOpacity(0.7),
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: SSize.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: SColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Text(
                  'Sec $section',
                  style: TextStyle(
                    color: SColors.white,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SSize.sm),

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

          // Students Info
          Row(
            children: [
              Icon(
                Iconsax.people,
                color: SColors.white.withOpacity(0.7),
                size: SSize.iconSm,
              ),
              const SizedBox(width: SSize.xs),
              Text(
                '$students Students Enrolled',
                style: TextStyle(
                  color: SColors.white.withOpacity(0.7),
                  fontSize: SSize.fontSizeMd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}