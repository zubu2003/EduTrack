import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_marks/teacher_ct_marks_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ViewAllCtMarksScreen extends StatefulWidget {
  final CourseModel course;

  const ViewAllCtMarksScreen({super.key, required this.course});

  @override
  State<ViewAllCtMarksScreen> createState() => _ViewAllCtMarksScreenState();
}

class _ViewAllCtMarksScreenState extends State<ViewAllCtMarksScreen> {
  List<EnrollmentModel> students = [];
  bool studentsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final s = await AttendanceRepository.instance
          .getEnrolledStudents(widget.course.courseId);
      if (!mounted) return;
      setState(() {
        students = s;
        studentsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => studentsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherCtMarksController>(
      tag: 'ct_${widget.course.courseId}',
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: studentsLoading
          ? const Center(
              child: CircularProgressIndicator(color: SColors.primary),
            )
          : Obx(() {
              final _ = controller.isLoading.value;
              final ctData = controller.ctData.value;

              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: SColors.primary),
                );
              }

              if (ctData == null || ctData.cts.isEmpty) {
                return _emptyState(
                  title: 'No CT data',
                  subtitle: 'Upload or create a class test first.',
                );
              }

              if (students.isEmpty) {
                return _emptyState(
                  title: 'No students',
                  subtitle: 'No students are enrolled in this course.',
                );
              }

              final ctKeys = ctData.sortedCtKeys;
              final credit = widget.course.credit > 0 ? widget.course.credit : 3;
              final expectedCts = credit + 1;

              return Column(
                children: [
                  _header(
                    ctCount: ctKeys.length,
                    credit: credit,
                    expectedCts: expectedCts,
                    fullMarks: ctData.fullMarks,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        SSize.defaultSpace,
                        SSize.sm,
                        SSize.defaultSpace,
                        SSize.spaceBtwSections,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: SColors.white,
                          borderRadius:
                              BorderRadius.circular(SSize.cardRadius),
                          boxShadow: [
                            BoxShadow(
                              color: SColors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowHeight: 48,
                            dataRowMinHeight: 56,
                            dataRowMaxHeight: 64,
                            headingRowColor: WidgetStateProperty.all(
                              SColors.primary.withOpacity(0.06),
                            ),
                            columns: [
                              const DataColumn(
                                label: Text(
                                  'Student',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: SColors.textPrimary,
                                  ),
                                ),
                              ),
                              ...ctKeys.map(
                                (ct) => DataColumn(
                                  label: Text(
                                    ct,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total (Best $credit)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: SColors.primary,
                                  ),
                                ),
                              ),
                            ],
                            rows: students.map((student) {
                              final uid = student.studentId;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 170,
                                      child: _studentCell(student),
                                    ),
                                  ),
                                  ...ctKeys.map((ct) {
                                    final mark =
                                        ctData.cts[ct]?.marks[uid];
                                    final isAbs = CtMark.isAbsent(mark);
                                    return DataCell(
                                      Text(
                                        CtMark.display(mark),
                                        style: TextStyle(
                                          fontWeight: isAbs || mark != null
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isAbs
                                              ? SColors.error
                                              : mark != null
                                                  ? SColors.textPrimary
                                                  : SColors.grey,
                                        ),
                                      ),
                                    );
                                  }),
                                  DataCell(
                                    Text(
                                      ctData
                                          .computeCourseTotal(uid, credit)
                                          .toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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

  Widget _header({
    required int ctCount,
    required int credit,
    required int expectedCts,
    required double fullMarks,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        SSize.defaultSpace,
        SSize.sm,
        SSize.defaultSpace,
        0,
      ),
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF2D2D44)],
        ),
        borderRadius: BorderRadius.circular(SSize.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.course.courseCode,
            style: TextStyle(
              color: SColors.white.withOpacity(0.7),
              fontSize: SSize.fontSizeSm,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All CT Marks',
            style: TextStyle(
              color: SColors.white,
              fontSize: SSize.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.course.courseName,
            style: TextStyle(
              color: SColors.white.withOpacity(0.7),
              fontSize: SSize.fontSizeMd,
            ),
          ),
          const SizedBox(height: SSize.sm),
          Wrap(
            spacing: SSize.sm,
            runSpacing: SSize.xs,
            children: [
              _chip('$ctCount / $expectedCts CTs'),
              _chip('$credit Credit'),
              _chip('Full ${fullMarks.toInt()}'),
              _chip('Total = best $credit', highlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SSize.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.amber.withOpacity(0.2)
            : SColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlight ? Colors.amber : SColors.white,
          fontSize: SSize.fontSizeSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _studentCell(EnrollmentModel student) {
    final initial =
        student.studentName.isNotEmpty ? student.studentName[0] : '?';
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: SColors.primary.withOpacity(0.1),
          child: Text(
            initial.toUpperCase(),
            style: const TextStyle(
              color: SColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: SSize.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              student.studentName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: SColors.textPrimary,
              ),
            ),
            Text(
              'Roll ${student.roll}',
              style: const TextStyle(
                fontSize: 11,
                color: SColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emptyState({required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document_text,
              size: 72,
              color: SColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              title,
              style: const TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.xs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
