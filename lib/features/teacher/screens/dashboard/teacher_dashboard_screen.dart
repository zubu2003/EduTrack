import 'package:flutter/material.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import '../../../../common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'widgets/teacher_dashboard_header.dart';
import 'widgets/teacher_stats_row.dart';
import 'widgets/teacher_quick_actions.dart';
import 'widgets/teacher_todays_classes.dart';
import 'widgets/teacher_course_progress.dart';
import 'widgets/teacher_ai_insight.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: SSize.sm),

              // 1. Header
              const TeacherDashboardHeader(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 2. Stats Row
              const TeacherStatsRow(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 3. Quick Actions
              const TeacherTodaysClasses(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 4. Today's Classes
              const TeacherQuickActions(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 5. Course Progress
              const TeacherCourseProgress(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 6. AI Insight
              const TeacherAIInsight(),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(),
    );
  }
}