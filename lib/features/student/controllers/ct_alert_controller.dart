import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_reminder_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/ct_alert_reminder_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class StudentCtAlertController extends GetxController {
  final alerts = <CtAlertModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        alerts.clear();
        return;
      }
      final courses = await CourseRepository.instance.getStudentCourses(
        user.uid,
      );
      final loaded = await CtAlertRepository.instance.getAlertsForCourses(
        courses.map((course) => course.courseId).toList(),
      );
      final enriched = <CtAlertModel>[];
      for (final alert in loaded) {
        CtAlertReminderModel? reminder;
        try {
          reminder = await CtAlertReminderRepository.instance.getForStudent(
            courseId: alert.courseId,
            alertId: alert.alertId,
            studentId: user.uid,
          );
        } catch (_) {
          // The CT alert remains usable when its optional reminder is unavailable.
        }
        enriched.add(
          reminder == null ? alert : alert.copyWith(reminder: reminder),
        );
      }
      alerts.assignAll(enriched);
    } catch (e) {
      alerts.clear();
      errorMessage.value = e.toString();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
