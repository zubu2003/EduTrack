import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'teacher_progress_item.dart';

class TeacherCourseProgress extends StatelessWidget {
  const TeacherCourseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'name': 'CSE 356: Software Eng.', 'progress': 'Week 8/14', 'value': 0.57},
      {'name': 'CSE 412: AI', 'progress': 'Week 6/14', 'value': 0.43},
      {'name': 'CSE 201: Data Structures', 'progress': 'Week 8/14', 'value': 0.57},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
        const SizedBox(height: SSize.spaceBtwItems),
        ...courses.map((course) {
          return Padding(
            padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
            child: TeacherProgressItem(
              courseName: course['name']! as String,
              progress: course['progress']! as String,
              value: course['value']! as double,
            ),
          );
        }).toList(),
      ],
    );
  }
}