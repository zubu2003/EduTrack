import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

import '../../../../../common/widget/logo/app_logo.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting with Name - Fixed alignment
        Row(
          children: [
            Text(
              'Good Morning, ',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
              ),
            ),
            Text(
              'Zubayer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
          ],
        ),

        const SizedBox(height: SSize.xs),

        // Subtitle
        Text(
          "Here's your academic overview for today.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textPrimary,
          ),
        ),
      ],
    );
  }
}