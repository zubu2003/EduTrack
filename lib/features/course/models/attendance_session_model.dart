import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';

class AttendanceSessionModel {
  final String sessionId;
  final String courseId;
  final String date; // "2026-08-10"
  final String lecture; // "Lecture 6: Advanced Cloud"
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final List<AttendanceRecordModel> records;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceSessionModel({
    required this.sessionId,
    required this.courseId,
    required this.date,
    required this.lecture,
    required this.totalStudents,
    required this.presentCount,
    required this.absentCount,
    required this.records,
    required this.createdAt,
    required this.updatedAt,
  });

  static AttendanceSessionModel empty() => AttendanceSessionModel(
    sessionId: '',
    courseId: '',
    date: '',
    lecture: '',
    totalStudents: 0,
    presentCount: 0,
    absentCount: 0,
    records: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory AttendanceSessionModel.fromJson(
      Map<String, dynamic> json, String id) {
    final recordsData = json['records'] as List<dynamic>? ?? [];
    final records = recordsData
        .map((r) => AttendanceRecordModel.fromJson(r as Map<String, dynamic>))
        .toList();

    return AttendanceSessionModel(
      sessionId: id,
      courseId: json['courseId'] ?? '',
      date: json['date'] ?? '',
      lecture: json['lecture'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      records: records,
      createdAt:
      (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
      (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'date': date,
      'lecture': lecture,
      'totalStudents': totalStudents,
      'presentCount': presentCount,
      'absentCount': absentCount,
      'records': records.map((r) => r.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Get formatted date like "10 Aug 2026"
  String get formattedDate {
    try {
      final dt = DateTime.parse(date);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return date;
    }
  }

  AttendanceSessionModel copyWith({
    String? sessionId,
    String? courseId,
    String? date,
    String? lecture,
    int? totalStudents,
    int? presentCount,
    int? absentCount,
    List<AttendanceRecordModel>? records,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceSessionModel(
      sessionId: sessionId ?? this.sessionId,
      courseId: courseId ?? this.courseId,
      date: date ?? this.date,
      lecture: lecture ?? this.lecture,
      totalStudents: totalStudents ?? this.totalStudents,
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
      records: records ?? this.records,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}