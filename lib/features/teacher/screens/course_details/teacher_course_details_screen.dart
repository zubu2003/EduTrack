import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'widgets/course_details_header.dart';
import 'widgets/course_details_stats.dart';
import 'widgets/course_details_action_card.dart';

class TeacherCourseDetailsScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final int students;
  final String section;

  const TeacherCourseDetailsScreen({
    super.key,
    this.courseCode = 'CSE 356',
    this.courseName = 'Software Engineering',
    this.students = 45,
    this.section = 'A',
  });

  @override
  Widget build(BuildContext context) {
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

              // 1. Header Card
              CourseDetailsHeader(
                courseCode: courseCode,
                courseName: courseName,
                students: students,
                section: section,
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // 2. Stats Row (3 cards)
              const CourseDetailsStats(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 3. Take Attendance
              CourseDetailsActionCard(
                icon: Icons.person_add_alt_1,
                title: 'Take Attendance',
                subtitle: 'Mark present, absent, or late for today\'s session.',
                buttonText: 'START SESSION',
                buttonColor: SColors.primary,
                routeName: AppRoutes.takeAttendance,
                arguments: {
                  'courseCode': courseCode,
                  'courseName': courseName,
                },
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // 4. CT Marks
              CourseDetailsActionCard(
                icon: Icons.edit_note,
                title: 'CT Marks',
                subtitle: 'Enter and review Class Test scores and distributions.',
                buttonText: 'MANAGE MARKS',
                buttonColor: const Color(0xFF6C63FF),
                routeName: AppRoutes.teacherCtMarks,
                arguments: {
                  'courseCode': courseCode,
                  'courseName': courseName,
                },
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // 5. Attendance History
              CourseDetailsActionCard(
                icon: Icons.history,
                title: 'Attendance History',
                subtitle:
                'View past records, modify entries, and generate exportable reports.',
                buttonText: 'VIEW HISTORY',
                buttonColor: const Color(0xFF4A90D9),
                routeName: AppRoutes.attendanceHistory,
                arguments: {
                  'courseCode': courseCode,
                  'courseName': courseName,
                },
              ),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(
        currentIndex: 1,
      ),
    );
  }
}