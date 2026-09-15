import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/student/controllers/attendance/student_attendance_controller.dart';
import 'package:edutrack/features/student/controllers/ct_marks/student_ct_marks_controller.dart';
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
    // Attendance controller
    final attTag = 'student_att_${course.courseId}';
    final attendanceController = Get.put(
      StudentAttendanceController(course: course),
      tag: attTag,
    );

    // ✅ CT Marks controller (same tag as CT Marks screen — shares data)
    final ctTag = 'student_ct_${course.courseId}';
    final ctController = Get.put(
      StudentCtMarksController(course: course),
      tag: ctTag,
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
              CourseDetailsHeader(course: course),
              const SizedBox(height: SSize.spaceBtwSections),

              // ✅ Stats: attendance + CT average
              Obx(
                    () => CourseDetailsStats(
                  attendancePercent: attendanceController.percentage,
                  presentCount: attendanceController.presentCount,
                  totalCount: attendanceController.totalCount,
                  isAttendanceLoading: attendanceController.isLoading.value,
                  ctAverage: ctController.getAverage(),
                  ctFullMarks:
                  ctController.ctData.value?.fullMarks ?? 20,
                  isCtLoading: ctController.isLoading.value,
                ),
              ),

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
                onTap: () => Get.toNamed(
                  AppRoutes.studentCtMarks,
                  arguments: course,
                ),
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