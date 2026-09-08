import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceHistoryHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const AttendanceHistoryHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Code
        Text(
          courseCode,
          style: TextStyle(
            color: SColors.primary,
            fontSize: SSize.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: SSize.xs),

        // Title
        Text(
          'Attendance History',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
      ],
    );
  }
}