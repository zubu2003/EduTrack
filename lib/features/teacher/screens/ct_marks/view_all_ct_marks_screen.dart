import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_marks/teacher_ct_marks_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class ViewAllCtMarksScreen extends StatefulWidget {
  final CourseModel course;

  const ViewAllCtMarksScreen({super.key, required this.course});

  @override
  State<ViewAllCtMarksScreen> createState() => _ViewAllCtMarksScreenState();
}

class _ViewAllCtMarksScreenState extends State<ViewAllCtMarksScreen> {
  List<EnrollmentModel> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
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
    final controller = Get.find<TeacherCtMarksController>(
      tag: 'ct_${widget.course.courseId}',
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Obx(() {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final ctData = controller.ctData.value;
        if (ctData == null || ctData.cts.isEmpty) {
          return const Center(child: Text('No CT data'));
        }

        final ctKeys = ctData.sortedCtKeys;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(SSize.md),
              color: SColors.white,
              child: Row(
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
                        fontWeight: FontWeight.w600,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: SSize.sm),
                  Text(
                    'All CT Marks (Best ${ctData.bestOfCount})',
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 14,
                    headingRowColor: MaterialStateProperty.all(
                      SColors.primary.withOpacity(0.08),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Student',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SSize.fontSizeSm,
                          ),
                        ),
                      ),
                      ...ctKeys.map((ct) {
                        return DataColumn(
                          label: Text(
                            ct,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SSize.fontSizeSm,
                            ),
                          ),
                        );
                      }),
                      DataColumn(
                        label: Text(
                          'Best ${ctData.bestOfCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SSize.fontSizeSm,
                            color: SColors.success,
                          ),
                        ),
                      ),
                    ],
                    rows: students.map((student) {
                      return DataRow(cells: [
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                student.studentName,
                                style: TextStyle(
                                  fontSize: SSize.fontSizeSm,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Roll ${student.roll}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: SColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...ctKeys.map((ct) {
                          // ✅ Lookup by Firebase UID
                          final mark =
                          ctData.cts[ct]?.marks[student.studentId];
                          return DataCell(
                            Text(
                              mark != null ? mark.toStringAsFixed(0) : '--',
                              style: TextStyle(
                                fontSize: SSize.fontSizeSm,
                                fontWeight: mark != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: mark != null
                                    ? SColors.textPrimary
                                    : SColors.grey,
                              ),
                            ),
                          );
                        }),
                        DataCell(
                          Text(
                            // ✅ Compute by Firebase UID
                            ctData
                                .computeBestOf3(student.studentId)
                                .toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: SSize.fontSizeSm,
                              fontWeight: FontWeight.bold,
                              color: SColors.success,
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
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