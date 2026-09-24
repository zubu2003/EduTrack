import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/features/announcement/models/announcement_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes and restores a course announcement', () {
    final createdAt = DateTime(2026, 9, 24, 10, 30);
    final announcement = AnnouncementModel(
      announcementId: 'announcement-1',
      courseId: 'course-1',
      courseCode: 'CSE-321',
      courseName: 'Data Structures',
      courseSection: 'A',
      title: 'Class moved',
      content: 'Today\'s class starts at 11:00.',
      authorId: 'teacher-1',
      authorName: 'Teacher',
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    final restored = AnnouncementModel.fromJson(
      announcement.toJson(),
      announcement.announcementId,
    );

    expect(restored.announcementId, 'announcement-1');
    expect(restored.courseId, 'course-1');
    expect(restored.courseCode, 'CSE-321');
    expect(restored.courseSection, 'A');
    expect(restored.title, 'Class moved');
    expect(restored.content, contains('11:00'));
    expect(restored.authorId, 'teacher-1');
  });

  test(
    'restores Firestore timestamps and tolerates missing optional fields',
    () {
      final timestamp = Timestamp.fromDate(DateTime(2026, 9, 24));
      final announcement = AnnouncementModel.fromJson({
        'courseId': 'course-1',
        'title': 'Notice',
        'createdAt': timestamp,
        'updatedAt': timestamp,
      }, 'announcement-2');

      expect(announcement.announcementId, 'announcement-2');
      expect(announcement.courseId, 'course-1');
      expect(announcement.title, 'Notice');
      expect(announcement.content, isEmpty);
      expect(announcement.createdAt, DateTime(2026, 9, 24));
    },
  );

  test('copyWith preserves identity and changes announcement content', () {
    final announcement = AnnouncementModel(
      announcementId: 'announcement-1',
      courseId: 'course-1',
      courseCode: 'CSE-321',
      courseName: 'Data Structures',
      courseSection: 'A',
      title: 'Old title',
      content: 'Old content',
      authorId: 'teacher-1',
      authorName: 'Teacher',
      createdAt: DateTime(2026, 9, 1),
      updatedAt: DateTime(2026, 9, 1),
    );

    final updated = announcement.copyWith(
      title: 'New title',
      content: 'New content',
      updatedAt: DateTime(2026, 9, 24),
    );

    expect(updated.announcementId, announcement.announcementId);
    expect(updated.authorId, announcement.authorId);
    expect(updated.title, 'New title');
    expect(updated.content, 'New content');
    expect(updated.createdAt, announcement.createdAt);
    expect(updated.updatedAt, DateTime(2026, 9, 24));
  });
}
