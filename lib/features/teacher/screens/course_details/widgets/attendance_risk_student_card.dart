import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/features/course/widgets/attendance_risk_badge.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceRiskStudentCard extends StatelessWidget {
  final AttendanceRiskModel risk;
  final VoidCallback onTap;

  const AttendanceRiskStudentCard({
    super.key,
    required this.risk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.white,
      elevation: SSize.cardElevation,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(SSize.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: SColors.primary.withValues(alpha: 0.1),
                child: Text(
                  risk.studentName.isEmpty
                      ? '?'
                      : risk.studentName[0].toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: SColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: SSize.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      risk.studentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: SColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      '${risk.attendancePercent.toStringAsFixed(1)}% attendance',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: SColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      risk.reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SSize.sm),
              AttendanceRiskBadge(level: risk.riskLevel),
            ],
          ),
        ),
      ),
    );
  }
}
