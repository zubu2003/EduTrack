import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class RoutineCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String courseCode;
  final String courseName;
  final String room;
  final String teacher;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RoutineCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.teacher,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('$courseCode-$startTime'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        padding: const EdgeInsets.only(right: SSize.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        child: Container(
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
            border: Border.all(
              color: color.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Left Border Color Indicator
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
              ),
              const SizedBox(width: SSize.spaceBtwItems),

              // Time Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      startTime,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                    Text(
                      endTime,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SSize.spaceBtwItems),

              // Course Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseCode,
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      courseName,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
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
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                        const SizedBox(width: SSize.md),
                        Icon(
                          Icons.person_outline,
                          color: SColors.grey,
                          size: SSize.iconSm,
                        ),
                        const SizedBox(width: SSize.xs),
                        Text(
                          teacher,
                          style: TextStyle(
                            color: SColors.textSecondary,
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: SColors.grey,
                size: SSize.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}