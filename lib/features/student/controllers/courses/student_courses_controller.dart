import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class StudentCoursesController extends GetxController {
  static StudentCoursesController get instance => Get.find();

  final bool showTodayOnly;

  StudentCoursesController({required this.showTodayOnly});

  RxList<CourseModel> courses = <CourseModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudentCourses();
  }

  Future<void> fetchStudentCourses() async {
    try {
      isLoading.value = true;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      // Fetch all enrolled courses
      final allCourses =
      await CourseRepository.instance.getStudentCourses(user.uid);

      if (!showTodayOnly) {
        courses.value = allCourses;
        return;
      }

      // ✅ Today-only: filter by today's routine
      final routines =
      await RoutineRepository.instance.getUserRoutines(user.uid);

      final todayDay = _todayDayName();
      final todayCourseIds = routines
          .where((r) => r.day == todayDay && r.courseCode != 'Others')
          .map((r) => r.courseId)
          .where((id) => id.isNotEmpty)
          .toSet();

      final filtered = allCourses
          .where((c) => todayCourseIds.contains(c.courseId))
          .toList();

      courses.value = filtered;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCourses() async {
    await fetchStudentCourses();
  }

  String _todayDayName() {
    final now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Sun';
    }
  }
}