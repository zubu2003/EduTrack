import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/academic_performance_insight_model.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class AcademicPerformanceInsightController extends GetxController {
  final bool teacherMode;

  AcademicPerformanceInsightController({required this.teacherMode});

  final insight = Rxn<AcademicPerformanceInsightModel>();
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadInsight();
  }

  Future<void> loadInsight() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      insight.value = null;

      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        insight.value = null;
        return;
      }

      final courses = teacherMode
          ? await CourseRepository.instance.getTeacherCourses(user.uid)
          : await CourseRepository.instance.getStudentCourses(user.uid);
      final metrics = await _collectMetrics(user, courses);

      if (!metrics.hasData) {
        insight.value = null;
        return;
      }

      final prompt = SPromptTemplates.performanceInsight(
        studentName: teacherMode ? 'Course cohort' : user.name,
        courseName: teacherMode ? 'Your courses' : 'Your enrolled courses',
        ctAverage: metrics.studentCtAverage,
        courseMean: metrics.courseMean,
        attendancePercent: metrics.attendancePercent,
      );

      Map<String, dynamic>? responseJson;
      for (var attempt = 0; attempt < 2 && responseJson == null; attempt++) {
        try {
          responseJson = _decodeResponse(await AIService.instance.ask(prompt));
        } catch (_) {
          if (attempt == 1) {
            errorMessage.value =
                'AI insight is temporarily unavailable. Please retry.';
            return;
          }
        }
      }

      if (responseJson == null) {
        errorMessage.value =
            'AI insight is temporarily unavailable. Please retry.';
        return;
      }

      try {
        insight.value = AcademicPerformanceInsightModel.fromAiResponse(
          responseJson,
        );
      } on FormatException {
        errorMessage.value = 'AI returned an incomplete insight. Please retry.';
      }
    } catch (e) {
      insight.value = null;
      errorMessage.value = e.toString();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<_InsightMetrics> _collectMetrics(
    UserModel user,
    List<CourseModel> courses,
  ) async {
    final studentMarks = <double>[];
    final courseMarks = <double>[];
    var attendedSessions = 0;
    var countedSessions = 0;

    for (final course in courses) {
      final ctData = await CtMarksRepository.instance.getCtData(
        course.courseId,
      );
      if (ctData != null) {
        _addCourseMarks(ctData, courseMarks);
        if (!teacherMode) {
          _addStudentMarks(ctData, user, studentMarks);
        }
      }

      final sessions = await AttendanceRepository.instance.getSessions(
        course.courseId,
      );
      for (final session in sessions) {
        if (teacherMode) {
          attendedSessions += session.records.where(_isPresent).length;
          countedSessions += session.records.length;
        } else {
          final record = _studentRecord(session, user);
          if (record == null) continue;
          countedSessions++;
          if (_isPresent(record)) attendedSessions++;
        }
      }
    }

    if (teacherMode) {
      studentMarks
        ..clear()
        ..addAll(courseMarks);
    }

    return _InsightMetrics(
      studentCtAverage: _average(studentMarks),
      courseMean: _average(courseMarks),
      attendancePercent: countedSessions == 0
          ? 0
          : attendedSessions / countedSessions * 100,
      hasData:
          courses.isNotEmpty && (courseMarks.isNotEmpty || countedSessions > 0),
    );
  }

  void _addCourseMarks(CtDataModel data, List<double> destination) {
    for (final ct in data.cts.values) {
      for (final mark in ct.marks.values) {
        if (!CtMark.isAbsent(mark)) {
          destination.add(_normalizeMark(mark, data.fullMarks));
        }
      }
    }
  }

  void _addStudentMarks(
    CtDataModel data,
    UserModel user,
    List<double> destination,
  ) {
    for (final ct in data.cts.values) {
      final mark = ct.marks[user.uid];
      if (mark != null && !CtMark.isAbsent(mark)) {
        destination.add(_normalizeMark(mark, data.fullMarks));
      }
    }
  }

  double _normalizeMark(double mark, double fullMarks) {
    if (fullMarks <= 0) return 0;
    return mark / fullMarks * 20;
  }

  AttendanceRecordModel? _studentRecord(
    AttendanceSessionModel session,
    UserModel user,
  ) {
    for (final record in session.records) {
      if (record.studentId == user.uid) return record;
      if (user.studentId.isNotEmpty && record.studentCode == user.studentId) {
        return record;
      }
    }
    return null;
  }

  bool _isPresent(AttendanceRecordModel record) {
    return record.status == 'present' || record.status == 'late';
  }

  double _average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((total, value) => total + value) / values.length;
  }

  Map<String, dynamic> _decodeResponse(String response) {
    var clean = response.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'no response generated') {
      throw const FormatException('AI did not generate an insight response');
    }

    if (clean.startsWith('```')) {
      clean = clean.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      clean = clean.replaceFirst(RegExp(r'\s*```$'), '');
    }

    final objectStart = clean.indexOf('{');
    final objectEnd = clean.lastIndexOf('}');
    if (objectStart < 0 || objectEnd <= objectStart) {
      throw const FormatException('AI insight response did not contain JSON');
    }

    final decoded = jsonDecode(clean.substring(objectStart, objectEnd + 1));
    if (decoded is! Map) {
      throw const FormatException('AI response was not a JSON object');
    }
    return Map<String, dynamic>.from(decoded);
  }
}

class _InsightMetrics {
  final double studentCtAverage;
  final double courseMean;
  final double attendancePercent;
  final bool hasData;

  const _InsightMetrics({
    required this.studentCtAverage,
    required this.courseMean,
    required this.attendancePercent,
    required this.hasData,
  });
}
