import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final double percentage;
  final int presentCount;
  final int absentCount;
  final int totalCount;

  const AttendanceSummaryCard({
    super.key,
    required this.percentage,
    required this.presentCount,
    required this.absentCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final percentText = percentage.toStringAsFixed(0);
    final progress = (percentage / 100).clamp(0.0, 1.0);

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentText%',
                style: TextStyle(
                  color: SColors.textPrimary,
                  fontSize: SSize.fontSizeXxl * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: SSize.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'ATTENDANCE',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SSize.sm),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: SColors.grey.withOpacity(0.15),
                    color: SColors.primary,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: SSize.sm),
              Text(
                'Required: 80%',
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeSm,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: SSize.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$presentCount',
                    style: TextStyle(
                      color: SColors.success,
                      fontSize: SSize.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Text(
                    'Present',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeSm,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$absentCount',
                    style: TextStyle(
                      color: SColors.error,
                      fontSize: SSize.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Text(
                    'Absent',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeSm,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$totalCount',
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeLg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Text(
                    'Total',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeSm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
