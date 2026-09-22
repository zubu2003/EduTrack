import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/student/controllers/ct_alert_controller.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'dashboard_ct_card.dart';

class DashboardUpcomingCTs extends StatelessWidget {
  const DashboardUpcomingCTs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentCtAlertController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Upcoming CTs',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.studentCtAlerts),
              icon: const Icon(Icons.arrow_forward, size: SSize.iconSm),
              label: const Text('View all'),
            ),
          ],
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        Obx(() {
          final alert = controller.alerts.isEmpty
              ? null
              : controller.alerts.first;

          return InkWell(
            onTap: () => Get.toNamed(AppRoutes.studentCtAlerts),
            borderRadius: BorderRadius.circular(SSize.cardRadius),
            child: DashboardCtCard(
              ctName: alert == null
                  ? 'CT Alerts'
                  : '${alert.ctTitle} (${alert.courseName})',
              date: alert?.formattedDate ?? 'View upcoming class tests',
              daysLeft: alert == null
                  ? 'VIEW'
                  : alert.daysRemaining == 0
                  ? 'TODAY'
                  : '${alert.daysRemaining} DAYS',
            ),
          );
        }),
      ],
    );
  }
}
