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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Code
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
          const SizedBox(height: SSize.sm),

          // Title
          Text(
            'CT Marks',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SColors.textPrimary,
            ),
          ),
          const SizedBox(height: SSize.xs),

          // Course Name
          Text(
            courseName,
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
        ],
      ),
    );
  }
}