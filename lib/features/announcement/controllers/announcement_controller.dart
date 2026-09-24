import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/data/repositories/announcement_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/announcement/models/announcement_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class AnnouncementController extends GetxController {
  final String role;

  AnnouncementController({required this.role});

  final announcements = <AnnouncementModel>[].obs;
  final courses = <CourseModel>[].obs;
  final selectedCourse = Rxn<CourseModel>();
  final isLoading = true.obs;
  final isSaving = false.obs;
  final errorMessage = RxnString();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final editingAnnouncement = Rxn<AnnouncementModel>();

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) {
        announcements.clear();
        courses.clear();
        return;
      }

      final loadedCourses = role == 'teacher'
          ? await CourseRepository.instance.getTeacherCourses(user.uid)
          : await CourseRepository.instance.getStudentCourses(user.uid);
      courses.assignAll(loadedCourses);
      announcements.assignAll(
        await AnnouncementRepository.instance.getAnnouncementsForCourses(
          loadedCourses,
        ),
      );
    } catch (_) {
      announcements.clear();
      errorMessage.value = 'Unable to load announcements. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAnnouncement() async {
    if (!formKey.currentState!.validate()) return;
    final course = selectedCourse.value;
    if (course == null) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Course required',
        message: 'Select the course for this announcement.',
      );
      return;
    }

    try {
      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog('Creating announcement...');
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null || user.role != 'teacher') {
        throw 'You are not authorized to create announcements.';
      }
      if (!courses.any((item) => item.courseId == course.courseId)) {
        throw 'You are not authorized to use this course.';
      }

      final now = DateTime.now();
      await AnnouncementRepository.instance.createAnnouncement(
        AnnouncementModel(
          announcementId: '',
          courseId: course.courseId,
          courseCode: course.courseCode,
          courseName: course.courseName,
          courseSection: course.section,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          authorId: user.uid,
          authorName: user.name,
          createdAt: now,
          updatedAt: now,
        ),
      );
      SFullScreenLoader.stopLoading();
      Get.back();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Announcement created successfully.',
      );
      await loadAnnouncements();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e is String ? e : 'Could not create announcement.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateAnnouncement() async {
    if (!formKey.currentState!.validate()) return;
    final current = editingAnnouncement.value;
    final course = selectedCourse.value;
    if (current == null || course == null) return;

    try {
      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog('Updating announcement...');
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null || user.role != 'teacher') {
        throw 'You are not authorized to update announcements.';
      }
      if (!courses.any((item) => item.courseId == course.courseId)) {
        throw 'You are not authorized to use this course.';
      }

      await AnnouncementRepository.instance.updateAnnouncement(
        AnnouncementModel(
          announcementId: current.announcementId,
          courseId: course.courseId,
          courseCode: course.courseCode,
          courseName: course.courseName,
          courseSection: course.section,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          authorId: current.authorId,
          authorName: current.authorName,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
      SFullScreenLoader.stopLoading();
      Get.back();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Announcement updated successfully.',
      );
      await loadAnnouncements();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e is String ? e : 'Could not update announcement.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  void resetForm() {
    titleController.clear();
    contentController.clear();
    selectedCourse.value = null;
    editingAnnouncement.value = null;
  }

  void prepareEdit(AnnouncementModel announcement) {
    editingAnnouncement.value = announcement;
    titleController.text = announcement.title;
    contentController.text = announcement.content;
    selectedCourse.value = courses.firstWhereOrNull(
      (course) => course.courseId == announcement.courseId,
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
