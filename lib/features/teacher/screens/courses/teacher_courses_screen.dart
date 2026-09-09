import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/teacher_courses_header.dart';
import 'widgets/teacher_course_card.dart';

class TeacherCoursesScreen extends StatelessWidget {
  final bool showTodayOnly;

  const TeacherCoursesScreen({
    super.key,
    this.showTodayOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine title and subtitle
    final title = showTodayOnly ? "Today's Classes" : 'My Courses';
    final subtitle = showTodayOnly
        ? 'Your classes scheduled for today.'
        : 'Manage your teaching courses.';

    // Sample course data for teacher
    final courses = [
      {
        'code': 'CSE 356',
        'name': 'Software Engineering',
        'section': 'A',
        'students': 42,
        'progress': 0.57,
        'color': SColors.primary,
      },
      {
        'code': 'CSE 412',
        'name': 'Artificial Intelligence',
        'section': 'B',
        'students': 38,
        'progress': 0.43,
        'color': const Color(0xFF6C63FF),
      },
      {
        'code': 'CSE 201',
        'name': 'Data Structures',
        'section': 'A',
        'students': 45,
        'progress': 0.57,
        'color': const Color(0xFF4A90D9),
      },
      {
        'code': 'CSE 301',
        'name': 'Database Management',
        'section': 'C',
        'students': 35,
        'progress': 0.30,
        'color': const Color(0xFFF59E0B),
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
          TeacherCoursesHeader(
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
                  child: TeacherCourseCard(
                    courseCode: course['code'] as String,
                    courseName: course['name'] as String,
                    section: course['section'] as String,
                    students: course['students'] as int,
                    progress: course['progress'] as double,
                    color: course['color'] as Color,
                    // ❌ REMOVED onTap - let the card handle navigation
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TeacherBottomNav(
        currentIndex: 1,
      ),
    );
  }
}