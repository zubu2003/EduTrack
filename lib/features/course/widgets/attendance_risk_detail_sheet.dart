import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'attendance_risk_badge.dart';

class AttendanceRiskDetailSheet extends StatelessWidget {
  final AttendanceRiskModel risk;

  const AttendanceRiskDetailSheet({super.key, required this.risk});

  static Future<void> show(BuildContext context, AttendanceRiskModel risk) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SSize.borderRadiusXl),
        ),
      ),
      builder: (_) => AttendanceRiskDetailSheet(risk: risk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SSize.defaultSpace,
          SSize.spaceBtwItems,
          SSize.defaultSpace,
          SSize.defaultSpace,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    risk.studentName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                ),
                AttendanceRiskBadge(level: risk.riskLevel),
              ],
            ),
            const SizedBox(height: SSize.xs),
            Text(
              '${risk.attendancePercent.toStringAsFixed(1)}% attendance',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
            ),
            const SizedBox(height: SSize.spaceBtwSections),
            Text(
              'Why this risk level',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(risk.reason, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'Recommended action',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              risk.recommendation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
