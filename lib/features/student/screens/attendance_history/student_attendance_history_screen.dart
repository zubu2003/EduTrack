import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/attendance_history_header.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/attendance_session_item.dart';

class StudentAttendanceHistoryScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const StudentAttendanceHistoryScreen({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SSize.sm),

              // Header
              AttendanceHistoryHeader(
                courseCode: courseCode,
                courseName: courseName,
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Summary Card with Stats
              const AttendanceSummaryCard(),

              const SizedBox(height: SSize.spaceBtwItems),

              // Recent Sessions Title
              Text(
                'Recent Sessions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Session List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final sessions = [
                    {
                      'date': 'Oct 24, 2023',
                      'title': 'Lecture 20' ,
                      'status': 'Present',
                    },
                    {
                      'date': 'Oct 22, 2023',
                      'title': 'Lecture 19' ,
                      'status': 'Present',
                    },
                    {
                      'date': 'Oct 19, 2023',
                      'title': 'Lecture 18' ,
                      'status': 'Absent',
                    },
                    {
                      'date': 'Oct 17, 2023',
                      'title': 'Lecture 17' ,
                      'status': 'Present',
                    },
                  ];

                  final session = sessions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                    child: AttendanceSessionItem(
                      date: session['date']!,
                      title: session['title']!,
                      status: session['status']!,
                    ),
                  );
                },
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Load More Button
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'Load More',
                      'Loading more attendance records...',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SSize.lg,
                      vertical: SSize.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                      side: BorderSide(
                        color: SColors.primary.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Load More',
                        style: TextStyle(
                          color: SColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: SSize.fontSizeMd,
                        ),
                      ),
                      const SizedBox(width: SSize.xs),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: SColors.primary,
                        size: SSize.iconMd,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}