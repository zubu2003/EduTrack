import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'dashboard_class_card.dart';

class DashboardTodaysClasses extends StatelessWidget {
  const DashboardTodaysClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with View All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Classes",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View All Classes'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  color: SColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Live Class Card
        const DashboardClassCard(
          courseName: 'CSE 356 Software Engineering',
          time: '10:00 AM - 11:30',
          room: 'Room 301',
          teacher: 'Dr. XYZ',
          isLive: true,
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Upcoming Class Card
        const DashboardClassCard(
          courseName: 'EEE 201 Electrical Circuits',
          time: 'Lab 02',
          room: '',
          teacher: 'Dr. ABC',
          isLive: false,
          isUpcoming: true,
          upcomingInfo: 'UPCOMING • STARTS IN 2 HOURS',
        ),
      ],
    );
  }
}