import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/teacher/controllers/dashboard/teacher_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherStatsRow extends StatelessWidget {
  const TeacherStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherDashboardController>();

    return Obx(() {
      final stats = [
        {
          'label': "Today's Classes",
          'value':
          controller.todayClassesCount.value.toString().padLeft(2, '0'),
          'icon': Iconsax.clipboard,
          'color': SColors.primary,
        },
        {
          'label': 'Total Courses',
          'value': controller.totalCoursesCount.value.toString(),
          'icon': Iconsax.book,
          'color': const Color(0xFF6C63FF),
        },
        {
          'label': 'Total Students',
          'value': controller.totalStudentsCount.value.toString(),
          'icon': Iconsax.people,
          'color': const Color(0xFF4A90D9),
        },
      ];

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: stats.map((stat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: SSize.sm),
                padding: const EdgeInsets.all(SSize.sm),
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(SSize.cardRadius),
                  border: Border.all(
                    color: (stat['color'] as Color).withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          stat['icon'] as IconData,
                          color: stat['color'] as Color,
                          size: SSize.iconSm,
                        ),
                        const Spacer(),
                        Text(
                          stat['value'] as String,
                          style: TextStyle(
                            color: stat['color'] as Color,
                            fontSize: SSize.fontSizeXxl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}