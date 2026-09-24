import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/features/course/widgets/attendance_risk_badge.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceRiskBanner extends StatelessWidget {
  final AttendanceRiskModel risk;
  final VoidCallback onTap;

  const AttendanceRiskBanner({
    super.key,
    required this.risk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SColors.white,
      borderRadius: BorderRadius.circular(SSize.borderRadiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SSize.borderRadiusLg),
        child: Padding(
          padding: const EdgeInsets.all(SSize.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance risk',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      '${risk.attendancePercent.toStringAsFixed(1)}% attendance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: SColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      risk.recommendation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: SColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SSize.sm),
              AttendanceRiskBadge(level: risk.riskLevel),
              const SizedBox(width: SSize.xs),
              const Icon(Icons.chevron_right, color: SColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
