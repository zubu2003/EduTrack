import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/teacher/controllers/courses/teacher_courses_controller.dart';
import 'package:edutrack/features/teacher/screens/courses/assign_students_screen.dart';
import 'package:edutrack/features/teacher/screens/courses/create_course_screen.dart';
import 'package:edutrack/features/teacher/screens/course_details/teacher_course_details_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/teacher_courses_header.dart';
import 'widgets/teacher_course_card.dart';

class TeacherCoursesScreen extends StatelessWidget {
  final bool showTodayOnly;

  const TeacherCoursesScreen({
    super.key,
    this.showTodayOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TeacherCoursesController(),
      tag: showTodayOnly ? 'teacher_courses_today' : 'teacher_courses_all',
    );

    // ✅ Set flag on the controller
    controller.showTodayOnly = showTodayOnly;

    // Trigger fetch after setting flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTeacherCourses();
    });

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: showTodayOnly,
        onBackPressed: showTodayOnly ? () => Get.back() : null,
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: SColors.primary),
            );
          }

          return Column(
            children: [
              TeacherCoursesHeader(
                title: showTodayOnly ? "Today's Classes" : 'My Courses',
                subtitle: showTodayOnly
                    ? 'Your classes scheduled for today.'
                    : 'Manage your teaching courses.',
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Expanded(
                child: controller.courses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: controller.fetchTeacherCourses,
                  color: SColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SSize.defaultSpace,
                      vertical: SSize.sm,
                    ),
                    itemCount: controller.courses.length,
                    itemBuilder: (context, index) {
                      final course = controller.courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: SSize.spaceBtwItems,
                        ),
                        child: TeacherCourseCard(
                          course: course,
                          onTap: () => Get.to(
                                () => TeacherCourseDetailsScreen(
                              course: course,
                            ),
                          ),
                          onAssign: () => Get.to(
                                () => AssignStudentsScreen(course: course),
                          ),
                          onEdit: () => Get.to(
                                () => CreateCourseScreen(course: course),
                          ),
                          onDelete: () =>
                              controller.deleteCourse(course),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: showTodayOnly
          ? null
          : FloatingActionButton(
        onPressed: () => Get.to(() => const CreateCourseScreen()),
        backgroundColor: SColors.primary,
        child: const Icon(Iconsax.add, color: SColors.white, size: 28),
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.book,
              size: 80,
              color: SColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'No Classes Today',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              'You have no classes scheduled for today.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SColors.textSecondary,
                fontSize: SSize.fontSizeMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}