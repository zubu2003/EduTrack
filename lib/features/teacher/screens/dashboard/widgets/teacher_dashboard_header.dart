import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/teacher/controllers/dashboard/teacher_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class TeacherDashboardHeader extends StatelessWidget {
  const TeacherDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherDashboardController>();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.greeting,
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Obx(() {
                final name = controller.user.value.name.isNotEmpty
                    ? controller.user.value.name
                    : 'Teacher';

                return Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
              const SizedBox(height: SSize.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: SColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Text(
                  'Here is your academic overview for today.',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: SColors.primary.withOpacity(0.1),
          child: Icon(
            Icons.person_outline,
            color: SColors.primary,
            size: SSize.iconLg,
          ),
        ),
      ],
    );
  }
}