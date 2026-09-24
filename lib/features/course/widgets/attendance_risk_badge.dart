import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceRiskBadge extends StatelessWidget {
  final AttendanceRiskLevel level;

  const AttendanceRiskBadge({super.key, required this.level});

  Color get _color {
    switch (level) {
      case AttendanceRiskLevel.low:
        return SColors.success;
      case AttendanceRiskLevel.medium:
        return SColors.warning;
      case AttendanceRiskLevel.high:
        return SColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SSize.sm,
        vertical: SSize.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SSize.borderRadiusPill),
      ),
      child: Text(
        level.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
