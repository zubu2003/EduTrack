import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class UploadCtMarksHeader extends StatelessWidget {
  final String courseCode;
  final String ctTitle;

  const UploadCtMarksHeader({
    super.key,
    required this.courseCode,
    required this.ctTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        // Course Code & CT Title
        Row(
          children: [
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
            const SizedBox(width: SSize.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.sm,
                vertical: SSize.xs,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              ),
              child: Text(
                ctTitle,
                style: TextStyle(
                  color: const Color(0xFF6C63FF),
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: SSize.sm),

        // Title
        Text(
          'Upload Marks',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
      ],
    );
  }
}