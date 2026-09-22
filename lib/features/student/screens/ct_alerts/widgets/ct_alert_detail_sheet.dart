import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CtAlertDetailSheet extends StatelessWidget {
  final CtAlertModel alert;

  const CtAlertDetailSheet({super.key, required this.alert});

  static Future<void> show(BuildContext context, CtAlertModel alert) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SSize.borderRadiusXl),
        ),
      ),
      builder: (_) => CtAlertDetailSheet(alert: alert),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          SSize.defaultSpace,
          SSize.spaceBtwItems,
          SSize.defaultSpace,
          SSize.defaultSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: SSize.xs,
                decoration: BoxDecoration(
                  color: SColors.lightGrey,
                  borderRadius: BorderRadius.circular(SSize.borderRadiusPill),
                ),
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              alert.courseName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: SColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              alert.ctTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              alert.formattedDate,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: SSize.xs),
            Text(
              '${alert.durationMinutes} minutes',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
            ),
            const SizedBox(height: SSize.spaceBtwSections),
            Text(
              'Topics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(alert.topics, style: Theme.of(context).textTheme.bodyLarge),
            if (alert.reminder != null) ...[
              const SizedBox(height: SSize.spaceBtwSections),
              Text(
                alert.reminder!.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                alert.reminder!.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Text(
                'Suggested study hours: ${alert.reminder!.suggestedStudyHours.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
