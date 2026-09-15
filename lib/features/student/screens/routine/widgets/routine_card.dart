import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class RoutineCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String courseCode;
  final String courseName;
  final String room;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RoutineCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.color,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            // Color indicator
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              ),
            ),
            const SizedBox(width: SSize.spaceBtwItems),

            // Time badge
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

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseName,
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (courseCode.isNotEmpty && courseCode != 'Others') ...[
                    const SizedBox(height: SSize.xs),
                    Text(
                      courseCode,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
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
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Delete button
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: SColors.error,
                  size: SSize.iconMd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}