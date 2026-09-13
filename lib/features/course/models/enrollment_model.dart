import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentModel {
  final String studentId;
  final String studentName;
  final String studentCode;
  final String batch;
  final String department;
  final String roll;
  final String section;
  final DateTime enrolledAt;

  EnrollmentModel({
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.batch,
    required this.department,
    required this.roll,
    required this.section,
    required this.enrolledAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentCode: json['studentCode'] ?? '',
      batch: json['batch'] ?? '',
      department: json['department'] ?? '',
      roll: json['roll'] ?? '',
      section: json['section'] ?? '',
      enrolledAt:
      (json['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentCode': studentCode,
      'batch': batch,
      'department': department,
      'roll': roll,
      'section': section,
      'enrolledAt': enrolledAt,
    };
  }
}