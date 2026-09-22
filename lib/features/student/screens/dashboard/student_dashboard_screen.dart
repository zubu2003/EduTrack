import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/student/controllers/dashboard/student_dashboard_controller.dart';
import 'package:edutrack/features/student/controllers/ct_alert_controller.dart';
import 'package:edutrack/features/course/controllers/academic_performance_insight_controller.dart';
import 'package:edutrack/features/search/screens/search_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../common/widget/appbar/common_appbar.dart';
import '../../../../common/widget/bottom_nav/student_bottom_nav.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_todays_classes.dart';
import 'widgets/dashboard_class_schedule.dart';
import 'widgets/dashboard_upcoming_cts.dart';
import 'widgets/student_ai_insight.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentDashboardController());
    Get.put(StudentCtAlertController());
    Get.put(
      AcademicPerformanceInsightController(teacherMode: false),
      tag: 'student_academic_insight',
    );

    return Scaffold(
      appBar: SAppbar(
        showBackButton: false,
        onSearchPressed: () =>
            Get.to(() => const SearchScreen(role: 'student')),
      ),
      backgroundColor: SColors.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<StudentDashboardController>().fetchDashboardData();
          await Get.find<StudentCtAlertController>().loadAlerts();
          await Get.find<AcademicPerformanceInsightController>(
            tag: 'student_academic_insight',
          ).loadInsight();
        },
        color: SColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

                StudentAIInsight(),

                SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const StudentBottomNav(currentIndex: 0),
    );
  }
}
