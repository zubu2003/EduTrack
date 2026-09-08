import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class DashboardScheduleItem extends StatelessWidget {
  final String time;
  final String subject;
  final String timeRange;

  const DashboardScheduleItem({
    super.key,
    required this.time,
    required this.subject,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    final isNoClass = subject == 'No Class';

    return Row(
      children: [
        // Time Column (Left Side)
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: SSize.sm),
          decoration: BoxDecoration(
            color: isNoClass
                ? SColors.grey.withOpacity(0.1)
                : SColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
          ),
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isNoClass ? SColors.grey : SColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: SSize.fontSizeSm,
            ),
          ),
        ),

        const SizedBox(width: SSize.spaceBtwItems),

        // Class Name Card (Right Side)
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(SSize.sm),
            decoration: BoxDecoration(
              color: isNoClass
                  ? SColors.grey.withOpacity(0.05)
                  : SColors.white,
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              border: Border.all(
                color: isNoClass
                    ? SColors.grey.withOpacity(0.2)
                    : SColors.primary.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: isNoClass
                  ? null
                  : [
                BoxShadow(
                  color: SColors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Name
                Text(
                  subject,
                  style: TextStyle(
                    color: isNoClass ? SColors.grey : SColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),

                if (!isNoClass) ...[
                  const SizedBox(height: SSize.xs),

                  // Time Range with Icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: SColors.grey,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        timeRange,
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
        ),
      ],
    );
  }
}