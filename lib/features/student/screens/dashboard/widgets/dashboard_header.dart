import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/student/controllers/dashboard/student_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final name = controller.user.value.name.isNotEmpty
              ? controller.user.value.name
              : 'Student';

          return Row(
            children: [
              Text(
                controller.greeting,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SColors.textSecondary,
                ),
              ),
              const SizedBox(width: SSize.xs),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }),

        const SizedBox(height: SSize.xs),

        Text(
          "Here's your academic overview for today.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),
      ],
    );
  }
}