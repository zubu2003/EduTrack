import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseDetailsHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const CourseDetailsHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.defaultSpace),
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
          // Course Code and Type
          Row(
            children: [
              Text(
                courseCode,
                style: const TextStyle(
                  color: SColors.white,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.w600,
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
                child: const Text(
                  'Core',
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
            style: const TextStyle(
              color: SColors.white,
              fontSize: SSize.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Teacher Info
          const Row(
            children: [
              Icon(
                Icons.person_outline,
                color: SColors.white,
                size: SSize.iconSm,
              ),
              SizedBox(width: SSize.xs),
              Text(
                'Dr. XYZ',
                style: TextStyle(
                  color: SColors.white,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
            ],
          ),

          const SizedBox(height: SSize.xs),

          // Schedule
          const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: SColors.white,
                size: SSize.iconSm,
              ),
              SizedBox(width: SSize.xs),
              Text(
                'Mon, Wed 10:00 AM',
                style: TextStyle(
                  color: SColors.white,
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