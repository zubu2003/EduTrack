import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class StudentCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const StudentCourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: SColors.primary,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                ),
                const SizedBox(width: SSize.sm),
                Expanded(
                  child: Text(
                    course.courseCode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.sm,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: SColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                  child: Text(
                    'Sec ${course.section}',
                    style: TextStyle(
                      color: SColors.primary,
                      fontSize: SSize.fontSizeSm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),
            Text(
              course.courseName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.sm),
            Row(
              children: [
                Icon(Iconsax.user, size: 14, color: SColors.grey),
                const SizedBox(width: 4),
                Text(
                  course.teacherName,
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.xs),
            Row(
              children: [
                Icon(Iconsax.building, size: 14, color: SColors.grey),
                const SizedBox(width: 4),
                Text(
                  SDepartments.getDeptName(course.department),
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
                const SizedBox(width: SSize.md),
                Icon(Iconsax.award, size: 14, color: SColors.grey),
                const SizedBox(width: 4),
                Text(
                  '${course.credit} Credits',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: SColors.primary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: SSize.xs),
                Icon(Icons.arrow_forward_ios,
                    color: SColors.primary, size: SSize.iconSm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}