import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class TeacherDashboardHeader extends StatelessWidget {
  const TeacherDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left: Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                'Dr. Smith',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: SColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Text(
                  'Here is your academic overview for today.',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right: Profile Avatar

      ],
    );
  }
}