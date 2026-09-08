import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseDetailsStats extends StatelessWidget {
  const CourseDetailsStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Total Attendance Card
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
                      '85%',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      '(42/50)',
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

        // Average CT Marks Card
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
                      '16.5',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      '/ 20',
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