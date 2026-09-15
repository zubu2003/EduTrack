import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/student/controllers/dashboard/student_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../../routes/app_routes.dart';
import 'dashboard_class_card.dart';

class DashboardTodaysClasses extends StatelessWidget {
  const DashboardTodaysClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();

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
              ),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.studentTodaysClasses);
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

        Obx(() {
          if (controller.todayClasses.isEmpty) {
            return Container(
              width: double.infinity,
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
                children: [
                  Icon(
                    Icons.event_busy,
                    color: SColors.grey,
                    size: 40,
                  ),
                  const SizedBox(height: SSize.sm),
                  Text(
                    'No classes today',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: controller.todayClasses.map((routine) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                child: DashboardClassCard(
                  routine: routine,
                  onTap: () => controller.openCourseDetails(routine),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}