import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CtMarksHeader extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const CtMarksHeader({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row: CT Marks (Left) | Course Code (Right)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // CT Marks - Left
            Text(
              'CT Marks',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            // Course Code - Right
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.sm,
                vertical: SSize.xs,
              ),
              decoration: BoxDecoration(
                color: SColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              ),
              child: Text(
                courseCode,
                style: TextStyle(
                  color: SColors.primary,
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: SSize.xs),

        // Course Name Subtitle
        Text(
          courseName,
          style: TextStyle(
            color: SColors.textPrimary,
            fontSize: SSize.fontSizeMd,
          ),
        ),
      ],
    );
  }
}