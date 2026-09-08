import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class RoutineDayTabs extends StatelessWidget {
  final List<String> days;
  final String selectedDay;
  final Function(String) onDaySelected;

  const RoutineDayTabs({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: days.map((day) {
            final isSelected = day == selectedDay;
            return Padding(
              padding: const EdgeInsets.only(right: SSize.sm),
              child: GestureDetector(
                onTap: () => onDaySelected(day),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.md,
                    vertical: SSize.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? SColors.primary : SColors.white,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: SColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: SColors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? SColors.white : SColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}