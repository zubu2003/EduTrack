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

    final ct = data.cts[ctTitle];
    if (ct == null) return null;

    return ct.marks[user.value.uid];
  }

  /// How many CTs the student has marks for (excluding unpublished if desired)
  int getAvailableCtCount() {
    final data = ctData.value;
    if (data == null) return 0;

    int count = 0;
    for (final ct in data.cts.values) {
      if (ct.marks.containsKey(user.value.uid)) {
        count++;
      }
    }
    return count;
  }

  /// How many CTs should be counted for best-of-N
  /// = min(bestOfCount, availableCts)
  int getEffectiveBestCount() {
    final data = ctData.value;
    if (data == null) return 0;
    final available = getAvailableCtCount();
    if (available == 0) return 0;
    return available < data.bestOfCount ? available : data.bestOfCount;
  }

  /// Best N total for current student
  /// Uses min(bestOfCount, availableCts) instead of always bestOfCount
  double getBest3Total() {
    final data = ctData.value;
    if (data == null) return 0;

    // Collect all available marks for this student
    final marks = <double>[];
    for (final ct in data.cts.values) {
      final mark = ct.marks[user.value.uid];
      if (mark != null) marks.add(mark);
    }

    if (marks.isEmpty) return 0;

    // Sort descending, take top N
    marks.sort((a, b) => b.compareTo(a));
    final effectiveCount = getEffectiveBestCount();
    return marks.take(effectiveCount).fold<double>(0, (sum, m) => sum + m);
  }

  /// Average = best total / effective count
  double getAverage() {
    final effective = getEffectiveBestCount();
    if (effective == 0) return 0;
    return getBest3Total() / effective;
  }

  /// Percentage = best total / (effective * fullMarks) * 100
  double getPercentage() {
    final data = ctData.value;
    if (data == null) return 0;
    final effective = getEffectiveBestCount();
    if (effective == 0) return 0;

    final maxTotal = data.fullMarks * effective;
    if (maxTotal == 0) return 0;

    return (getBest3Total() / maxTotal) * 100;
  }
}