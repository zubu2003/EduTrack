import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CtMarksListItem extends StatelessWidget {
  final String title;
  final String marks;
  final String date;
  final IconData icon;

  const CtMarksListItem({
    super.key,
    required this.title,
    required this.marks,
    required this.date,
    this.icon = Iconsax.document_text,
  });

  @override
  Widget build(BuildContext context) {
    // Parse marks to determine color
    final marksParts = marks.split('/');
    final obtained = double.tryParse(marksParts[0]) ?? 0;
    final total = double.tryParse(marksParts[1]) ?? 20;
    final percentage = (obtained / total) * 100;

    Color statusColor;
    if (percentage >= 80) {
      statusColor = SColors.success;
    } else if (percentage >= 60) {
      statusColor = Colors.amber;
    } else {
      statusColor = SColors.error;
    }

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
        border: Border.all(
          color: statusColor.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon Container (Blue Theme)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Icon(
              icon,
              color: SColors.primary,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.w600,
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
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Marks with Status Color
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.sm,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              border: Border.all(
                color: statusColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              marks,
              style: TextStyle(
                color: statusColor,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}