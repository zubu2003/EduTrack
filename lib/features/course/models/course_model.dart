import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String courseId;
  final String courseCode;
  final String courseName;
  final int credit;
  final String batch;
  final String department;
  final int startRoll;
  final int maxStudents;
  final String section;
  final String teacherId;
  final String teacherName;
  final int totalStudents;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.credit,
    required this.batch,
    required this.department,
    required this.startRoll,
    required this.maxStudents,
    required this.section,
    required this.teacherId,
    required this.teacherName,
    required this.totalStudents,
    required this.createdAt,
    required this.updatedAt,
  });

  static CourseModel empty() => CourseModel(
    courseId: '',
    courseCode: '',
    courseName: '',
    credit: 0,
    batch: '',
    department: '',
    startRoll: 1,
    maxStudents: 66,
    section: 'A',
    teacherId: '',
    teacherName: '',
    totalStudents: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory CourseModel.fromJson(Map<String, dynamic> json, String id) {
    return CourseModel(
      courseId: id,
      courseCode: json['courseCode'] ?? '',
      courseName: json['courseName'] ?? '',
      credit: json['credit'] ?? 0,
      batch: json['batch'] ?? '',
      department: json['department'] ?? '',
      startRoll: json['startRoll'] ?? 1,
      maxStudents: json['maxStudents'] ?? 66,
      section: json['section'] ?? 'A',
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'credit': credit,
      'batch': batch,
      'department': department,
      'startRoll': startRoll,
      'maxStudents': maxStudents,
      'section': section,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'totalStudents': totalStudents,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CourseModel copyWith({
    String? courseId,
    String? courseCode,
    String? courseName,
    int? credit,
    String? batch,
    String? department,
    int? startRoll,
    int? maxStudents,
    String? section,
    String? teacherId,
    String? teacherName,
    int? totalStudents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      credit: credit ?? this.credit,
      batch: batch ?? this.batch,
      department: department ?? this.department,
      startRoll: startRoll ?? this.startRoll,
      maxStudents: maxStudents ?? this.maxStudents,
      section: section ?? this.section,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      totalStudents: totalStudents ?? this.totalStudents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}