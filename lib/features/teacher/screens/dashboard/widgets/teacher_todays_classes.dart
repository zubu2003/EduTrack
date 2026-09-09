import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'teacher_class_card.dart';

class TeacherTodaysClasses extends StatelessWidget {
  const TeacherTodaysClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {
        'code': 'CSE 356',
        'name': 'Software Engineering',
        'room': 'Room 301, Engineering Bldg',
        'status': 'Take Attendance',
        'statusColor': const Color(0xFF4A6CF7),
        'bgColor': const Color(0xFFE8EDFB),
        'isOngoing': true,
      },
      {
        'code': 'CSE 412',
        'name': 'AI',
        'room': 'Lab 2, CS Bldg',
        'status': 'Upcoming',
        'statusColor': const Color(0xFF6C63FF),
        'bgColor': const Color(0xFFF5F0FF),
        'isOngoing': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Classes",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Today's Classes (Teacher)
                Get.toNamed(AppRoutes.teacherTodaysClasses);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  color: SColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SSize.spaceBtwItems),
        ...classes.map((classItem) {
          return Padding(
            padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
            child: TeacherClassCard(
              courseCode: classItem['code']! as String,
              courseName: classItem['name']! as String,
              room: classItem['room']! as String,
              status: classItem['status']! as String,
              statusColor: classItem['statusColor'] as Color,
              bgColor: classItem['bgColor'] as Color,
              isOngoing: classItem['isOngoing'] as bool,
            ),
          );
        }).toList(),
      ],
    );
  }
}