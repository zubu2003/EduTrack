import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherStatsRow extends StatelessWidget {
  const TeacherStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': "Today's Assess",
        'value': '08',
        'icon': Iconsax.clipboard,
        'color': const Color(0xFF4A6CF7), // Primary Blue
        'bgColor': const Color(0xFFE8EDFB), // Light Blue
      },
      {
        'label': 'Total Courses',
        'value': '12',
        'icon': Iconsax.book,
        'color': const Color(0xFF6C63FF), // Purple
        'bgColor': const Color(0xFFF0EEFF), // Light Purple
      },
      {
        'label': 'Total Students',
        'value': '280',
        'icon': Iconsax.people,
        'color': const Color(0xFF2D9CDB), // Sky Blue
        'bgColor': const Color(0xFFE8F4FD), // Light Sky Blue
      },
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: SSize.sm),
            padding: const EdgeInsets.all(SSize.md),
            decoration: BoxDecoration(
              color: stat['bgColor'] as Color,
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              boxShadow: [
                BoxShadow(
                  color: (stat['color'] as Color).withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon with background
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (stat['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                      ),
                      child: Icon(
                        stat['icon'] as IconData,
                        color: stat['color'] as Color,
                        size: SSize.iconSm,
                      ),
                    ),
                    // Value
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        color: stat['color'] as Color,
                        fontSize: SSize.fontSizeXxl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SSize.sm),
                Text(
                  stat['label'] as String,
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}