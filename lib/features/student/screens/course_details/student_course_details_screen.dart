import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../routes/app_routes.dart';
import 'widgets/course_details_header.dart';
import 'widgets/course_details_stats.dart';
import 'widgets/course_details_menu_card.dart';

class StudentCourseDetailsScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const StudentCourseDetailsScreen({
    super.key,
    required this.courseCode,
    required this.courseName,
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

              // 1. Header with Gradient Card
              CourseDetailsHeader(
                courseCode: courseCode,
                courseName: courseName,
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // 2. Stats Section
              const CourseDetailsStats(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 3. Menu Cards
              CourseDetailsMenuCard(
                title: 'Attendance History',
                subtitle: 'View your attendance records',
                icon: Icons.calendar_today_outlined,
                onTap: () => Get.toNamed(AppRoutes.studentAttendanceHistory),
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
        currentIndex: 1, // Courses tab selected
      ),
    );
  }
}