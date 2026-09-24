import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/features/student/controllers/ct_alert_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/ct_alert_card.dart';
import 'widgets/ct_alert_detail_sheet.dart';

class StudentCtAlertsScreen extends StatelessWidget {
  const StudentCtAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentCtAlertController());

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: () => Get.back()),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }
        if (controller.errorMessage.value != null) {
          return _StatusState(
            message: 'Unable to load CT alerts.',
            onRetry: controller.loadAlerts,
          );
        }
        if (controller.alerts.isEmpty) {
          return const _StatusState(message: 'No upcoming CT alerts yet.');
        }

        return RefreshIndicator(
          onRefresh: controller.loadAlerts,
          color: SColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            itemCount: controller.alerts.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: SSize.spaceBtwItems),
            itemBuilder: (context, index) {
              final alert = controller.alerts[index];
              return CtAlertCard(
                alert: alert,
                onTap: () => CtAlertDetailSheet.show(context, alert),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 0),
    );
  }
}

class _StatusState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _StatusState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: SColors.textSecondary),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: SSize.spaceBtwItems),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
