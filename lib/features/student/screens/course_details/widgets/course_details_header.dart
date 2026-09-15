import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CourseDetailsHeader extends StatelessWidget {
  final CourseModel course;

  const CourseDetailsHeader({
    super.key,
    required this.course,
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
          // Course Code + Credit Badge
          Row(
            children: [
              Text(
                course.courseCode,
                style: const TextStyle(
                  color: SColors.white,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: SSize.sm),
              if (course.credit > 0)
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
                    '${course.credit} Credits',
                    style: const TextStyle(
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
            course.courseName,
            style: const TextStyle(
              color: SColors.white,
              fontSize: SSize.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Teacher Info
          if (course.teacherName.isNotEmpty) ...[
            const SizedBox(height: SSize.spaceBtwItems),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: SColors.white,
                  size: SSize.iconSm,
                ),
                const SizedBox(width: SSize.xs),
                Text(
                  course.teacherName,
                  style: const TextStyle(
                    color: SColors.white,
                    fontSize: SSize.fontSizeMd,
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