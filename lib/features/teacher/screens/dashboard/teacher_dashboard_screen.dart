import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/teacher/controllers/dashboard/teacher_dashboard_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'widgets/teacher_dashboard_header.dart';
import 'widgets/teacher_stats_row.dart';
import 'widgets/teacher_quick_actions.dart';
import 'widgets/teacher_todays_classes.dart';
import 'widgets/teacher_course_progress.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TeacherDashboardController());

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<TeacherDashboardController>().fetchDashboardData();
        },
        color: SColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
            child: Column(
              children: const [
                SizedBox(height: SSize.sm),
                TeacherDashboardHeader(),
                SizedBox(height: SSize.spaceBtwSections),
                TeacherStatsRow(),
                SizedBox(height: SSize.spaceBtwSections),
                TeacherTodaysClasses(),
                SizedBox(height: SSize.spaceBtwSections),
                TeacherQuickActions(),
                SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(),
    );
  }
}