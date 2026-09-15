import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class DashboardCalendarRow extends StatelessWidget {
  final String selectedDay;
  final Function(String) onDaySelected;

  const DashboardCalendarRow({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  // Fixed order matching routine days
  static const List<String> dayNames = ['SUN', 'MON', 'TUE', 'WED', 'THU'];
  static const List<String> dayKeys = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  @override
  Widget build(BuildContext context) {
    // Compute the current week's Sun → Thu dates
    final now = DateTime.now();
    // Sunday of current week
    final sunday = now.subtract(Duration(days: now.weekday % 7));

    final dates = List.generate(
      5,
          (i) => sunday.add(Duration(days: i)).day.toString(),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final key = dayKeys[index];
        final isSelected = key == selectedDay;

        return GestureDetector(
          onTap: () => onDaySelected(key),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Text(
                dayNames[index],
                style: TextStyle(
                  color: isSelected ? SColors.primary : SColors.textSecondary,
                  fontSize: SSize.fontSizeSm,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? SColors.primary : SColors.transparent,
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Center(
                  child: Text(
                    dates[index],
                    style: TextStyle(
                      color: isSelected ? SColors.white : SColors.textPrimary,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}