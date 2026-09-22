import 'package:cloud_firestore/cloud_firestore.dart';
import 'ct_alert_reminder_model.dart';

class CtAlertModel {
  final String alertId;
  final String courseId;
  final String courseName;
  final String ctTitle;
  final String topics;
  final DateTime scheduledAt;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CtAlertReminderModel? reminder;

  const CtAlertModel({
    required this.alertId,
    required this.courseId,
    required this.courseName,
    required this.ctTitle,
    required this.topics,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
    this.reminder,
  });

  factory CtAlertModel.fromJson(Map<String, dynamic> json, String id) {
    return CtAlertModel(
      alertId: id,
      courseId: json['courseId'] ?? '',
      courseName: json['courseName'] ?? '',
      ctTitle: json['ctTitle'] ?? '',
      topics: json['topics'] ?? '',
      scheduledAt:
          (json['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'ctTitle': ctTitle,
      'topics': topics,
      'scheduledAt': scheduledAt,
      'durationMinutes': durationMinutes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CtAlertModel copyWith({CtAlertReminderModel? reminder}) {
    return CtAlertModel(
      alertId: alertId,
      courseId: courseId,
      courseName: courseName,
      ctTitle: ctTitle,
      topics: topics,
      scheduledAt: scheduledAt,
      durationMinutes: durationMinutes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      reminder: reminder ?? this.reminder,
    );
  }

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
    return date.difference(today).inDays;
  }

  String get formattedDate {
    final local = scheduledAt.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.day}/${local.month}/${local.year} at $hour:$minute $period';
  }
}
