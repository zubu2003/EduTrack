import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/helper/student_id_parser.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class TeacherCoursesController extends GetxController {
  static TeacherCoursesController get instance => Get.find();

  // ================================================================
  // OBSERVABLES
  // ================================================================
  RxList<CourseModel> courses = <CourseModel>[].obs;
  RxBool isLoading = true.obs;

  // Flag: filter to today's classes only
  bool showTodayOnly = false;

  // ================================================================
  // CREATE / EDIT COURSE FORM
  // ================================================================
  final createCourseFormKey = GlobalKey<FormState>();
  final courseCodeController = TextEditingController();
  final courseNameController = TextEditingController();
  final creditController = TextEditingController();
  final batchController = TextEditingController();
  final startRollController = TextEditingController();
  final maxStudentsController = TextEditingController(text: '66');
  RxString selectedDept = '04'.obs;

  // ================================================================
  // ASSIGN STUDENTS FORM
  // ================================================================
  final assignFormKey = GlobalKey<FormState>();
  final assignBatchController = TextEditingController();
  final assignStartRollController = TextEditingController();
  final assignMaxStudentsController = TextEditingController(text: '66');
  RxString assignDept = '04'.obs;

  RxList<UserModel> foundStudents = <UserModel>[].obs;
  RxMap<String, bool> selectedStudents = <String, bool>{}.obs;

  // ================================================================
  // LIFECYCLE
  // ================================================================
  @override
  void onInit() {
    super.onInit();
    fetchTeacherCourses();
  }

  // ================================================================
  // FETCH COURSES (auto-handles Today's mode via showTodayOnly flag)
  // ================================================================
  Future<void> fetchTeacherCourses() async {
    try {
      isLoading.value = true;

      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      // Fetch all teacher's courses
      final allCourses =
      await CourseRepository.instance.getTeacherCourses(user.uid);

      // Not today-only → just set all
      if (!showTodayOnly) {
        courses.value = allCourses;
        return;
      }

      // Today-only → filter by today's routine
      final routines =
      await RoutineRepository.instance.getUserRoutines(user.uid);

      final todayDay = _todayDayName();
      final todayCourseIds = routines
          .where((r) => r.day == todayDay && r.courseCode != 'Others')
          .map((r) => r.courseId)
          .where((id) => id.isNotEmpty)
          .toSet();

      courses.value = allCourses
          .where((c) => todayCourseIds.contains(c.courseId))
          .toList();
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================================================================
  // CREATE COURSE
  // ================================================================
  Future<void> createCourse() async {
    try {
      if (!createCourseFormKey.currentState!.validate()) return;

      final startRoll = int.tryParse(startRollController.text.trim()) ?? 1;
      final maxStudents =
          int.tryParse(maxStudentsController.text.trim()) ?? 66;

      if (startRoll < 1 || startRoll > 132) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Roll',
          message: 'Start roll must be between 1 and 132',
        );
        return;
      }

      if (maxStudents < 1) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Count',
          message: 'Max students must be at least 1',
        );
        return;
      }

      if (startRoll + maxStudents - 1 > 132) {
        SSnackBarHelpers.warningSnackBar(
          title: 'Notice',
          message:
          'Max roll is 132. You may find fewer students than requested.',
        );
      }

      SFullScreenLoader.openLoadingDialog('Creating course...');

      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        SFullScreenLoader.stopLoading();
        return;
      }

      final section = StudentIdParser.getSection(startRoll);

      final newCourse = CourseModel(
        courseId: '',
        courseCode: courseCodeController.text.trim().toUpperCase(),
        courseName: courseNameController.text.trim(),
        credit: int.tryParse(creditController.text.trim()) ?? 3,
        batch: batchController.text.trim(),
        department: selectedDept.value,
        startRoll: startRoll,
        maxStudents: maxStudents,
        section: section,
        teacherId: user.uid,
        teacherName: user.name,
        totalStudents: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await CourseRepository.instance.createCourse(newCourse);

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Course created successfully',
      );

      clearCreateForm();
      await fetchTeacherCourses();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // ================================================================
  // UPDATE COURSE
  // ================================================================
  Future<void> updateCourse(CourseModel course) async {
    try {
      if (!createCourseFormKey.currentState!.validate()) return;

      SFullScreenLoader.openLoadingDialog('Updating course...');

      final startRoll = int.tryParse(startRollController.text.trim()) ?? 1;
      final maxStudents =
          int.tryParse(maxStudentsController.text.trim()) ?? 66;
      final section = StudentIdParser.getSection(startRoll);

      final updated = course.copyWith(
        courseCode: courseCodeController.text.trim().toUpperCase(),
        courseName: courseNameController.text.trim(),
        credit: int.tryParse(creditController.text.trim()) ?? 3,
        batch: batchController.text.trim(),
        department: selectedDept.value,
        startRoll: startRoll,
        maxStudents: maxStudents,
        section: section,
        updatedAt: DateTime.now(),
      );

      await CourseRepository.instance.updateCourse(updated);

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Course updated successfully',
      );

      clearCreateForm();
      await fetchTeacherCourses();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // ================================================================
  // DELETE COURSE
  // ================================================================
  Future<void> deleteCourse(CourseModel course) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Course'),
        content: Text(
          'Are you sure you want to delete "${course.courseCode} - ${course.courseName}"?\n\n'
              'This will also remove all ${course.totalStudents} enrolled students.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              try {
                SFullScreenLoader.openLoadingDialog('Deleting course...');
                await CourseRepository.instance.deleteCourse(course.courseId);
                SFullScreenLoader.stopLoading();
                SSnackBarHelpers.successSnackBar(
                  title: 'Deleted',
                  message: 'Course deleted successfully',
                );
                await fetchTeacherCourses();
              } catch (e) {
                SFullScreenLoader.stopLoading();
                SSnackBarHelpers.errorSnackBar(
                    title: 'Error', message: e.toString());
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ASSIGN STUDENTS
  // ================================================================
  Future<void> previewStudents() async {
    try {
      final batch = assignBatchController.text.trim();
      final startRoll =
          int.tryParse(assignStartRollController.text.trim()) ?? 1;
      final maxStudents =
          int.tryParse(assignMaxStudentsController.text.trim()) ?? 66;

      if (batch.isEmpty) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Missing Batch',
          message: 'Please enter batch',
        );
        return;
      }

      SFullScreenLoader.openLoadingDialog('Searching students...');

      final students = await CourseRepository.instance.findStudentsByFilter(
        batch: batch,
        department: assignDept.value,
        startRoll: startRoll,
        maxStudents: maxStudents,
      );

      foundStudents.value = students;

      selectedStudents.clear();
      for (final s in students) {
        selectedStudents[s.uid] = true;
      }

      SFullScreenLoader.stopLoading();

      if (students.isEmpty) {
        SSnackBarHelpers.warningSnackBar(
          title: 'No Students Found',
          message: 'No students match this filter',
        );
      }
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void toggleStudent(String uid) {
    final current = selectedStudents[uid] ?? false;
    selectedStudents[uid] = !current;
    selectedStudents.refresh();
  }

  void selectAllStudents(bool select) {
    for (final s in foundStudents) {
      selectedStudents[s.uid] = select;
    }
    selectedStudents.refresh();
  }

  Future<void> assignSelectedStudents(String courseId) async {
    try {
      final selected =
      foundStudents.where((s) => selectedStudents[s.uid] == true).toList();

      if (selected.isEmpty) {
        SSnackBarHelpers.warningSnackBar(
          title: 'No Students Selected',
          message: 'Please select at least one student',
        );
        return;
      }

      SFullScreenLoader.openLoadingDialog('Assigning students...');

      await CourseRepository.instance.assignStudentsToCourse(
        courseId: courseId,
        students: selected,
      );

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: '${selected.length} students assigned',
      );

      await fetchTeacherCourses();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // ================================================================
  // FORM HELPERS
  // ================================================================
  void clearCreateForm() {
    courseCodeController.clear();
    courseNameController.clear();
    creditController.clear();
    batchController.clear();
    startRollController.clear();
    maxStudentsController.text = '66';
    selectedDept.value = '04';
  }

  void loadCourseForEdit(CourseModel course) {
    courseCodeController.text = course.courseCode;
    courseNameController.text = course.courseName;
    creditController.text = course.credit.toString();
    batchController.text = course.batch;
    startRollController.text = course.startRoll.toString();
    maxStudentsController.text = course.maxStudents.toString();
    selectedDept.value = course.department;
  }

  void loadAssignDefaults(CourseModel course) {
    assignBatchController.text = course.batch;
    assignStartRollController.text = course.startRoll.toString();
    assignMaxStudentsController.text = course.maxStudents.toString();
    assignDept.value = course.department;
    foundStudents.clear();
    selectedStudents.clear();
  }

  // ================================================================
  // HELPERS
  // ================================================================
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

  @override
  void onClose() {
    courseCodeController.dispose();
    courseNameController.dispose();
    creditController.dispose();
    batchController.dispose();
    startRollController.dispose();
    maxStudentsController.dispose();
    assignBatchController.dispose();
    assignStartRollController.dispose();
    assignMaxStudentsController.dispose();
    super.onClose();
  }
}