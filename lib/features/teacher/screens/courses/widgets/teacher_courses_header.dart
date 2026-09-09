import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class TeacherCoursesHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const TeacherCoursesHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SColors.textPrimary,
            ),
          ),
          const SizedBox(height: SSize.xs),
          Text(
            subtitle,
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