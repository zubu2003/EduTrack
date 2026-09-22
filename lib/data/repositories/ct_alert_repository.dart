import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';

class CtAlertRepository extends GetxController {
  static CtAlertRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  Future<String> createAlert(CtAlertModel alert) async {
    try {
      final reference = await _firestore
          .collection('courses')
          .doc(alert.courseId)
          .collection('ct_alerts')
          .add(alert.toJson());
      return reference.id;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to create CT alert: $e';
    }
  }

  Future<List<CtAlertModel>> getCourseAlerts(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_alerts')
          .get();
      final alerts = snapshot.docs
          .map((doc) => CtAlertModel.fromJson(doc.data(), doc.id))
          .where((alert) => !alert.scheduledAt.isBefore(DateTime.now()))
          .toList();
      alerts.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      return alerts;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load CT alerts: $e';
    }
  }

  Future<List<CtAlertModel>> getAlertsForCourses(List<String> courseIds) async {
    final alerts = <CtAlertModel>[];
    for (final courseId in courseIds) {
      alerts.addAll(await getCourseAlerts(courseId));
    }
    alerts.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return alerts;
  }
}
