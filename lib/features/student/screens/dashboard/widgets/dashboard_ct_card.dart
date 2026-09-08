import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class DashboardCtCard extends StatelessWidget {
  final String ctName;
  final String date;
  final String daysLeft;

  const DashboardCtCard({
    super.key,
    required this.ctName,
    required this.date,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - CT Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ctName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: SColors.grey,
                    size: SSize.iconSm,
                  ),
                  const SizedBox(width: SSize.xs),
                  Text(
                    date,
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side - Days Left Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.sm,
            ),
            decoration: BoxDecoration(
              color: SColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              border: Border.all(
                color: SColors.warning.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  daysLeft,
                  style: TextStyle(
                    color: SColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}