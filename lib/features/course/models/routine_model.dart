import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineModel {
  final String routineId;
  final String ownerId;
  final String ownerRole; // "student" | "teacher"
  final String courseId;
  final String courseCode;
  final String courseName;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoutineModel({
    required this.routineId,
    required this.ownerId,
    required this.ownerRole,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.createdAt,
    required this.updatedAt,
  });

  static RoutineModel empty() => RoutineModel(
    routineId: '',
    ownerId: '',
    ownerRole: '',
    courseId: '',
    courseCode: '',
    courseName: '',
    day: 'Sun',
    startTime: '',
    endTime: '',
    room: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory RoutineModel.fromJson(Map<String, dynamic> json, String id) {
    return RoutineModel(
      routineId: id,
      ownerId: json['ownerId'] ?? '',
      ownerRole: json['ownerRole'] ?? '',
      courseId: json['courseId'] ?? '',
      courseCode: json['courseCode'] ?? '',
      courseName: json['courseName'] ?? '',
      day: json['day'] ?? 'Sun',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      room: json['room'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'ownerRole': ownerRole,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  RoutineModel copyWith({
    String? routineId,
    String? ownerId,
    String? ownerRole,
    String? courseId,
    String? courseCode,
    String? courseName,
    String? day,
    String? startTime,
    String? endTime,
    String? room,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineModel(
      routineId: routineId ?? this.routineId,
      ownerId: ownerId ?? this.ownerId,
      ownerRole: ownerRole ?? this.ownerRole,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOther => courseCode == 'Others';
}