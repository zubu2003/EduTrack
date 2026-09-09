import 'package:edutrack/features/student/screens/courses/widgets/course_card.dart';
import 'package:edutrack/features/student/screens/courses/widgets/courses_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';

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

    // Sample course data
    final courses = [
      {
        'code': 'CSE 356',
        'name': 'Software Engineering',
        'teacher': 'Dr. XYZ',
        'attendance': '85%',
        'color': SColors.primary,
        'progress': 0.85,
      },
      {
        'code': 'MAT 211',
        'name': 'Linear Algebra',
        'teacher': 'Prof. ABC',
        'attendance': '92%',
        'color': SColors.success,
        'progress': 0.92,
      },
      {
        'code': 'PHY 131',
        'name': 'Classical Physics I',
        'teacher': 'Dr. LMN',
        'attendance': '74%',
        'color': SColors.warning,
        'progress': 0.74,
      },
      {
        'code': 'EEE 201',
        'name': 'Electrical Circuits',
        'teacher': 'Dr. ABC',
        'attendance': '72%',
        'color': SColors.error,
        'progress': 0.72,
      },
    ];

    // Filter if showing today only
    final displayCourses = showTodayOnly ? courses.take(2).toList() : courses;

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: showTodayOnly,
        onBackPressed: showTodayOnly ? () => Get.back() : null,
      ),
      body: Column(
        children: [
          StudentCoursesHeader(
            title: title,
            subtitle: subtitle,
          ),
          const SizedBox(height: SSize.spaceBtwItems),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.defaultSpace,
                vertical: SSize.sm,
              ),
              itemCount: displayCourses.length,
              itemBuilder: (context, index) {
                final course = displayCourses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                  child: StudentCourseCard(
                    courseCode: course['code'] as String,
                    courseName: course['name'] as String,
                    teacherName: course['teacher'] as String,
                    attendance: course['attendance'] as String,
                    color: course['color'] as Color,
                    progress: course['progress'] as double,
                    onTap: () {
                      // Navigate to Student Course Details
                      Get.toNamed(
                        AppRoutes.studentCourseDetails,
                        arguments: {
                          'courseCode': course['code'] as String,
                          'courseName': course['name'] as String,
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const StudentBottomNav(
        currentIndex: 1,
      ),
    );
  }
}