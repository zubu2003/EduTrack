import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class RoutineEmptyState extends StatelessWidget {
  const RoutineEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(SSize.lg),
            decoration: BoxDecoration(
              color: SColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.calendar_1,
              size: 64,
              color: SColors.primary.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),
          Text(
            'No Classes Scheduled',
            style: TextStyle(
              color: SColors.textPrimary,
              fontSize: SSize.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SSize.xs),
          Text(
            'Tap the + button to add a new class',
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