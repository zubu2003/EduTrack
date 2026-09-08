import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'dashboard_calendar_row.dart';
import 'dashboard_schedule_item.dart';

class DashboardClassSchedule extends StatelessWidget {
  const DashboardClassSchedule({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with Month on Right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Class Schedule',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Jan 2026',
                style: TextStyle(
                  color: SColors.primary,
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Calendar Row
          const DashboardCalendarRow(),

          const SizedBox(height: SSize.spaceBtwItems),

          // Divider
          Divider(
            color: SColors.grey.withOpacity(0.2),
            height: 1,
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Schedule Items List
          Column(
            children: const [
              DashboardScheduleItem(
                time: '8:00 AM',
                subject: 'Writing',
                timeRange: '8:00 - 8:30',
              ),
              SizedBox(height: SSize.sm),
              DashboardScheduleItem(
                time: '10:00 AM',
                subject: 'Math',
                timeRange: '10:00 - 10:30',
              ),
              SizedBox(height: SSize.sm),
              DashboardScheduleItem(
                time: '12:00 PM',
                subject: 'No Class',
                timeRange: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}