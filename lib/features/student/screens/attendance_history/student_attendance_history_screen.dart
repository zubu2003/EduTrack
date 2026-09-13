import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/student/controllers/attendance/student_attendance_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/attendance_history_header.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/attendance_session_item.dart';

class StudentAttendanceHistoryScreen extends StatelessWidget {
  final CourseModel course;

  const StudentAttendanceHistoryScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'student_att_${course.courseId}';
    final controller = Get.isRegistered<StudentAttendanceController>(tag: tag)
        ? Get.find<StudentAttendanceController>(tag: tag)
        : Get.put(StudentAttendanceController(course: course), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }

        if (controller.records.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SSize.sm),
                AttendanceHistoryHeader(
                  courseCode: course.courseCode,
                  courseName: course.courseName,
                ),
                const SizedBox(height: SSize.spaceBtwItems),
                AttendanceSummaryCard(
                  percentage: controller.percentage,
                  presentCount: controller.presentCount,
                  absentCount: controller.absentCount,
                  totalCount: controller.totalCount,
                ),
                const SizedBox(height: SSize.spaceBtwItems),
                Text(
                  'Recent Sessions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SColors.textPrimary,
                      ),
                ),
                const SizedBox(height: SSize.spaceBtwItems),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.records.length,
                  itemBuilder: (context, index) {
                    final record = controller.records[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                      child: AttendanceSessionItem(
                        date: record['date'] as String,
                        title: (record['lecture'] as String).isEmpty
                            ? 'Lecture'
                            : record['lecture'] as String,
                        status: _statusLabel(record['status'] as String),
                      ),
                    );
                  },
                ),
                const SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'present':
        return 'Present';
      case 'late':
        return 'Late';
      default:
        return 'Absent';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.calendar_remove,
              size: 80,
              color: SColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'No Attendance Yet',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              'Your teacher has not taken attendance for this course yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SColors.textSecondary,
                fontSize: SSize.fontSizeMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
