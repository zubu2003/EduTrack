import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_reminder_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/ct_alert_reminder_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';

class CtAlertReminderService extends GetxService {
  static CtAlertReminderService get instance => Get.find();

  Future<void> generateForAlert({
    required CtAlertModel alert,
    required List<EnrollmentModel> students,
  }) async {
    for (final student in students) {
      try {
        final attendance = await _attendancePercent(student, alert.courseId);
        final response = await AIService.instance.ask(
          SPromptTemplates.ctReminder(
            studentName: student.studentName,
            courseName: alert.courseName,
            ctTitle: alert.ctTitle,
            topics: alert.topics,
            daysUntil: alert.daysRemaining,
            attendancePercent: attendance,
          ),
        );
        final json = _decodeResponse(response);
        final title = json['title'];
        final message = json['message'];
        final hours = _studyHours(json['suggestedStudyHours']);
        if (title is! String ||
            message is! String ||
            hours == null ||
            !hours.isFinite ||
            hours < 0) {
          continue;
        }
        if (title.trim().isEmpty || message.trim().isEmpty) continue;

        await CtAlertReminderRepository.instance.saveReminder(
          CtAlertReminderModel(
            reminderId: '',
            courseId: alert.courseId,
            alertId: alert.alertId,
            studentId: student.studentId,
            title: title.trim(),
            message: message.trim(),
            suggestedStudyHours: hours,
            createdAt: DateTime.now(),
          ),
        );
      } catch (_) {
        // A reminder failure must never invalidate the saved CT alert.
      }
    }
  }

  Future<double> _attendancePercent(
    EnrollmentModel student,
    String courseId,
  ) async {
    final records = await AttendanceRepository.instance.getStudentAttendance(
      courseId: courseId,
      studentUid: student.studentId,
      studentCode: student.studentCode,
    );
    if (records.isEmpty) return 0;
    final attended = records.where((record) {
      return record['status'] == 'present' || record['status'] == 'late';
    }).length;
    return attended / records.length * 100;
  }

  double? _studyHours(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic> _decodeResponse(String response) {
    final start = response.indexOf('{');
    final end = response.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FormatException('AI reminder response did not contain JSON');
    }
    final decoded = jsonDecode(response.substring(start, end + 1));
    if (decoded is! Map) {
      throw const FormatException('AI reminder response was not an object');
    }
    return Map<String, dynamic>.from(decoded);
  }
}
