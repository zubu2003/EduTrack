import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/teacher/controllers/dashboard/teacher_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../../routes/app_routes.dart';
import 'teacher_class_card.dart';

class TeacherTodaysClasses extends StatelessWidget {
  const TeacherTodaysClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherDashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Classes",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.teacherTodaysClasses);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  color: SColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SSize.spaceBtwItems),

        Obx(() {
          if (controller.todayClasses.isEmpty) {
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
              child: Column(
                children: [
                  Icon(Icons.event_busy, color: SColors.grey, size: 40),
                  const SizedBox(height: SSize.sm),
                  Text(
                    'No classes today',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: controller.todayClasses.map((routine) {
              final isOngoing = _isRunning(routine);
              return Padding(
                padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                child: TeacherClassCard(
                  courseCode: routine.courseCode,
                  courseName: routine.courseName,
                  room: routine.room,
                  status: isOngoing ? 'Take Attendance' : 'Upcoming',
                  statusColor: isOngoing
                      ? const Color(0xFF4A6CF7)
                      : const Color(0xFF6C63FF),
                  bgColor: isOngoing
                      ? const Color(0xFFE8EDFB)
                      : const Color(0xFFF5F0FF),
                  isOngoing: isOngoing,
                  onTap: routine.courseCode == 'Others'
                      ? null
                      : () => controller.openCourseDetails(routine),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  bool _isRunning(dynamic routine) {
    final now = DateTime.now();
    final nowMin = now.hour * 60 + now.minute;
    final start = _toMinutes(routine.startTime as String);
    final end = _toMinutes(routine.endTime as String);
    return nowMin >= start && nowMin <= end;
  }

  int _toMinutes(String time) {
    try {
      final parts = time.trim().split(' ');
      if (parts.length != 2) return 0;
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final min = int.parse(hm[1]);
      if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
      if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      return hour * 60 + min;
    } catch (_) {
      return 0;
    }
  }
}