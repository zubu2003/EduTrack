import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseDetailsStats extends StatelessWidget {
  const CourseDetailsStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': 'TOTAL CLASSES',
        'value': '28',
        'icon': Icons.menu_book_rounded,
      },
      {
        'label': 'AVG ATTENDANCE',
        'value': '82%',
        'icon': Icons.people_alt_rounded,
      },
      {
        'label': 'CT AVERAGE',
        'value': '16.4/20',
        'icon': Icons.assignment_rounded,
      },
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stats.length, (index) {
        final stat = stats[index];

        return Expanded(
          child: Container(
            height: 125,
            margin: EdgeInsets.only(
              right: index == stats.length - 1 ? 0 : SSize.sm,
            ),
            padding: const EdgeInsets.all(SSize.sm),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF3F7FF),
                  Color(0xFFE4EEFF),
                ],
              ),
              borderRadius: BorderRadius.circular(SSize.cardRadius),
              border: Border.all(
                color: SColors.primary.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: SColors.primary.withOpacity(0.10),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: SColors.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: SColors.primary,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  stat['value'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SColors.primary,
                    fontSize: SSize.fontSizeXl,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                // Label - allows wrapping to a second line
                Text(
                  stat['label'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
