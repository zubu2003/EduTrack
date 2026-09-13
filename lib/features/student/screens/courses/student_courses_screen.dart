import 'package:edutrack/features/student/screens/courses/widgets/course_card.dart';
import 'package:edutrack/features/student/screens/courses/widgets/courses_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/features/student/controllers/courses/student_courses_controller.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class StudentCoursesScreen extends StatelessWidget {
  final bool showTodayOnly;

  const StudentCoursesScreen({
    super.key,
    this.showTodayOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentCoursesController());

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
              StudentCoursesHeader(
                title: showTodayOnly ? "Today's Classes" : 'My Courses',
                subtitle: showTodayOnly
                    ? 'Your classes scheduled for today.'
                    : 'Manage your current academic semester.',
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Expanded(
                child: controller.courses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: controller.refreshCourses,
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
                        child: StudentCourseCard(
                          course: course,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.studentCourseDetails,
                              arguments: {
                                'courseCode': course.courseCode,
                                'courseName': course.courseName,
                              },
                            );
                          },
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
      bottomNavigationBar: const StudentBottomNav(currentIndex: 1),
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
              'No Enrolled Courses',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              'Your teacher will assign you to courses',
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