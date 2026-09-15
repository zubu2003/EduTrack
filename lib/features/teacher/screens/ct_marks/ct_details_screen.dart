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

class CtDetailsScreen extends StatefulWidget {
  final CourseModel course;
  final String ctTitle;

  const CtDetailsScreen({
    super.key,
    required this.course,
    required this.ctTitle,
  });

  @override
  State<CtDetailsScreen> createState() => _CtDetailsScreenState();
}

class _CtDetailsScreenState extends State<CtDetailsScreen> {
  final Map<String, double> editableMarks = {};
  List<EnrollmentModel> students = [];
  bool isLoading = true;
  CtModel? ct;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final controller = Get.find<TeacherCtMarksController>(
        tag: 'ct_${widget.course.courseId}',
      );

      if (controller.ctData.value == null) {
        await controller.fetchCtData();
      }

      ct = controller.ctData.value?.cts[widget.ctTitle];
      if (ct != null) {
        editableMarks.addAll(ct!.marks);
      }

      final s = await AttendanceRepository.instance
          .getEnrolledStudents(widget.course.courseId);

      setState(() {
        students = s;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (ct == null) {
      return Scaffold(
        appBar: SAppbar(showBackButton: true, onBackPressed: () => Get.back()),
        body: const Center(child: Text('CT not found')),
      );
    }

    final controller = Get.find<TeacherCtMarksController>(
      tag: 'ct_${widget.course.courseId}',
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          // ─── Header ───
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SSize.md),
            color: SColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SSize.sm,
                        vertical: SSize.xs,
                      ),
                      decoration: BoxDecoration(
                        color: SColors.primary.withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(SSize.borderRadiusSm),
                      ),
                      child: Text(
                        widget.course.courseCode,
                        style: TextStyle(
                          color: SColors.primary,
                          fontSize: SSize.fontSizeSm,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: SSize.sm),
                    Text(
                      'Full Marks: ${controller.ctData.value?.fullMarks.toInt() ?? 20}',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _toggleStatus(controller),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SSize.md,
                          vertical: SSize.xs,
                        ),
                        decoration: BoxDecoration(
                          color: ct!.isPublished
                              ? SColors.success.withOpacity(0.1)
                              : SColors.warning.withOpacity(0.1),
                          borderRadius:
                          BorderRadius.circular(SSize.borderRadiusSm),
                        ),
                        child: Text(
                          ct!.isPublished ? '● Published' : '● Draft',
                          style: TextStyle(
                            color: ct!.isPublished
                                ? SColors.success
                                : SColors.warning,
                            fontSize: SSize.fontSizeSm,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SSize.sm),
                Text(
                  widget.ctTitle,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ─── Student List ───
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(SSize.defaultSpace),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final currentMark = editableMarks[student.studentId];

                return Container(
                  margin: const EdgeInsets.only(bottom: SSize.sm),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SSize.md,
                    vertical: SSize.md,
                  ),
                  decoration: BoxDecoration(
                    color: SColors.white,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: SColors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left: ID (bold) + Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              student.studentCode,
                              style: TextStyle(
                                color: SColors.textPrimary,
                                fontSize: SSize.fontSizeMd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              student.studentName,
                              style: TextStyle(
                                color: SColors.textSecondary,
                                fontSize: SSize.fontSizeSm,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Right: Mark input (smaller, vertically centered)
                      Container(
                        width: 55,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: SColors.backgroundColor,
                          borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                          border: Border.all(
                            color: SColors.primary.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          initialValue: currentMark != null
                              ? currentMark.toStringAsFixed(0)
                              : '',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: SSize.fontSizeLg,
                            fontWeight: FontWeight.bold,
                            color: SColors.primary,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: '--',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: SColors.grey,
                            ),
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (v) {
                            final mark = double.tryParse(v);
                            if (mark != null) {
                              editableMarks[student.studentId] = mark;
                            } else {
                              editableMarks.remove(student.studentId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ─── Save Button ───
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
                  onPressed: () => controller.saveCtMarks(
                    ctTitle: widget.ctTitle,
                    marks: editableMarks,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
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
      ),
    );
  }

  void _toggleStatus(TeacherCtMarksController controller) {
    final newStatus = ct!.isPublished ? 'draft' : 'published';
    controller.changeCtStatus(
      ctTitle: widget.ctTitle,
      status: newStatus,
    );
    setState(() {
      ct = ct!.copyWith(status: newStatus);
    });
  }
}