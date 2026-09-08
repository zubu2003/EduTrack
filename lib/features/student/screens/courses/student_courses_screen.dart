import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../course_details/student_course_details_screen.dart';
import 'widgets/courses_header.dart';
import 'widgets/course_card.dart';

class StudentCoursesScreen extends StatelessWidget {
  final bool showTodayOnly;

  const StudentCoursesScreen({
    super.key,
    this.showTodayOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine title and subtitle
    final title = showTodayOnly ? "Today's Classes" : 'My Courses';
    final subtitle = showTodayOnly
        ? 'Your classes scheduled for today.'
        : 'Manage your current academic semester.';

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: showTodayOnly,
        onBackPressed: showTodayOnly ? () => Get.back() : null,
      ),
      body: Column(
        children: [
          // Header with dynamic title
          CoursesHeader(
            title: title,
            subtitle: subtitle,
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Course List with hardcoded data
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.defaultSpace,
                vertical: SSize.sm,
              ),
              itemCount: 4, // Hardcoded count
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                  child: CourseCard(
                    courseCode: 'CSE 30${index + 1}',
                    courseName: 'Course ${index + 1}',
                    teacherName: 'Dr. Teacher ${index + 1}',
                    attendance: '${80 + index * 5}%',
                    color: SColors.primary,
                    progress: 0.80 + (index * 0.05),
                    onTap: () => Get.to(StudentCourseDetailsScreen(
                      courseCode: 'CSE 30${index + 1}',
                      courseName: 'Course ${index + 1}',)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: StudentBottomNav(
        currentIndex: showTodayOnly ? 0 : 1,
      ),
    );
  }
}