import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  final String announcementId;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String courseSection;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AnnouncementModel({
    required this.announcementId,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.courseSection,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json, String id) {
    return AnnouncementModel(
      announcementId: id,
      courseId: (json['courseId'] ?? '').toString(),
      courseCode: (json['courseCode'] ?? '').toString(),
      courseName: (json['courseName'] ?? '').toString(),
      courseSection: (json['courseSection'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      authorId: (json['authorId'] ?? '').toString(),
      authorName: (json['authorName'] ?? '').toString(),
      createdAt: _readDate(json['createdAt']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'courseSection': courseSection,
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  AnnouncementModel copyWith({
    String? title,
    String? content,
    String? courseCode,
    String? courseName,
    String? courseSection,
    DateTime? updatedAt,
  }) {
    return AnnouncementModel(
      announcementId: announcementId,
      courseId: courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      courseSection: courseSection ?? this.courseSection,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId,
      authorName: authorName,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
