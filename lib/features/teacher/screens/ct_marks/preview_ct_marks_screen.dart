import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_marks/teacher_ct_marks_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class PreviewCtMarksScreen extends StatelessWidget {
  final CourseModel course;

  const PreviewCtMarksScreen({super.key, required this.course});

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
        final parsed = controller.parsedData.value;
        if (parsed == null) {
          return const Center(child: Text('No data'));
        }

        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(SSize.md),
              color: SColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview Marks',
                          style: TextStyle(
                            color: SColors.textPrimary,
                            fontSize: SSize.fontSizeLg,
                            fontWeight: FontWeight.bold,
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
                  // Full Marks editable
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(
                      horizontal: SSize.sm,
                      vertical: SSize.xs,
                    ),
                    decoration: BoxDecoration(
                      color: SColors.backgroundColor,
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusSm),
                    ),
                    child: TextFormField(
                      initialValue: controller.editableFullMarks.value
                          .toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: SColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) {
                        final val = double.tryParse(v);
                        if (val != null) {
                          controller.editableFullMarks.value = val;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SSize.sm),

            // Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor: MaterialStateProperty.all(
                      SColors.primary.withOpacity(0.08),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Student ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                      ),
                      ...parsed.ctColumns.map((ct) {
                        final existing = controller.ctData.value?.cts
                            .containsKey(ct) ??
                            false;
                        return DataColumn(
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ct,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SSize.fontSizeSm,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: existing
                                      ? SColors.warning.withOpacity(0.15)
                                      : SColors.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  existing ? 'Update' : 'New',
                                  style: TextStyle(
                                    color: existing
                                        ? SColors.warning
                                        : SColors.success,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (parsed.totals.isNotEmpty)
                        DataColumn(
                          label: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SSize.fontSizeSm,
                            ),
                          ),
                        ),
                    ],
                    rows: parsed.marksByCt.values.first.keys.map((studentId) {
                      return DataRow(cells: [
                        // Student ID
                        DataCell(
                          Text(
                            studentId,
                            style: TextStyle(
                              color: SColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: SSize.fontSizeSm,
                            ),
                          ),
                        ),
                        // CT columns
                        ...parsed.ctColumns.map((ct) {
                          final val =
                          controller.editableMarks[ct]?[studentId];
                          return DataCell(
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                initialValue:
                                val != null ? val.toStringAsFixed(0) : '',
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SSize.fontSizeSm,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  final mark = double.tryParse(v);
                                  if (mark != null) {
                                    controller.updateEditableMark(
                                      ct,
                                      studentId,
                                      mark,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                        // Total
                        if (parsed.totals.isNotEmpty)
                          DataCell(
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                initialValue: controller
                                    .editableTotals[studentId] !=
                                    null
                                    ? controller.editableTotals[studentId]!
                                    .toStringAsFixed(0)
                                    : '',
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SSize.fontSizeSm,
                                  fontWeight: FontWeight.bold,
                                  color: SColors.success,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  final total = double.tryParse(v);
                                  if (total != null) {
                                    controller.updateEditableTotal(
                                      studentId,
                                      total,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Submit button
            Container(
              padding: const EdgeInsets.all(SSize.defaultSpace),
              decoration: BoxDecoration(
                color: SColors.white,
                boxShadow: [
                  BoxShadow(
                    color: SColors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: SSize.buttonHeight,
                  child: ElevatedButton(
                    onPressed: controller.submitParsedData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(SSize.borderRadiusMd),
                      ),
                    ),
                    child: const Text(
                      'Submit to Firestore',
                      style: TextStyle(
                        color: SColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}