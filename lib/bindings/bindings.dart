import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/announcement_repository.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_reminder_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/ct_alert_reminder_service.dart';
import 'package:edutrack/data/services/cloudinary/cloudinary_services.dart';
import 'package:edutrack/data/services/tts/tts_service.dart';
import 'package:edutrack/features/personalization/controllers/user_controller.dart';
import 'package:edutrack/utils/helper/network_manager.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.put(AuthenticationRepository());
    Get.put(UserRepository());
    Get.put(CourseRepository());
    Get.put(AttendanceRepository());
    Get.put(AnnouncementRepository());
    Get.put(RoutineRepository());
    Get.put(CtMarksRepository());
    Get.put(CtAlertRepository());
    Get.put(CtAlertReminderRepository());

    // Services
    Get.put(CloudinaryServices());
    Get.put(TextToSpeechService());
    Get.put(AIService());
    Get.put(CtAlertReminderService());

    // Controllers
    Get.put(UserController());

    // Helpers
    Get.put(NetworkManager());
  }
}
