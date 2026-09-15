import 'package:get/get.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class StudentCtMarksController extends GetxController {
  final CourseModel course;

  StudentCtMarksController({required this.course});

  // Data
  Rx<CtDataModel?> ctData = Rx<CtDataModel?>(null);
  Rx<UserModel> user = UserModel.empty().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final u = await UserRepository.instance.getCurrentUserData();
      if (u != null) user.value = u;

      final data = await CtMarksRepository.instance.getCtData(course.courseId);
      ctData.value = data;
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

  /// Get the current student's mark for a specific CT
  double? getMarkForCt(String ctTitle) {
    final data = ctData.value;
    if (data == null) return null;
    return data.cts[ctTitle]?.marks[user.value.uid];
  }

  bool isAbsentForCt(String ctTitle) {
    return CtMark.isAbsent(getMarkForCt(ctTitle));
  }

  int get bestOfCount {
    return course.credit > 0 ? course.credit : (ctData.value?.bestOfCount ?? 3);
  }

  /// Numeric marks only (abs skipped)
  int getAvailableCtCount() {
    final data = ctData.value;
    if (data == null) return 0;
    return data.numericMarksFor(user.value.uid).length;
  }

  int getEffectiveBestCount() => bestOfCount;

  /// Best n of n+1 CTs for current student (abs ignored)
  double getBest3Total() {
    final data = ctData.value;
    if (data == null) return 0;
    return data.computeCourseTotal(user.value.uid, bestOfCount);
  }

  /// Average across the counted best-n CTs
  double getAverage() {
    final n = bestOfCount;
    if (n == 0) return 0;
    return getBest3Total() / n;
  }

  /// Percentage vs fullMarks * credit
  double getPercentage() {
    final data = ctData.value;
    if (data == null) return 0;
    final n = bestOfCount;
    if (n == 0) return 0;
    final maxTotal = data.fullMarks * n;
    if (maxTotal == 0) return 0;
    return (getBest3Total() / maxTotal) * 100;
  }
}