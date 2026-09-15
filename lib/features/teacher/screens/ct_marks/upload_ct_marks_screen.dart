import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_marks/teacher_ct_marks_controller.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/preview_ct_marks_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class UploadCtMarksScreen extends StatelessWidget {
  final CourseModel course;

  const UploadCtMarksScreen({
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.sm,
                  vertical: SSize.xs,
                ),
                decoration: BoxDecoration(
                  color: SColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                ),
                child: Text(
                  course.courseCode,
                  style: TextStyle(
                    color: SColors.primary,
                    fontSize: SSize.fontSizeMd,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: SSize.sm),

              Text(
                'Upload Marks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                course.courseName,
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwSections),

              // Upload Zone
              Obx(() {
                if (controller.parsedData.value != null) {
                  return _buildParsedFile(context, controller);
                }
                return _buildUploadZone(context, controller);
              }),

              const SizedBox(height: SSize.spaceBtwSections),

              // Format hint
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SSize.md),
                decoration: BoxDecoration(
                  color: SColors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(SSize.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: SColors.primary,
                          size: SSize.iconSm,
                        ),
                        const SizedBox(width: SSize.xs),
                        Text(
                          'Expected Format',
                          style: TextStyle(
                            color: SColors.textPrimary,
                            fontSize: SSize.fontSizeMd,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SSize.sm),
                    Text(
                      'Column A: Student ID\n'
                          'Column B: CT-1 marks\n'
                          'Column C: CT-2 marks\n'
                          '...\n'
                          'Last Column (optional): Total / Best 3',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadZone(
      BuildContext context,
      TeacherCtMarksController controller,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.lg),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        border: Border.all(
          color: SColors.primary.withOpacity(0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.document_upload,
            size: 64,
            color: SColors.primary,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          Text(
            'Upload Excel File (.xlsx)',
            style: TextStyle(
              color: SColors.textPrimary,
              fontSize: SSize.fontSizeLg,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SSize.xs),
          Text(
            'Select an .xlsx file with your marks',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          ElevatedButton.icon(
            onPressed: () async {
              await controller.pickAndParseExcel();
            },
            icon: const Icon(Iconsax.folder_open),
            label: const Text('Browse Files'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.lg,
                vertical: SSize.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
            ),
          ),

          const SizedBox(height: SSize.sm),

          // ✅ Hint about where to pick from
          Text(
            'Tip: Choose "Downloads" or "Internal Storage" in the picker',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeSm,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParsedFile(
      BuildContext context,
      TeacherCtMarksController controller,
      ) {
    final parsed = controller.parsedData.value!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(SSize.sm),
                decoration: BoxDecoration(
                  color: SColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
                child: Icon(
                  Iconsax.tick_circle,
                  color: SColors.success,
                  size: SSize.iconMd,
                ),
              ),
              const SizedBox(width: SSize.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Ready',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Detected: ${parsed.ctColumns.join(", ")}',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: SSize.md),

          // Stats
          Container(
            padding: const EdgeInsets.all(SSize.md),
            decoration: BoxDecoration(
              color: SColors.backgroundColor,
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('CTs', '${parsed.ctColumns.length}'),
                _statItem('Students', '${parsed.totalRows}'),
                if (parsed.totals.isNotEmpty) _statItem('Total', '✓'),
              ],
            ),
          ),

          if (parsed.hasErrors) ...[
            const SizedBox(height: SSize.md),
            Container(
              padding: const EdgeInsets.all(SSize.sm),
              decoration: BoxDecoration(
                color: SColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.warning_2,
                    color: SColors.warning,
                    size: SSize.iconSm,
                  ),
                  const SizedBox(width: SSize.xs),
                  Expanded(
                    child: Text(
                      '${parsed.errors.length} issues found',
                      style: TextStyle(
                        color: SColors.warning,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: SSize.md),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.clearUploadState,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: SColors.grey.withOpacity(0.3)),
                    padding: const EdgeInsets.symmetric(vertical: SSize.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: const Text('Change File'),
                ),
              ),
              const SizedBox(width: SSize.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.to(
                        () => PreviewCtMarksScreen(course: course),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: SSize.md),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: const Text(
                    'Preview Marks',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: SColors.primary,
            fontSize: SSize.fontSizeXl,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
          ),
        ),
      ],
    );
  }
}