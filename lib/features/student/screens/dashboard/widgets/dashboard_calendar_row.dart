import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class DashboardCalendarRow extends StatelessWidget {
  const DashboardCalendarRow({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI'];
    final dates = ['17', '18', '19', '20', '21', '22'];
    final today = '20'; // Today's date

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        final isToday = dates[index] == today;
        return Column(
          children: [
            Text(
              days[index],
              style: TextStyle(
                color: isToday ? SColors.primary : SColors.textSecondary,
                fontSize: SSize.fontSizeSm,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isToday ? SColors.primary : SColors.transparent,
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              ),
              child: Center(
                child: Text(
                  dates[index],
                  style: TextStyle(
                    color: isToday ? SColors.white : SColors.textPrimary,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}