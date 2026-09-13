import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/helper/student_id_parser.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class TeacherCoursesController extends GetxController {
  static TeacherCoursesController get instance => Get.find();

  // Observable list
  RxList<CourseModel> courses = <CourseModel>[].obs;
  RxBool isLoading = true.obs;

  // Create/Edit Course form
  final createCourseFormKey = GlobalKey<FormState>();
  final courseCodeController = TextEditingController();
  final courseNameController = TextEditingController();
  final creditController = TextEditingController();
  final batchController = TextEditingController();
  final startRollController = TextEditingController();
  final maxStudentsController = TextEditingController(text: '66');
  RxString selectedDept = '04'.obs;

  // Assign Students
  final assignFormKey = GlobalKey<FormState>();
  final assignBatchController = TextEditingController();
  final assignStartRollController = TextEditingController();
  final assignMaxStudentsController = TextEditingController(text: '66');
  RxString assignDept = '04'.obs;

  RxList<UserModel> foundStudents = <UserModel>[].obs;
  RxMap<String, bool> selectedStudents = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeacherCourses();
  }

  /// Fetch teacher's courses
  Future<void> fetchTeacherCourses() async {
    try {
      isLoading.value = true;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      final list = await CourseRepository.instance.getTeacherCourses(user.uid);
      courses.value = list;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new course
  Future<void> createCourse() async {
    try {
      if (!createCourseFormKey.currentState!.validate()) return;

      final startRoll = int.tryParse(startRollController.text.trim()) ?? 1;
      final maxStudents = int.tryParse(maxStudentsController.text.trim()) ?? 66;

      // Roll range check
      if (startRoll < 1 || startRoll > 132) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Roll',
          message: 'Start roll must be between 1 and 132',
        );
        return;
      }

      // Max students check (min only)
      if (maxStudents < 1) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Count',
          message: 'Max students must be at least 1',
        );
        return;
      }

      // WARNING: Exceeds max roll range
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

  /// Update existing course
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

  /// Delete course with warning
  Future<void> deleteCourse(CourseModel course) async {
    Get.dialog(
      AlertDialog(
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
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==================== ASSIGN STUDENTS ====================

  /// Preview students matching filter
  Future<void> previewStudents() async {
    try {
      final batch = assignBatchController.text.trim();
      final startRoll = int.tryParse(assignStartRollController.text.trim()) ?? 1;
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

      // Default all selected
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

  /// Toggle student selection
  void toggleStudent(String uid) {
    selectedStudents[uid] = !(selectedStudents[uid] ?? false);
    selectedStudents.refresh();
  }

  /// Select all / none
  void selectAllStudents(bool select) {
    for (final s in foundStudents) {
      selectedStudents[s.uid] = select;
    }
    selectedStudents.refresh();
  }

  /// Assign selected students
  Future<void> assignSelectedStudents(String courseId) async {
    try {
      final selected = foundStudents
          .where((s) => selectedStudents[s.uid] == true)
          .toList();

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

  /// Load students already in course
  Future<List<EnrollmentModel>> loadEnrolledStudents(String courseId) async {
    return await CourseRepository.instance.getEnrolledStudents(courseId);
  }

  void clearCreateForm() {
    courseCodeController.clear();
    courseNameController.clear();
    creditController.clear();
    batchController.clear();
    startRollController.text='1';
    maxStudentsController.text = '132';
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