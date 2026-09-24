import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class AttendanceRiskController extends GetxController {
  final CourseModel course;
  final bool studentOnly;

  AttendanceRiskController({required this.course, this.studentOnly = false});

  final risks = <AttendanceRiskModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadRisks();
  }

  Future<void> loadRisks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final sessions = await AttendanceRepository.instance.getSessions(
        course.courseId,
      );
      final enrollments = await AttendanceRepository.instance
          .getEnrolledStudents(course.courseId);
      final targets = await _targetStudents(enrollments, sessions);

      final loaded = <AttendanceRiskModel>[];
      Object? lastFailure;
      for (final target in targets) {
        try {
          loaded.add(await _buildRisk(target: target, sessions: sessions));
        } catch (e) {
          lastFailure = e;
        }
      }

      risks.assignAll(loaded);
      if (loaded.isEmpty && lastFailure != null) {
        throw lastFailure;
      }
    } catch (e) {
      risks.clear();
      errorMessage.value = e.toString();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<EnrollmentModel>> _targetStudents(
    List<EnrollmentModel> enrollments,
    List<AttendanceSessionModel> sessions,
  ) async {
    if (!studentOnly) return enrollments;

    final user = await UserRepository.instance.getCurrentUserData();
    if (user == null) return [];

    final enrolled = enrollments.where((student) {
      return student.studentId == user.uid ||
          (user.studentId.isNotEmpty && student.studentCode == user.studentId);
    }).toList();

    if (enrolled.isNotEmpty) return enrolled;

    final records = sessions.expand((session) => session.records).where((
      record,
    ) {
      return record.studentId == user.uid ||
          (user.studentId.isNotEmpty && record.studentCode == user.studentId);
    }).toList();
    if (records.isEmpty) return [];

    return [
      EnrollmentModel(
        studentId: user.uid,
        studentName: user.name,
        studentCode: user.studentId,
        batch: user.batch,
        department: user.department,
        roll: '',
        section: '',
        enrolledAt: DateTime.now(),
      ),
    ];
  }

  Future<AttendanceRiskModel> _buildRisk({
    required EnrollmentModel target,
    required List<AttendanceSessionModel> sessions,
  }) async {
    final attendancePercent = _attendancePercent(target, sessions);
    final recentTrend = _recentTrend(target, sessions);

    // CourseModel currently has no planned-session field, so unavailable data is
    // represented as zero rather than inventing a backend value.
    const sessionsRemaining = 0;
    final prompt = SPromptTemplates.attendanceRisk(
      studentName: target.studentName,
      courseName: course.courseName,
      attendancePercent: attendancePercent,
      recentTrend: recentTrend,
      sessionsRemaining: sessionsRemaining,
    );

    try {
      Map<String, dynamic>? json;
      for (var attempt = 0; attempt < 2 && json == null; attempt++) {
        try {
          final response = await AIService.instance.ask(prompt);
          json = _decodeResponse(response);
        } catch (_) {
          if (attempt == 1) {
            return _fallbackRisk(
              target: target,
              attendancePercent: attendancePercent,
              recentTrend: recentTrend,
            );
          }
        }
      }

      if (json == null) {
        return _fallbackRisk(
          target: target,
          attendancePercent: attendancePercent,
          recentTrend: recentTrend,
        );
      }

      return AttendanceRiskModel.fromAiResponse(
        studentId: target.studentId,
        studentCode: target.studentCode,
        studentName: target.studentName,
        attendancePercent: attendancePercent,
        json: json,
      );
    } on FormatException {
      return _fallbackRisk(
        target: target,
        attendancePercent: attendancePercent,
        recentTrend: recentTrend,
      );
    }
  }

  AttendanceRiskModel _fallbackRisk({
    required EnrollmentModel target,
    required double attendancePercent,
    required int recentTrend,
  }) {
    final isHighRisk = attendancePercent < 60 || recentTrend <= -20;
    final isMediumRisk = attendancePercent < 75 || recentTrend < 0;
    final level = isHighRisk
        ? AttendanceRiskLevel.high
        : isMediumRisk
        ? AttendanceRiskLevel.medium
        : AttendanceRiskLevel.low;

    final reason = switch (level) {
      AttendanceRiskLevel.high =>
        'Attendance is below 60% or the recent attendance trend is declining.',
      AttendanceRiskLevel.medium =>
        'Attendance is below 75% or the recent attendance trend needs attention.',
      AttendanceRiskLevel.low =>
        'Attendance is currently steady and above the intervention threshold.',
    };
    final recommendation = switch (level) {
      AttendanceRiskLevel.high =>
        'Meet with the teacher and attend every remaining class where possible.',
      AttendanceRiskLevel.medium =>
        'Prioritize upcoming classes and monitor attendance after each session.',
      AttendanceRiskLevel.low =>
        'Maintain the current attendance habit and stay consistent.',
    };

    return AttendanceRiskModel(
      studentId: target.studentId,
      studentCode: target.studentCode,
      studentName: target.studentName,
      attendancePercent: attendancePercent,
      riskLevel: level,
      reason: reason,
      recommendation: recommendation,
    );
  }

  double _attendancePercent(
    EnrollmentModel target,
    List<AttendanceSessionModel> sessions,
  ) {
    if (sessions.isEmpty) return 0;

    var attended = 0;
    for (final session in sessions) {
      final record = _recordFor(target, session);
      if (record?.status == 'present' || record?.status == 'late') {
        attended++;
      }
    }
    return attended / sessions.length * 100;
  }

  int _recentTrend(
    EnrollmentModel target,
    List<AttendanceSessionModel> sessions,
  ) {
    if (sessions.length < 4) return 0;

    final recent = sessions.take(3).toList();
    final previous = sessions.skip(3).take(3).toList();
    final recentRate = _rate(target, recent);
    final previousRate = _rate(target, previous);
    return ((recentRate - previousRate) * 100).round();
  }

  double _rate(EnrollmentModel target, List<AttendanceSessionModel> sessions) {
    if (sessions.isEmpty) return 0;
    final attended = sessions.where((session) {
      final status = _recordFor(target, session)?.status;
      return status == 'present' || status == 'late';
    }).length;
    return attended / sessions.length;
  }

  dynamic _recordFor(EnrollmentModel target, AttendanceSessionModel session) {
    for (final record in session.records) {
      if (record.studentId == target.studentId) return record;
      if (target.studentCode.isNotEmpty &&
          record.studentCode == target.studentCode) {
        return record;
      }
    }
    return null;
  }

  Map<String, dynamic> _decodeResponse(String response) {
    var clean = response.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'no response generated') {
      throw const FormatException(
        'AI did not generate an attendance-risk response',
      );
    }

    if (clean.startsWith('```')) {
      clean = clean.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      clean = clean.replaceFirst(RegExp(r'\s*```$'), '');
    }

    final objectStart = clean.indexOf('{');
    final objectEnd = clean.lastIndexOf('}');
    if (objectStart < 0 || objectEnd <= objectStart) {
      throw const FormatException('AI response did not contain JSON');
    }

    final decoded = jsonDecode(clean.substring(objectStart, objectEnd + 1));
    if (decoded is! Map) {
      throw const FormatException('AI response was not a JSON object');
    }
    return Map<String, dynamic>.from(decoded);
  }
}
