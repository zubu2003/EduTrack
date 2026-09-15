import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/student/controllers/dashboard/student_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'dashboard_calendar_row.dart';
import 'dashboard_schedule_item.dart';

class DashboardClassSchedule extends StatelessWidget {
  const DashboardClassSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentDashboardController>();

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
          // Title row (not interactive)
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
                _monthYear(),
                style: TextStyle(
                  color: SColors.primary,
                  fontSize: SSize.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Calendar Row (interactive — day selector)
          Obx(() => DashboardCalendarRow(
            selectedDay: controller.selectedScheduleDay.value,
            onDaySelected: controller.selectScheduleDay,
          )),

          const SizedBox(height: SSize.spaceBtwItems),

          Divider(
            color: SColors.grey.withOpacity(0.2),
            height: 1,
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Schedule items for selected day
          Obx(() {
            final routines = controller.getRoutineForDay(
              controller.selectedScheduleDay.value,
            );

            if (routines.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: SSize.md),
                child: Center(
                  child: Text(
                    'No schedule',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: routines.map((routine) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: SSize.sm),
                  child: DashboardScheduleItem(
                    time: routine.startTime,
                    subject: routine.courseName,
                    timeRange:
                    '${routine.startTime} - ${routine.endTime}',
                    onTap: () => controller.openRoutine(
                      day: controller.selectedScheduleDay.value,
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  String _monthYear() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[now.month - 1]} ${now.year}';
  }
}