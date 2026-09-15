import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CtMarksListItem extends StatelessWidget {
  final String ctTitle;
  final double? mark;
  final double fullMarks;
  final bool isPublished;

  const CtMarksListItem({
    super.key,
    required this.ctTitle,
    required this.mark,
    required this.fullMarks,
    required this.isPublished,
  });

  @override
  Widget build(BuildContext context) {
    // Performance color
    Color statusColor;
    if (mark == null) {
      statusColor = SColors.grey;
    } else {
      final pct = (mark! / fullMarks) * 100;
      if (pct >= 80) {
        statusColor = SColors.success;
      } else if (pct >= 60) {
        statusColor = SColors.warning;
      } else {
        statusColor = SColors.error;
      }
    }

    return Container(
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
          color: statusColor.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Icon(
              Iconsax.document_text,
              color: SColors.primary,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctTitle,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Full Marks: ${fullMarks.toInt()}',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ],
            ),
          ),

          // Mark badge (solid colored background + white text)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.sm,
            ),
            decoration: BoxDecoration(
              color: mark != null ? statusColor : SColors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Text(
              mark != null
                  ? '${mark!.toStringAsFixed(0)}/${fullMarks.toInt()}'
                  : '--',
              style: TextStyle(
                color: mark != null ? SColors.white : SColors.grey,
                fontSize: SSize.fontSizeMd,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}