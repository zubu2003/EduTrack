import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class TeacherProgressItem extends StatelessWidget {
  final String courseName;
  final String progress;
  final double value;

  const TeacherProgressItem({
    super.key,
    required this.courseName,
    required this.progress,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
      ),
      child: Row(
        children: [
          // Course Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: SColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Icon(
              Icons.book_outlined,
              color: SColors.primary,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: SColors.grey.withOpacity(0.15),
                          color: SColors.primary,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: SSize.sm),
                    Text(
                      progress,
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
        ],
      ),
    );
  }
}