import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'dashboard_ct_card.dart';

class DashboardUpcomingCTs extends StatelessWidget {
  const DashboardUpcomingCTs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Upcoming CTs',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // CT Card
        const DashboardCtCard(
          ctName: 'CT-2 (CSE 356)',
          date: '15 August 2026',
          daysLeft: '3 days left',
        ),
      ],
    );
  }
}