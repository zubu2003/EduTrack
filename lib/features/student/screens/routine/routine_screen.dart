import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/student/controllers/routine/routine_controller.dart';
import 'package:edutrack/features/student/screens/routine/add_routine_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/routine_card.dart';
import 'widgets/routine_day_tabs.dart';
import 'widgets/routine_empty_state.dart';
import 'widgets/routine_fab.dart';
import 'widgets/routine_header.dart';

class RoutineScreen extends StatelessWidget {
  final String userRole;

  const RoutineScreen({
    super.key,
    this.userRole = 'student',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RoutineController(userRole: userRole),
      tag: 'routine_$userRole',
    );

    final bottomNav = userRole == 'teacher'
        ? const TeacherBottomNav(currentIndex: 2)
        : const StudentBottomNav(currentIndex: 2);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }

        final currentRoutines =
            controller.routineByDay[controller.selectedDay.value] ?? [];

        return Column(
          children: [
            // Header
            const RoutineHeader(),

            const SizedBox(height: SSize.spaceBtwItems),

            // Day Tabs
            RoutineDayTabs(
              days: RoutineController.days,
              selectedDay: controller.selectedDay.value,
              onDaySelected: controller.selectDay,
            ),

            const SizedBox(height: SSize.spaceBtwItems),

            // Routine List
            Expanded(
              child: currentRoutines.isEmpty
                  ? const RoutineEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.defaultSpace,
                ),
                itemCount: currentRoutines.length,
                itemBuilder: (context, index) {
                  final routine = currentRoutines[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: SSize.spaceBtwItems,
                    ),
                    child: RoutineCard(
                      startTime: routine.startTime,
                      endTime: routine.endTime,
                      courseCode: routine.courseCode,
                      courseName: routine.courseName,
                      room: routine.room,
                      color: SColors.primary,
                      onTap: () => Get.to(
                            () => AddRoutineScreen(
                          userRole: userRole,
                          routine: routine,
                        ),
                      ),
                      onDelete: () =>
                          controller.deleteRoutine(routine),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: RoutineFAB(
        onPressed: () => Get.to(
              () => AddRoutineScreen(userRole: userRole),
        ),
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}