import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/attendance/teacher_attendance_controller.dart';
import 'package:edutrack/features/teacher/screens/attendance/take_attendance_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/attendance_history_header.dart';
import 'widgets/attendance_date_card.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final CourseModel course;

  const AttendanceHistoryScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TeacherAttendanceController(course: course),
      tag: 'history_${course.courseId}',
    );

    // Fetch sessions on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSessions();
    });

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Obx(() {
        if (controller.sessions.isEmpty) {
          return _buildEmptyState();
        }

        // Compute average
        int totalPresent = 0;
        int totalStudents = 0;
        for (var s in controller.sessions) {
          totalPresent += s.presentCount;
          totalStudents += s.totalStudents;
        }
        final avg = totalStudents > 0
            ? ((totalPresent / totalStudents) * 100).toStringAsFixed(1)
            : '0';

        return SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: SSize.sm),

                AttendanceHistoryHeader(
                  courseCode: course.courseCode,
                  courseName: course.courseName,
                ),

                const SizedBox(height: SSize.spaceBtwItems),

                // Session List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.sessions.length,
                  itemBuilder: (context, index) {
                    final session = controller.sessions[index];
                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                      child: AttendanceDateCard(
                        date: session.formattedDate,
                        lecture: session.lecture,
                        present: session.presentCount,
                        absent: session.absentCount,
                        total: session.totalStudents,
                        onTap: () => Get.to(
                              () => TakeAttendanceScreen(
                            course: course,
                            session: session,
                          ),
                        ),
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
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
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
              'No Attendance Sessions',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              'Take your first attendance to see it here',
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