import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/personalization/controllers/user_controller.dart';
import 'package:edutrack/utils/helper/network_manager.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationRepository());
    Get.put(UserRepository());
    Get.put(CourseRepository());
    Get.put(AttendanceRepository());
    Get.put(RoutineRepository());
    Get.put(UserController());
    Get.put(NetworkManager());
  }
}