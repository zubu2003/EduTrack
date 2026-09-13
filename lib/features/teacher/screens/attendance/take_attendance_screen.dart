import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/attendance/teacher_attendance_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/attendance_header.dart';
import 'widgets/attendance_student_item.dart';
import 'widgets/attendance_summary_footer.dart';

class TakeAttendanceScreen extends StatelessWidget {
  final CourseModel course;
  final AttendanceSessionModel? session;

  const TakeAttendanceScreen({
    super.key,
    required this.course,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    final tag = '${course.courseId}_${session?.date ?? 'today'}';

    if (Get.isRegistered<TeacherAttendanceController>(tag: tag)) {
      Get.delete<TeacherAttendanceController>(tag: tag);
    }

    final controller = Get.put(
      TeacherAttendanceController(course: course, session: session),
      tag: tag,
    );

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          Obx(() => AttendanceHeader(
                courseCode: course.courseCode,
                courseName: course.courseName,
                date: controller.displayDate,
                isEditing: controller.isEditing,
                onMarkAllPresent: controller.markAllPresent,
              )),
          const SizedBox(height: SSize.spaceBtwItems),
          Expanded(
            child: Obx(() {
              if (controller.isStudentsLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: SColors.primary),
                );
              }

              if (controller.enrolledStudents.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(SSize.defaultSpace),
                    child: Text(
                      'No students enrolled in this course.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ),
                );
              }

              // Must be read here (not in itemBuilder) so Obx tracks the map
              final attendance =
                  Map<String, String>.from(controller.attendanceMap);
              final students = controller.enrolledStudents.toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.defaultSpace,
                ),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final status = attendance[student.studentId] ?? 'absent';

                  return Padding(
                    key: ValueKey('${student.studentId}_$status'),
                    padding: const EdgeInsets.only(bottom: SSize.sm),
                    child: AttendanceStudentItem(
                      name: student.studentName,
                      id: student.studentCode,
                      isPresent: status == 'present',
                      onTap: () => controller.toggleStudentStatus(
                        student.studentId,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            final _ = controller.attendanceMap.length;
            return AttendanceSummaryFooter(
              presentCount: controller.presentCount,
              absentCount: controller.absentCount,
              isEditing: controller.isEditing,
              onSubmit: () => controller.saveSession(
                isEditing: controller.isEditing,
                sessionId: controller.currentSession.value?.sessionId,
              ),
            );
          }),
          const SizedBox(height: SSize.sm),
        ],
      ),
    );
  }
}
