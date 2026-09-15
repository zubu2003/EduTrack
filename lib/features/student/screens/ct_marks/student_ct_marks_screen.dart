import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/student/controllers/ct_marks/student_ct_marks_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/ct_marks_summary.dart';
import 'widgets/ct_marks_list_item.dart';
import 'widgets/ct_marks_header.dart';

class StudentCtMarksScreen extends StatelessWidget {
  final CourseModel course;

  const StudentCtMarksScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      StudentCtMarksController(course: course),
      tag: 'student_ct_${course.courseId}',
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }

        final ctData = controller.ctData.value;

        if (ctData == null || ctData.cts.isEmpty) {
          return _buildEmptyState();
        }

        final ctKeys = ctData.sortedCtKeys;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: SSize.sm),

                // Header
                CtMarksHeader(
                  courseCode: course.courseCode,
                  courseName: course.courseName,
                ),

                const SizedBox(height: SSize.spaceBtwItems),

                // Summary (Best 3 + Average)
                CtMarksSummary(
                  best3Total: controller.getBest3Total(),
                  average: controller.getAverage(),
                  percentage: controller.getPercentage(),
                  bestOfCount: ctData.bestOfCount,
                  fullMarks: ctData.fullMarks,
                ),

                const SizedBox(height: SSize.spaceBtwSections),

                // CT List
                Text(
                  'All Class Tests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                ...ctKeys.map((ctTitle) {
                  final ct = ctData.cts[ctTitle]!;
                  final mark = controller.getMarkForCt(ctTitle);
                  final isPublished = ct.isPublished;

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: SSize.spaceBtwItems,
                    ),
                    child: CtMarksListItem(
                      ctTitle: ctTitle,
                      mark: mark,
                      fullMarks: ctData.fullMarks,
                      isPublished: isPublished,
                    ),
                  );
                }).toList(),

                const SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        );
      }),
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
              Iconsax.document_text,
              size: 80,
              color: SColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'No CT Marks Yet',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              'Your teacher hasn\'t uploaded any CT marks yet.',
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