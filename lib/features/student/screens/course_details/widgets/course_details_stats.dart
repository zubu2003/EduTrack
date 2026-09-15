import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseDetailsStats extends StatelessWidget {
  final double attendancePercent;
  final int presentCount;
  final int totalCount;
  final bool isAttendanceLoading;

  // ✅ New: CT data
  final double ctAverage;
  final double ctFullMarks;
  final bool isCtLoading;

  const CourseDetailsStats({
    super.key,
    this.attendancePercent = 0,
    this.presentCount = 0,
    this.totalCount = 0,
    this.isAttendanceLoading = false,
    this.ctAverage = 0,
    this.ctFullMarks = 20,
    this.isCtLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ─── Attendance Card ───
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(SSize.md),
            decoration: BoxDecoration(
              color: SColors.white,
              borderRadius: BorderRadius.circular(SSize.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: SColors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Attendance',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isAttendanceLoading
                          ? '--'
                          : '${attendancePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      isAttendanceLoading
                          ? ''
                          : '($presentCount/$totalCount)',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: SSize.spaceBtwItems),

        // ─── CT Average Card ───
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(SSize.md),
            decoration: BoxDecoration(
              color: SColors.white,
              borderRadius: BorderRadius.circular(SSize.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: SColors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average CT Marks',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isCtLoading
                          ? '--'
                          : ctAverage.toStringAsFixed(1),
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      isCtLoading
                          ? ''
                          : '/ ${ctFullMarks.toInt()}',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}