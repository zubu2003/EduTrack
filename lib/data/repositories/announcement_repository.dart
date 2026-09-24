import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/announcement/models/announcement_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';

class AnnouncementRepository extends GetxController {
  static AnnouncementRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  Future<String> createAnnouncement(AnnouncementModel announcement) async {
    try {
      final reference = await _firestore
          .collection('courses')
          .doc(announcement.courseId)
          .collection('announcements')
          .add(announcement.toJson());
      return reference.id;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (_) {
      throw 'Failed to create announcement.';
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore
          .collection('courses')
          .doc(announcement.courseId)
          .collection('announcements')
          .doc(announcement.announcementId)
          .update({
            'courseCode': announcement.courseCode,
            'courseName': announcement.courseName,
            'courseSection': announcement.courseSection,
            'title': announcement.title,
            'content': announcement.content,
            'updatedAt': announcement.updatedAt,
          });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (_) {
      throw 'Failed to update announcement.';
    }
  }

  Future<List<AnnouncementModel>> getAnnouncementsForCourses(
    List<CourseModel> courses,
  ) async {
    try {
      final announcements = <AnnouncementModel>[];
      for (final course in courses) {
        final snapshot = await _firestore
            .collection('courses')
            .doc(course.courseId)
            .collection('announcements')
            .get();
        announcements.addAll(
          snapshot.docs.map(
            (doc) => AnnouncementModel.fromJson(doc.data(), doc.id),
          ),
        );
      }
      announcements.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return announcements;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (_) {
      throw 'Failed to load announcements.';
    }
  }
}
