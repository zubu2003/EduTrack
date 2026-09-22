import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/course_report_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class CourseReportController extends GetxController {
  final CourseModel course;

  CourseReportController({required this.course});

  final stats = Rxn<CourseReportStats>();
  final report = Rxn<CourseReportModel>();
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReport();
  }

  Future<void> loadReport() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      report.value = null;

      final calculated = await _calculateStats();
      stats.value = calculated;
      if (calculated.totalStudents == 0) return;

      await generateNarrative();
    } catch (e) {
      errorMessage.value = e.toString();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateNarrative() async {
    final currentStats = stats.value;
    if (currentStats == null) return;

    try {
      isGenerating.value = true;
      final prompt = SPromptTemplates.courseReport(
        courseName: course.courseName,
        courseCode: course.courseCode,
        totalStudents: currentStats.totalStudents,
        avgAttendance: currentStats.averageAttendance,
        avgCt: currentStats.averageCt,
        atRiskCount: currentStats.atRiskCount,
      );

      for (var attempt = 0; attempt < 2; attempt++) {
        try {
          final response = await AIService.instance.ask(prompt);
          report.value = CourseReportModel.fromAiResponse(
            _decodeResponse(response),
          );
          errorMessage.value = null;
          return;
        } catch (_) {
          if (attempt == 1) {
            report.value = _buildFactualNarrative(currentStats);
            errorMessage.value = null;
          }
        }
      }
    } catch (e) {
      report.value = _buildFactualNarrative(currentStats);
      errorMessage.value = null;
    } finally {
      isGenerating.value = false;
    }
  }

  CourseReportModel _buildFactualNarrative(CourseReportStats currentStats) {
    final attendance = currentStats.averageAttendance;
    final ctAverage = currentStats.averageCt;
    final riskRate = currentStats.totalStudents == 0
        ? 0.0
        : currentStats.atRiskCount / currentStats.totalStudents * 100;

    final attendanceInterpretation = attendance >= 75
        ? 'Attendance is above the 75% monitoring threshold.'
        : 'Attendance is below the 75% monitoring threshold and needs attention.';
    final ctInterpretation = ctAverage >= 10
        ? 'The normalized CT average is at least half of the 20-point scale.'
        : 'The normalized CT average is below half of the 20-point scale.';

    return CourseReportModel(
      overview:
          '${course.courseName} currently has ${currentStats.totalStudents} enrolled students and ${currentStats.totalSessions} recorded attendance sessions. The available attendance and CT data provides a factual snapshot for targeted follow-up.',
      attendanceSummary:
          'Average attendance is ${attendance.toStringAsFixed(1)}%. $attendanceInterpretation',
      ctSummary:
          'The average CT performance is ${ctAverage.toStringAsFixed(1)} out of 20. $ctInterpretation',
      risks: [
        '${currentStats.atRiskCount} students (${riskRate.toStringAsFixed(1)}%) are below the attendance monitoring threshold.',
        if (ctAverage < 10)
          'The course CT average indicates that academic support may be useful for students with recorded marks.',
      ],
      recommendations: [
        if (currentStats.atRiskCount > 0)
          'Review attendance records with at-risk students and agree on an improvement plan.',
        if (ctAverage < 10)
          'Use CT performance to identify topics that need review or additional practice.',
        'Continue recording attendance and CT marks so future reports reflect the latest course activity.',
      ],
    );
  }

  Future<CourseReportStats> _calculateStats() async {
    final enrollments = await AttendanceRepository.instance.getEnrolledStudents(
      course.courseId,
    );
    final sessions = await AttendanceRepository.instance.getSessions(
      course.courseId,
    );
    final ctData = await CtMarksRepository.instance.getCtData(course.courseId);

    var attendanceTotal = 0;
    var attendancePresent = 0;
    final attendanceByStudent = <String, List<String>>{};
    for (final session in sessions) {
      for (final record in session.records) {
        attendanceTotal++;
        if (_isPresent(record)) attendancePresent++;
        attendanceByStudent
            .putIfAbsent(record.studentId, () => [])
            .add(record.status);
      }
    }

    final normalizedMarks = <double>[];
    final marksByStudent = <String, List<double>>{};
    if (ctData != null) {
      for (final ct in ctData.cts.values) {
        for (final entry in ct.marks.entries) {
          if (CtMark.isAbsent(entry.value)) continue;
          final normalized = _normalizeMark(entry.value, ctData.fullMarks);
          normalizedMarks.add(normalized);
          marksByStudent.putIfAbsent(entry.key, () => []).add(normalized);
        }
      }
    }

    final atRiskCount = enrollments.where((student) {
      final records = attendanceByStudent[student.studentId] ?? [];
      if (records.isEmpty) return true;
      final attended = records.where(_isPresentStatus).length;
      return attended / records.length < 0.75;
    }).length;

    return CourseReportStats(
      totalStudents: enrollments.length,
      averageAttendance: attendanceTotal == 0
          ? 0
          : attendancePresent / attendanceTotal * 100,
      averageCt: normalizedMarks.isEmpty
          ? 0
          : normalizedMarks.reduce((a, b) => a + b) / normalizedMarks.length,
      atRiskCount: atRiskCount,
      totalSessions: sessions.length,
    );
  }

  bool _isPresent(AttendanceRecordModel record) =>
      _isPresentStatus(record.status);

  bool _isPresentStatus(String status) =>
      status == 'present' || status == 'late';

  double _normalizeMark(double mark, double fullMarks) {
    if (fullMarks <= 0) return 0;
    return mark / fullMarks * 20;
  }

  Map<String, dynamic> _decodeResponse(String response) {
    final clean = response.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'no response generated') {
      throw const FormatException('AI did not generate a course report');
    }
    final start = clean.indexOf('{');
    final end = clean.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FormatException('AI course report did not contain JSON');
    }
    final decoded = jsonDecode(clean.substring(start, end + 1));
    if (decoded is! Map) {
      throw const FormatException('AI course report was not an object');
    }
    return Map<String, dynamic>.from(decoded);
  }
}
