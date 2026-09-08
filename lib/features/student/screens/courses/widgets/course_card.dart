import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/teacher/teacher_info.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';

class CourseCard extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String teacherName;
  final String attendance;
  final Color color;
  final double progress;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.teacherName,
    required this.attendance,
    required this.color,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
              () {
            Get.toNamed(
              AppRoutes.studentCourseDetails,
              arguments: {
                'courseCode': courseCode,
                'courseName': courseName,
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
            Row(
              children: [
                Container(
                  width: 4,
                  height: 32,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.md,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: color,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        attendance,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: SSize.fontSizeMd,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),
            Text(
              courseName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.sm),
            STeacherInfoWidget(
              teacherName: teacherName,
              avatarRadius: 16,
              fontSize: SSize.fontSizeMd,
            ),
            const SizedBox(height: SSize.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                    Text(
                      attendance,
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