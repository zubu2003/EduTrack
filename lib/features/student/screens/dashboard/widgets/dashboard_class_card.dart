import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

import '../../../../../common/widget/teacher/teacher_info.dart';

class DashboardClassCard extends StatelessWidget {
  final String courseName;
  final String time;
  final String room;
  final String teacher;
  final bool isLive;
  final bool isUpcoming;
  final String? upcomingInfo;

  const DashboardClassCard({
    super.key,
    required this.courseName,
    required this.time,
    required this.room,
    required this.teacher,
    this.isLive = false,
    this.isUpcoming = false,
    this.upcomingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigate to Course Details'),
            duration: Duration(seconds: 2),
          ),
        );
        // TODO: Navigate to Course Details Screen
      },
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
            // Upcoming Badge (Top - Only for Upcoming)
            if (isUpcoming && upcomingInfo != null) ...[
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
                  upcomingInfo!,
                  style: TextStyle(
                    color: SColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ),
              const SizedBox(height: SSize.sm),
            ],

            // Course Name and Live Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    courseName,
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
                  time,
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ],
            ),

            if (room.isNotEmpty) ...[
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
                    room,
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: SSize.sm),

            // Teacher Info (Using Common Widget)
            if (teacher.isNotEmpty)
              STeacherInfoWidget(
                teacherName: teacher,
                avatarRadius: 14,
                fontSize: SSize.fontSizeMd,
              ),
          ],
        ),
      ),
    );
  }
}