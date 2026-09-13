import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class StudentCoursesController extends GetxController {
  static StudentCoursesController get instance => Get.find();

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

      final list = await CourseRepository.instance.getStudentCourses(user.uid);
      courses.value = list;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCourses() async {
    await fetchStudentCourses();
  }
}