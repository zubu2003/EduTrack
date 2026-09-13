import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class StudentAttendanceController extends GetxController {
  final CourseModel course;

  StudentAttendanceController({required this.course});

  RxBool isLoading = true.obs;
  RxList<Map<String, dynamic>> records = <Map<String, dynamic>>[].obs;

  int get totalCount => records.length;

  int get presentCount => records
      .where((r) => r['status'] == 'present' || r['status'] == 'late')
      .length;

  int get absentCount =>
      records.where((r) => r['status'] == 'absent').length;

  double get percentage =>
      totalCount == 0 ? 0 : (presentCount / totalCount) * 100;

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      isLoading.value = true;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        records.clear();
        return;
      }

      final list = await AttendanceRepository.instance.getStudentAttendance(
        courseId: course.courseId,
        studentUid: user.uid,
        studentCode: user.studentId,
      );
      records.value = list;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
