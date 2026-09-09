import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherClassCard extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String room;
  final String status;
  final Color statusColor;
  final Color bgColor;
  final bool isOngoing;

  const TeacherClassCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.status,
    required this.statusColor,
    required this.bgColor,
    this.isOngoing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: isOngoing ? bgColor : SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        border: isOngoing
            ? Border.all(
          color: statusColor,
          width: 1.5,
        )
            : Border.all(
          color: SColors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: isOngoing
            ? [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: SColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Border with status indicator
          Container(
            width: 4,
            height: isOngoing ? 70 : 50,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Code with Ongoing Badge
                Row(
                  children: [
                    Text(
                      courseCode,
                      style: TextStyle(
                        color: isOngoing ? statusColor : SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOngoing) ...[
                      const SizedBox(width: SSize.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SSize.sm,
                          vertical: SSize.xs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: SColors.white,
                                fontSize: SSize.fontSizeSm,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  courseName,
                  style: TextStyle(
                    color: isOngoing ? SColors.textPrimary : SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: isOngoing ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: SSize.xs),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      color: isOngoing ? statusColor : SColors.grey,
                      size: SSize.iconSm,
                    ),
                    const SizedBox(width: SSize.xs),
                    Expanded(
                      child: Text(
                        room,
                        style: TextStyle(
                          color: isOngoing ? statusColor : SColors.textSecondary,
                          fontSize: SSize.fontSizeSm,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.sm,
            ),
            decoration: BoxDecoration(
              color: isOngoing
                  ? statusColor
                  : statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              border: isOngoing
                  ? null
                  : Border.all(
                color: statusColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isOngoing ? SColors.white : statusColor,
                fontWeight: FontWeight.w600,
                fontSize: SSize.fontSizeSm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}