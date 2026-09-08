import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class RoutineHeader extends StatelessWidget {
  const RoutineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Routine',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SColors.textPrimary,
            ),
          ),
          const SizedBox(height: SSize.xs),
          Text(
            'Today is a busy day, stay focused.',
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
        ],
      ),
    );
  }
}