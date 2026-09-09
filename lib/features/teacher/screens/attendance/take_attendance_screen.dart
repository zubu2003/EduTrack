import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/attendance_header.dart';
import 'widgets/attendance_student_item.dart';
import 'widgets/attendance_summary_footer.dart';

class TakeAttendanceScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final bool isEditing;
  final String? date;

  const TakeAttendanceScreen({
    super.key,
    required this.courseCode,
    required this.courseName,
    this.isEditing = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded student data (will come from backend later)
    final students = [
      {'name': 'John Doe', 'id': '112233445', 'isPresent': true},
      {'name': 'Alice Smith', 'id': '112233446', 'isPresent': true},
      {'name': 'Bob Johnson', 'id': '112233447', 'isPresent': false},
      {'name': 'Emily White', 'id': '112233448', 'isPresent': true},
      {'name': 'Michael Davis', 'id': '112233449', 'isPresent': true},
      {'name': 'Sarah Lee', 'id': '112233450', 'isPresent': false},
      {'name': 'David Brown', 'id': '112233451', 'isPresent': true},
    ];

    // Calculate stats
    final presentCount = students.where((s) => s['isPresent'] == true).length;
    final absentCount = students.where((s) => s['isPresent'] == false).length;

    final displayDate = date ?? '10 Aug 2026';

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          // Header
          AttendanceHeader(
            courseCode: courseCode,
            courseName: courseName,
            date: displayDate,
            isEditing: isEditing,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SSize.sm),
                  child: AttendanceStudentItem(
                    name: student['name']! as String,
                    id: student['id']! as String,
                    isPresent: student['isPresent']! as bool,
                  ),
                );
              },
            ),
          ),

          // Footer with Submit Button
          AttendanceSummaryFooter(
            presentCount: presentCount,
            absentCount: absentCount,
            isEditing: isEditing,
          ),
          const SizedBox(height: SSize.sm),
        ],
      ),
    );
  }
}