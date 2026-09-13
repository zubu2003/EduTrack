import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class TeacherAttendanceController extends GetxController {
  final CourseModel course;
  final AttendanceSessionModel? session;

  TeacherAttendanceController({
    required this.course,
    this.session,
  });

  final lectureController = TextEditingController();

  RxList<EnrollmentModel> enrolledStudents = <EnrollmentModel>[].obs;
  RxMap<String, String> attendanceMap = <String, String>{}.obs;
  Rxn<AttendanceSessionModel> currentSession = Rxn<AttendanceSessionModel>();

  RxBool isStudentsLoading = true.obs;
  RxBool isSaving = false.obs;

  RxList<AttendanceSessionModel> sessions = <AttendanceSessionModel>[].obs;

  bool get isEditing => currentSession.value != null;

  String get sessionDateIso =>
      currentSession.value?.date ?? session?.date ?? _todayISO();

  String get displayDate {
    final existing = currentSession.value ?? session;
    if (existing != null) return existing.formattedDate;
    return _todayFormatted();
  }

  @override
  void onInit() {
    super.onInit();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    await fetchEnrolledStudents();
    await _loadSessionForDay();
  }

  Future<void> _loadSessionForDay() async {
    try {
      final date = session?.date ?? _todayISO();
      final existing = session ??
          await AttendanceRepository.instance.getSessionByDate(
            courseId: course.courseId,
            date: date,
          );

      if (existing != null) {
        currentSession.value = existing;
        initMapFromSession(existing);
      }
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> fetchEnrolledStudents() async {
    try {
      isStudentsLoading.value = true;
      final students = await AttendanceRepository.instance
          .getEnrolledStudents(course.courseId);
      enrolledStudents.value = students;

      attendanceMap.clear();
      for (final s in students) {
        attendanceMap[s.studentId] = 'absent';
      }
      attendanceMap.refresh();
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isStudentsLoading.value = false;
    }
  }

  void initMapFromSession(AttendanceSessionModel session) {
    lectureController.text = session.lecture;

    for (final s in enrolledStudents) {
      attendanceMap[s.studentId] = 'absent';
    }

    for (final record in session.records) {
      attendanceMap[record.studentId] = record.status;
    }
    attendanceMap.refresh();
  }

  void toggleStudentStatus(String studentId) {
    final current = attendanceMap[studentId] ?? 'absent';
    attendanceMap[studentId] = current == 'present' ? 'absent' : 'present';
    attendanceMap.refresh();
  }

  void markStudent(String studentId, String status) {
    attendanceMap[studentId] = status;
    attendanceMap.refresh();
  }

  void toggleStudent(String studentId, bool isPresent) {
    attendanceMap[studentId] = isPresent ? 'present' : 'absent';
    attendanceMap.refresh();
  }

  void markAllPresent() {
    for (final s in enrolledStudents) {
      attendanceMap[s.studentId] = 'present';
    }
    attendanceMap.refresh();
    SSnackBarHelpers.successSnackBar(
      title: 'Marked',
      message: 'All students marked as present',
    );
  }

  void markAllAbsent() {
    for (final s in enrolledStudents) {
      attendanceMap[s.studentId] = 'absent';
    }
    attendanceMap.refresh();
  }

  int get presentCount =>
      attendanceMap.values.where((v) => v == 'present').length;

  int get absentCount =>
      attendanceMap.values.where((v) => v == 'absent').length;

  int get lateCount =>
      attendanceMap.values.where((v) => v == 'late').length;

  Future<void> saveSession({
    bool? isEditing,
    String? sessionId,
  }) async {
    try {
      final editing = isEditing ?? this.isEditing;
      final date = sessionDateIso;
      final lecture = 'Lecture on ${_todayFormatted()}';

      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog(
        editing ? 'Updating attendance...' : 'Saving attendance...',
      );

      final records = enrolledStudents.map((student) {
        return AttendanceRecordModel(
          studentId: student.studentId,
          studentName: student.studentName,
          studentCode: student.studentCode,
          status: attendanceMap[student.studentId] ?? 'absent',
        );
      }).toList();

      final savedId = await AttendanceRepository.instance.upsertSession(
        courseId: course.courseId,
        date: date,
        lecture: lecture,
        records: records,
      );

      currentSession.value = AttendanceSessionModel(
        sessionId: savedId,
        courseId: course.courseId,
        date: date,
        lecture: lecture,
        totalStudents: records.length,
        presentCount: presentCount,
        absentCount: absentCount,
        records: records,
        createdAt: currentSession.value?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      SFullScreenLoader.stopLoading();
      isSaving.value = false;

      Get.back();

      Future.delayed(const Duration(milliseconds: 250), () {
        SSnackBarHelpers.successSnackBar(
          title: 'Success',
          message: editing
              ? 'Attendance updated successfully'
              : 'Attendance saved successfully',
        );
      });
    } catch (e) {
      SFullScreenLoader.stopLoading();
      isSaving.value = false;
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> fetchSessions() async {
    try {
      final list =
      await AttendanceRepository.instance.getSessions(course.courseId);
      sessions.value = list;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await AttendanceRepository.instance.deleteSession(
        courseId: course.courseId,
        sessionId: sessionId,
      );
      SSnackBarHelpers.successSnackBar(
        title: 'Deleted',
        message: 'Session deleted successfully',
      );
      await fetchSessions();
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  String _todayISO() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _todayFormatted() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  void onClose() {
    lectureController.dispose();
    super.onClose();
  }
}