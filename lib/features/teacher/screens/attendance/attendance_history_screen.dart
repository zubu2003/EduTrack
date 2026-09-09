import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'widgets/attendance_history_header.dart';
import 'widgets/attendance_date_card.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const AttendanceHistoryScreen({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded attendance data
    final attendanceData = [
      {
        'date': '10 Aug 2026',
        'lecture': 'Lecture 6: Advanced Cloud Architectures',
        'present': 41,
        'absent': 4,
        'total': 45,
      },
      {
        'date': '08 Aug 2026',
        'lecture': 'Lecture 5: Container Orchestration',
        'present': 43,
        'absent': 2,
        'total': 45,
      },
      {
        'date': '05 Aug 2026',
        'lecture': 'Lecture 4: Microservices Deployment',
        'present': 40,
        'absent': 5,
        'total': 45,
      },
      {
        'date': '03 Aug 2026',
        'lecture': 'Lecture 3: CI/CD Pipelines',
        'present': 40,
        'absent': 3,
        'total': 45,
      },
      {
        'date': '01 Aug 2026',
        'lecture': 'Lecture 2: Serverless Computing',
        'present': 39,
        'absent': 6,
        'total': 45,
      },
      {
        'date': '29 Jul 2026',
        'lecture': 'Lecture 1: Introduction to Cloud Infrastructure',
        'present': 42,
        'absent': 3,
        'total': 45,
      },
    ];

    // Calculate average attendance
    int totalPresent = 0;
    int totalStudents = 0;
    for (var item in attendanceData) {
      totalPresent += item['present'] as int;
      totalStudents += item['total'] as int;
    }
    final avgAttendance = totalStudents > 0
        ? ((totalPresent / totalStudents) * 100).toStringAsFixed(1)
        : '0';

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

              // Header
              AttendanceHistoryHeader(
                courseCode: courseCode,
                courseName: courseName,
              ),

              const SizedBox(height: SSize.spaceBtwItems),


              // History List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  final item = attendanceData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                    child: AttendanceDateCard(
                      date: item['date']! as String,
                      lecture: item['lecture']! as String ,
                      present: item['present']! as int,
                      absent: item['absent']! as int,
                      total: item['total']! as int,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.takeAttendance,
                          arguments: {
                            'courseCode': courseCode,
                            'courseName': courseName,
                            'isEditing': true,
                            'date': item['date'],
                          },
                        );
                      },
                    ),
                  );
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