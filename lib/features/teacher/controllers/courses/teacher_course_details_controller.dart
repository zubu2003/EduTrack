import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';

class TeacherCourseDetailsController extends GetxController {
  final CourseModel course;

  TeacherCourseDetailsController({required this.course});

  RxBool isLoading = true.obs;
  RxInt totalClasses = 0.obs;
  RxDouble avgAttendance = 0.0.obs;
  RxDouble ctAverage = 0.0.obs;
  RxDouble ctFullMarks = 20.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;

      final sessions =
          await AttendanceRepository.instance.getSessions(course.courseId);
      totalClasses.value = sessions.length;

      if (sessions.isEmpty) {
        avgAttendance.value = 0;
      } else {
        double sum = 0;
        var counted = 0;
        for (final session in sessions) {
          if (session.totalStudents > 0) {
            sum += session.presentCount / session.totalStudents;
            counted++;
          }
        }
        avgAttendance.value = counted == 0 ? 0 : (sum / counted) * 100;
      }

      final ctData =
          await CtMarksRepository.instance.getCtData(course.courseId);
      if (ctData == null || ctData.cts.isEmpty) {
        ctAverage.value = 0;
        ctFullMarks.value = 20;
      } else {
        ctFullMarks.value = ctData.fullMarks;
        final marks = <double>[];
        for (final ct in ctData.cts.values) {
          for (final mark in ct.marks.values) {
            if (!CtMark.isAbsent(mark)) marks.add(mark);
          }
        }
        ctAverage.value = marks.isEmpty
            ? 0
            : marks.reduce((a, b) => a + b) / marks.length;
      }
    } catch (_) {
      totalClasses.value = 0;
      avgAttendance.value = 0;
      ctAverage.value = 0;
    } finally {
      isLoading.value = false;
    }
  }
}
