import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class RoutineController extends GetxController {
  final String userRole;

  RoutineController({required this.userRole});

  // User's courses
  RxList<CourseModel> myCourses = <CourseModel>[].obs;

  // Routines grouped by day
  RxMap<String, List<RoutineModel>> routineByDay =
      <String, List<RoutineModel>>{}.obs;

  // View state
  RxString selectedDay = 'Sun'.obs;
  RxBool isLoading = true.obs;
  RxBool isSaving = false.obs;

  // Form
  final addRoutineFormKey = GlobalKey<FormState>();
  RxString selectedCourseCode = 'Others'.obs;
  RxString selectedCourseId = 'Others'.obs;
  RxString selectedCourseName = ''.obs;
  final customCourseNameController = TextEditingController();
  final roomController = TextEditingController();
  RxString selectedDayForm = 'Sun'.obs;
  RxString startTime = '10:00 AM'.obs;
  RxString endTime = '11:00 AM'.obs;

  static const List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  @override
  void onInit() {
    super.onInit();

    // Default to today's day (or Sunday if weekend)
    selectedDay.value = _routineDayOrDefault();

    fetchMyCourses();
    fetchRoutines();
  }

  // ─── DAY HELPERS ───

  /// Today's day short name (Mon, Tue, ...)
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

  /// Today's day if it's a routine day, else fallback to Sunday
  String _routineDayOrDefault() {
    final today = _todayDayName();
    if (days.contains(today)) {
      return today;
    }
    return 'Sun';
  }

  // ─── FETCH ───

  Future<void> fetchMyCourses() async {
    try {
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      if (userRole == 'teacher') {
        myCourses.value =
        await CourseRepository.instance.getTeacherCourses(user.uid);
      } else {
        myCourses.value =
        await CourseRepository.instance.getStudentCourses(user.uid);
      }
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (!errStr.contains('unable to resolve') &&
          !errStr.contains('unavailable') &&
          !errStr.contains('network')) {
        SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
      }
    }
  }

  Future<void> fetchRoutines() async {
    try {
      isLoading.value = true;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      final routines =
      await RoutineRepository.instance.getUserRoutines(user.uid);

      final Map<String, List<RoutineModel>> grouped = {
        for (final d in days) d: []
      };
      for (final r in routines) {
        grouped.putIfAbsent(r.day, () => []).add(r);
      }

      for (final day in grouped.keys) {
        grouped[day]!.sort((a, b) => a.startTime.compareTo(b.startTime));
      }

      routineByDay.value = grouped;
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

  // ─── DAY SELECTION ───

  void selectDay(String day) => selectedDay.value = day;

  void selectFormDay(String day) => selectedDayForm.value = day;

  // ─── FORM ───

  void selectCourse(String courseCode, String courseId, String courseName) {
    selectedCourseCode.value = courseCode;
    selectedCourseId.value = courseId;
    selectedCourseName.value = courseName;

    if (courseCode == 'Others') {
      customCourseNameController.clear();
    }
  }

  Future<void> createRoutine() async {
    try {
      if (!addRoutineFormKey.currentState!.validate()) return;

      final String finalCourseName;
      if (selectedCourseCode.value == 'Others') {
        final custom = customCourseNameController.text.trim();
        if (custom.isEmpty) {
          SSnackBarHelpers.errorSnackBar(
            title: 'Missing Info',
            message: 'Please enter a name for the routine',
          );
          return;
        }
        finalCourseName = custom;
      } else {
        finalCourseName = selectedCourseName.value;
      }

      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog('Saving routine...');

      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        SFullScreenLoader.stopLoading();
        return;
      }

      final newRoutine = RoutineModel(
        routineId: '',
        ownerId: user.uid,
        ownerRole: userRole,
        courseId: selectedCourseId.value == 'Others'
            ? ''
            : selectedCourseId.value,
        courseCode: selectedCourseCode.value,
        courseName: finalCourseName,
        day: selectedDayForm.value,
        startTime: startTime.value,
        endTime: endTime.value,
        room: roomController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await RoutineRepository.instance.createRoutine(newRoutine);

      SFullScreenLoader.stopLoading();
      isSaving.value = false;

      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Routine added successfully',
      );

      clearForm();
      await fetchRoutines();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      isSaving.value = false;
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      if (!addRoutineFormKey.currentState!.validate()) return;

      final String finalCourseName;
      if (selectedCourseCode.value == 'Others') {
        final custom = customCourseNameController.text.trim();
        if (custom.isEmpty) {
          SSnackBarHelpers.errorSnackBar(
            title: 'Missing Info',
            message: 'Please enter a name for the routine',
          );
          return;
        }
        finalCourseName = custom;
      } else {
        finalCourseName = selectedCourseName.value;
      }

      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog('Updating routine...');

      final updated = routine.copyWith(
        courseId: selectedCourseId.value == 'Others'
            ? ''
            : selectedCourseId.value,
        courseCode: selectedCourseCode.value,
        courseName: finalCourseName,
        day: selectedDayForm.value,
        startTime: startTime.value,
        endTime: endTime.value,
        room: roomController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await RoutineRepository.instance.updateRoutine(updated);

      SFullScreenLoader.stopLoading();
      isSaving.value = false;

      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Routine updated successfully',
      );

      clearForm();
      await fetchRoutines();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      isSaving.value = false;
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteRoutine(RoutineModel routine) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Routine'),
        content: Text('Delete "${routine.courseName}" on ${routine.day}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              try {
                await RoutineRepository.instance
                    .deleteRoutine(routine.routineId);
                SSnackBarHelpers.successSnackBar(
                  title: 'Deleted',
                  message: 'Routine deleted successfully',
                );
                await fetchRoutines();
              } catch (e) {
                SSnackBarHelpers.errorSnackBar(
                    title: 'Error', message: e.toString());
              }
            },
            child:
            const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── FORM HELPERS ───

  void loadRoutineForEdit(RoutineModel routine) {
    if (routine.courseCode == 'Others' ||
        routine.courseId.isEmpty ||
        routine.courseId == 'Others') {
      selectedCourseCode.value = 'Others';
      selectedCourseId.value = 'Others';
      selectedCourseName.value = '';
      customCourseNameController.text = routine.courseName;
    } else {
      selectedCourseCode.value = routine.courseCode;
      selectedCourseId.value = routine.courseId;
      selectedCourseName.value = routine.courseName;
      customCourseNameController.clear();
    }

    selectedDayForm.value = routine.day;
    startTime.value = routine.startTime;
    endTime.value = routine.endTime;
    roomController.text = routine.room;
  }

  void clearForm() {
    selectedCourseCode.value = 'Others';
    selectedCourseId.value = 'Others';
    selectedCourseName.value = '';
    selectedDayForm.value = 'Sun';
    startTime.value = '10:00 AM';
    endTime.value = '11:00 AM';
    roomController.clear();
    customCourseNameController.clear();
  }

  @override
  void onClose() {
    customCourseNameController.dispose();
    roomController.dispose();
    super.onClose();
  }
}