import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceDateCard extends StatelessWidget {
  final String date;
  final String lecture;
  final int present;
  final int absent;
  final int total;
  final VoidCallback onTap;

  const AttendanceDateCard({
    super.key,
    required this.date,
    required this.lecture,
    required this.present,
    required this.absent,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final attendancePercentage = total > 0 ? (present / total) * 100 : 0;

    Color statusColor;
    if (attendancePercentage >= 80) {
      statusColor = SColors.success;
    } else if (attendancePercentage >= 60) {
      statusColor = Colors.orange;
    } else {
      statusColor = SColors.error;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SSize.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: statusColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Row
            Row(
              children: [
                Icon(
                  Iconsax.calendar,
                  color: SColors.primary,
                  size: SSize.iconSm,
                ),
                const SizedBox(width: SSize.xs),
                Text(
                  date,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Status Badge with Percentage
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.sm,
                    vertical: SSize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                    border: Border.all(
                      color: statusColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        '${attendancePercentage.toInt()}%',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: SSize.fontSizeSm,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SSize.sm),
                Icon(
                  Icons.arrow_forward_ios,
                  color: SColors.grey,
                  size: SSize.iconSm,
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),

            // Lecture
            Text(
              lecture,
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeMd,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: SSize.sm),

            // Stats Row
            Row(
              children: [
                // Present
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: SColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      '$present Present',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: SSize.md),

                // Absent
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: SColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SSize.xs),
                    Text(
                      '$absent Absent',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: SSize.md),

                // Total
                Text(
                  'Total: $total',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}