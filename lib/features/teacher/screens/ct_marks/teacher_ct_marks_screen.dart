import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_marks/teacher_ct_marks_controller.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/ct_details_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/upload_ct_marks_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/view_all_ct_marks_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/ct_marks_header.dart';
import 'widgets/ct_marks_list_item.dart';

class TeacherCtMarksScreen extends StatelessWidget {
  final CourseModel course;

  const TeacherCtMarksScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TeacherCtMarksController(course: course),
      tag: 'ct_${course.courseId}',
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
        final cts = ctData?.cts ?? {};

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

                // Action Buttons
                Row(
                  children: [
                    // Upload Excel
                    Expanded(
                      child: _buildActionButton(
                        icon: Iconsax.document_upload,
                        label: 'Upload Excel',
                        onTap: () => Get.to(
                              () => UploadCtMarksScreen(course: course),
                        ),
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(width: SSize.sm),

                    // View All
                    Expanded(
                      child: _buildActionButton(
                        icon: Iconsax.eye,
                        label: 'View All',
                        onTap: cts.isEmpty
                            ? null
                            : () => Get.to(
                              () => ViewAllCtMarksScreen(course: course),
                        ),
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SSize.spaceBtwSections),

                // CT List
                if (cts.isEmpty)
                  _buildEmptyState()
                else ...[
                  Text(
                    'Class Tests',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SSize.spaceBtwItems),

                  // Sorted CT list
                  ...ctData!.sortedCtKeys.map((ctTitle) {
                    final ct = cts[ctTitle]!;
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: SSize.spaceBtwItems,
                      ),
                      child: CtMarksListItem(
                        ct: ct,
                        fullMarks: ctData.fullMarks,
                        onTap: () => Get.to(
                              () => CtDetailsScreen(
                            course: course,
                            ctTitle: ctTitle,
                          ),
                        ),
                        onDelete: () => controller.deleteCt(ctTitle),
                      ),
                    );
                  }).toList(),
                ],

                const SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCtDialog(context, controller),
        backgroundColor: SColors.primary,
        child: const Icon(Iconsax.add, color: SColors.white, size: 28),
      ),
      bottomNavigationBar: const TeacherBottomNav(currentIndex: 1),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SSize.md,
          vertical: SSize.md,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? SColors.primary : SColors.white,
          borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
          border: isPrimary
              ? null
              : Border.all(
            color: SColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isPrimary ? SColors.white : SColors.primary,
              size: SSize.iconMd,
            ),
            const SizedBox(height: SSize.xs),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? SColors.white : SColors.primary,
                fontSize: SSize.fontSizeSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.lg),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.document_text,
            size: 64,
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
            'Upload an Excel file or add a CT manually',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCtDialog(
      BuildContext context,
      TeacherCtMarksController controller,
      ) {
    final ctTitleController = TextEditingController();
    final fullMarksController = TextEditingController(text: '20');

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SSize.cardRadius),
        ),
        title: const Text('Add New CT'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctTitleController,
              decoration: const InputDecoration(
                labelText: 'CT Title',
                hintText: 'e.g. CT-1',
              ),
            ),
            const SizedBox(height: SSize.md),
            TextField(
              controller: fullMarksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Full Marks',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = ctTitleController.text.trim();
              if (title.isEmpty) return;
              Get.back();
              controller.manualCtTitleController.text = title;
              controller.manualFullMarksController.text =
                  fullMarksController.text;
              controller.createManualCt();
            },
            style: ElevatedButton.styleFrom(backgroundColor: SColors.primary),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}