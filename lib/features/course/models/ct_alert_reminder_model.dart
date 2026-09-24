import 'package:cloud_firestore/cloud_firestore.dart';

class CtAlertReminderModel {
  final String reminderId;
  final String courseId;
  final String alertId;
  final String studentId;
  final String title;
  final String message;
  final double suggestedStudyHours;
  final DateTime createdAt;

  const CtAlertReminderModel({
    required this.reminderId,
    required this.courseId,
    required this.alertId,
    required this.studentId,
    required this.title,
    required this.message,
    required this.suggestedStudyHours,
    required this.createdAt,
  });

  factory CtAlertReminderModel.fromJson(Map<String, dynamic> json, String id) {
    return CtAlertReminderModel(
      reminderId: id,
      courseId: json['courseId'] ?? '',
      alertId: json['alertId'] ?? '',
      studentId: json['studentId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      suggestedStudyHours:
          (json['suggestedStudyHours'] as num?)?.toDouble() ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alertId': alertId,
      'courseId': courseId,
      'studentId': studentId,
      'title': title,
      'message': message,
      'suggestedStudyHours': suggestedStudyHours,
      'createdAt': createdAt,
    };
  }
}
