import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../common/widget/appbar/common_appbar.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_todays_classes.dart';
import 'widgets/dashboard_class_schedule.dart';
import 'widgets/dashboard_upcoming_cts.dart';
import 'widgets/dashboard_bottom_nav.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SAppbar(

        showBackButton: false,
      ),
      backgroundColor: SColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // 1. Header
              DashboardHeader(),

              SizedBox(height: SSize.spaceBtwSections),

              // 2. Today's Classes
              DashboardTodaysClasses(),

              SizedBox(height: SSize.spaceBtwSections),

              // 3. Class Schedule
              DashboardClassSchedule(),

              SizedBox(height: SSize.spaceBtwSections),

              // 4. Upcoming CTs
              DashboardUpcomingCTs(),

              SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const DashboardBottomNav(),
    );
  }
}