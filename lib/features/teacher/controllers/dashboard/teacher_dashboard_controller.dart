import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/features/teacher/screens/course_details/teacher_course_details_screen.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class TeacherDashboardController extends GetxController {
  static TeacherDashboardController get instance => Get.find();

  // User
  Rx<UserModel> user = UserModel.empty().obs;

  // Today's routine
  RxList<RoutineModel> todayClasses = <RoutineModel>[].obs;
  RxList<RoutineModel> allRoutines = <RoutineModel>[].obs;

  // Teacher's courses
  RxList<CourseModel> myCourses = <CourseModel>[].obs;

  // Stats
  RxInt todayClassesCount = 0.obs;
  RxInt totalCoursesCount = 0.obs;
  RxInt totalStudentsCount = 0.obs;

  // Loading
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final userData = await UserRepository.instance.getCurrentUserData();
      if (userData == null) return;

      user.value = userData;

      // 1. Fetch routines
      final routines =
      await RoutineRepository.instance.getUserRoutines(userData.uid);

      allRoutines.value = routines;

      final todayDay = _todayDayName();

      final allToday = routines.where((r) => r.day == todayDay).toList();

      allToday.sort((a, b) => _timeToMinutes(a.startTime)
          .compareTo(_timeToMinutes(b.startTime)));

      // ✅ Filter out "Others" — only real courses for Today's Classes
      final courseEntries =
      allToday.where((r) => r.courseCode != 'Others').toList();

      final nowMinutes = _nowInMinutes();
      final upcoming = courseEntries.where((r) {
        final endMinutes = _timeToMinutes(r.endTime);
        return endMinutes >= nowMinutes;
      }).toList();

      todayClasses.value = upcoming.take(2).toList();

      // 2. Fetch teacher's courses
      final courses =
      await CourseRepository.instance.getTeacherCourses(userData.uid);

      myCourses.value = courses;

      // 3. Compute stats
      totalCoursesCount.value = courses.length;

      totalStudentsCount.value = courses.fold<int>(
        0,
            (sum, course) => sum + course.totalStudents,
      );

      // ✅ Today's Classes = count of real course entries only (no Others)
      todayClassesCount.value = courseEntries.length;
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (!errStr.contains('unable to resolve') &&
          !errStr.contains('unavailable') &&
          !errStr.contains('network')) {
        SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openCourseDetails(RoutineModel routine) async {
    try {
      if (routine.courseCode == 'Others' || routine.courseId.isEmpty) return;

      final course = await CourseRepository.instance
          .getCourseById(routine.courseId);
      if (course == null) return;

      Get.to(() => TeacherCourseDetailsScreen(course: course));
    } catch (e) {
      // Silent
    }
  }

  void openRoutine() {
    Get.toNamed(
      AppRoutes.teacherRoutine,
      arguments: {'initialDay': _todayDayName()},
    );
  }

  /// Greeting based on time of day
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
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

  int _nowInMinutes() {
    final now = DateTime.now();
    return now.hour * 60 + now.minute;
  }

  int _timeToMinutes(String time) {
    try {
      final parts = time.trim().split(' ');
      if (parts.length != 2) return 0;
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final min = int.parse(hm[1]);
      final period = parts[1].toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return hour * 60 + min;
    } catch (e) {
      return 0;
    }
  }
}