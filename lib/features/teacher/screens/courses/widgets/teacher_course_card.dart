import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';

class TeacherCourseCard extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String section;
  final int students;
  final double progress;
  final Color color;

  const TeacherCourseCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.section,
    required this.students,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to course details with arguments
        Get.toNamed(
          AppRoutes.teacherCourseDetails,
          arguments: {
            'courseCode': courseCode,
            'courseName': courseName,
            'students': students,
            'section': section,
          },
        );
      },
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
            // Top Row: Course Code + Stats
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                ),
                const SizedBox(width: SSize.sm),
                Expanded(
                  child: Text(
                    courseCode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                ),
                // Students Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.sm,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.people,
                        color: color,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        '$students',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: SSize.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SSize.sm),
                // Section Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.sm,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                  child: Text(
                    'Sec $section',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: SSize.fontSizeSm,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),

            // Course Name
            Text(
              courseName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.sm),

            // Progress Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Class Progress',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SSize.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: SColors.grey.withOpacity(0.15),
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),

            // View Details Arrow
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
                Icon(
                  Icons.arrow_forward_ios,
                  color: SColors.primary,
                  size: SSize.iconSm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}