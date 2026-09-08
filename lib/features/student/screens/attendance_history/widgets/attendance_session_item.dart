import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceSessionItem extends StatelessWidget {
  final String date;
  final String title;
  final String status;

  const AttendanceSessionItem({
    super.key,
    required this.date,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = status == 'Present';

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
          color: isPresent ? SColors.success.withOpacity(0.1) : SColors.error.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Date Column
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.sm,
              vertical: SSize.xs,
            ),
            decoration: BoxDecoration(
              color: SColors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
            ),
            child: Text(
              date,
              style: TextStyle(
                color: SColors.textSecondary,
                fontSize: SSize.fontSizeSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Title
          Expanded(
            child: Text(
              '   $title',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeMd,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.xs,
            ),
            decoration: BoxDecoration(
              color: isPresent ? SColors.success.withOpacity(0.1) : SColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: isPresent ? SColors.success : SColors.error,
                fontSize: SSize.fontSizeSm,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}