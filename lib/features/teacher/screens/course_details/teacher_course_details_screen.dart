import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/courses/teacher_course_details_controller.dart';
import 'package:edutrack/features/teacher/screens/attendance/attendance_history_screen.dart';
import 'package:edutrack/features/teacher/screens/attendance/take_attendance_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/teacher_ct_marks_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/course_details_header.dart';
import 'widgets/course_details_stats.dart';
import 'widgets/course_details_action_card.dart';

class TeacherCourseDetailsScreen extends StatelessWidget {
  final CourseModel course;

  const TeacherCourseDetailsScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'course_details_${course.courseId}';
    final already =
        Get.isRegistered<TeacherCourseDetailsController>(tag: tag);
    final statsController = already
        ? Get.find<TeacherCourseDetailsController>(tag: tag)
        : Get.put(TeacherCourseDetailsController(course: course), tag: tag);
    if (already) {
      statsController.fetchStats();
    }

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
                students: course.totalStudents,
                section: course.section,
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              Obx(() => CourseDetailsStats(
                    totalClasses: statsController.totalClasses.value,
                    avgAttendance: statsController.avgAttendance.value,
                    ctAverage: statsController.ctAverage.value,
                    ctFullMarks: statsController.ctFullMarks.value,
                    isLoading: statsController.isLoading.value,
                  )),

              const SizedBox(height: SSize.spaceBtwSections),

              // Take Attendance
              CourseDetailsActionCard(
                icon: Icons.person_add_alt_1,
                title: 'Take Attendance',
                subtitle: 'Mark present, absent, or late for today\'s session.',
                buttonText: 'START SESSION',
                buttonColor: SColors.primary,
                onTap: () => Get.to(
                      () => TakeAttendanceScreen(course: course),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // CT Marks
              CourseDetailsActionCard(
                icon: Icons.edit_note,
                title: 'CT Marks',
                subtitle: 'Enter and review Class Test scores and distributions.',
                buttonText: 'MANAGE MARKS',
                buttonColor: const Color(0xFF6C63FF),
                onTap: () => Get.to(
                      () => TeacherCtMarksScreen(course: course),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Attendance History
              CourseDetailsActionCard(
                icon: Icons.history,
                title: 'Attendance History',
                subtitle:
                'View past records, modify entries, and generate exportable reports.',
                buttonText: 'VIEW HISTORY',
                buttonColor: const Color(0xFF4A90D9),
                onTap: () => Get.to(
                      () => AttendanceHistoryScreen(course: course),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
  }
}