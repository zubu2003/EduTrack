import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/ct_alert_reminder_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';

class CtAlertReminderRepository extends GetxController {
  static CtAlertReminderRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  Future<void> saveReminder(CtAlertReminderModel reminder) async {
    try {
      await _firestore
          .collection('courses')
          .doc(reminder.courseId)
          .collection('ct_alerts')
          .doc(reminder.alertId)
          .collection('reminders')
          .doc(reminder.studentId)
          .set(reminder.toJson());
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to save CT reminder: $e';
    }
  }

  Future<CtAlertReminderModel?> getForStudent({
    required String courseId,
    required String alertId,
    required String studentId,
  }) async {
    try {
      final doc = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_alerts')
          .doc(alertId)
          .collection('reminders')
          .doc(studentId)
          .get();
      if (!doc.exists || doc.data() == null) return null;
      return CtAlertReminderModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load CT reminder: $e';
    }
  }
}
