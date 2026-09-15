import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../../common/widget/teacher/teacher_info.dart';

class DashboardClassCard extends StatelessWidget {
  final RoutineModel routine;
  final VoidCallback? onTap;

  const DashboardClassCard({
    super.key,
    required this.routine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOther = routine.courseCode == 'Others';
    final now = DateTime.now();
    final isLive = _isRunning(routine, now);

    return InkWell(
      onTap: isOther ? null : onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
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
            // Upcoming badge
            if (!isLive) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: SColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Text(
                  'UPCOMING',
                  style: TextStyle(
                    color: SColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ),
              const SizedBox(height: SSize.sm),
            ],

            // Course name + Live badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    routine.courseName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SSize.sm,
                      vertical: SSize.xs,
                    ),
                    decoration: BoxDecoration(
                      color: SColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: SColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: SColors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: SSize.sm),

            // Time
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  color: SColors.grey,
                  size: SSize.iconSm,
                ),
                const SizedBox(width: SSize.xs),
                Text(
                  '${routine.startTime} - ${routine.endTime}',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ],
            ),

            if (routine.room.isNotEmpty) ...[
              const SizedBox(height: SSize.xs),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: SColors.grey,
                    size: SSize.iconSm,
                  ),
                  const SizedBox(width: SSize.xs),
                  Text(
                    routine.room,
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ],

            if (!isOther && routine.courseCode.isNotEmpty) ...[
              const SizedBox(height: SSize.sm),
              STeacherInfoWidget(
                teacherName: routine.courseCode,
                avatarRadius: 14,
                fontSize: SSize.fontSizeMd,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isRunning(RoutineModel routine, DateTime now) {
    final nowMin = now.hour * 60 + now.minute;
    final start = _toMinutes(routine.startTime);
    final end = _toMinutes(routine.endTime);
    return nowMin >= start && nowMin <= end;
  }

  int _toMinutes(String time) {
    try {
      final parts = time.trim().split(' ');
      if (parts.length != 2) return 0;
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final min = int.parse(hm[1]);
      if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
      if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      return hour * 60 + min;
    } catch (_) {
      return 0;
    }
  }
}