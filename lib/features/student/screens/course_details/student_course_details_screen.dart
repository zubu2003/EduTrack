import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/student/controllers/attendance/student_attendance_controller.dart';
import 'package:edutrack/features/student/screens/attendance_history/student_attendance_history_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../routes/app_routes.dart';
import 'widgets/course_details_header.dart';
import 'widgets/course_details_stats.dart';
import 'widgets/course_details_menu_card.dart';

class StudentCourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const StudentCourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'student_att_${course.courseId}';
    final attendanceController = Get.put(
      StudentAttendanceController(course: course),
      tag: tag,
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: SSize.sm),
              CourseDetailsHeader(
                courseCode: course.courseCode,
                courseName: course.courseName,
              ),
              const SizedBox(height: SSize.spaceBtwSections),
              Obx(() => CourseDetailsStats(
                    attendancePercent: attendanceController.percentage,
                    presentCount: attendanceController.presentCount,
                    totalCount: attendanceController.totalCount,
                    isAttendanceLoading: attendanceController.isLoading.value,
                  )),
              const SizedBox(height: SSize.spaceBtwSections),
              CourseDetailsMenuCard(
                title: 'Attendance History',
                subtitle: 'View your attendance records',
                icon: Icons.calendar_today_outlined,
                onTap: () => Get.to(
                  () => StudentAttendanceHistoryScreen(course: course),
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              CourseDetailsMenuCard(
                title: 'CT Marks',
                subtitle: 'View your class test marks',
                icon: Icons.edit_note_outlined,
                onTap: () => Get.toNamed(AppRoutes.studentCtMarks),
              ),
              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const StudentBottomNav(
        currentIndex: 1,
      ),
    );
  }
}
