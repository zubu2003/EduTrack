import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_repository.dart';
import 'package:edutrack/data/services/ai/ct_alert_reminder_service.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class CtAlertController extends GetxController {
  final CourseModel course;

  CtAlertController({required this.course});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final topicsController = TextEditingController();
  final durationController = TextEditingController(text: '60');
  final scheduledAt = Rxn<DateTime>();
  final isSaving = false.obs;

  Future<void> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: scheduledAt.value ?? DateTime.now(),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: scheduledAt.value == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(scheduledAt.value!),
    );
    if (time == null) return;

    scheduledAt.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> createAlert() async {
    if (!formKey.currentState!.validate() || scheduledAt.value == null) {
      if (scheduledAt.value == null) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Missing date',
          message: 'Select the CT date and time first.',
        );
      }
      return;
    }

    try {
      isSaving.value = true;
      SFullScreenLoader.openLoadingDialog('Saving CT alert...');
      final now = DateTime.now();
      final alert = CtAlertModel(
        alertId: '',
        courseId: course.courseId,
        courseName: course.courseName,
        ctTitle: titleController.text.trim(),
        topics: topicsController.text.trim(),
        scheduledAt: scheduledAt.value!,
        durationMinutes: int.parse(durationController.text.trim()),
        createdAt: now,
        updatedAt: now,
      );
      final alertId = await CtAlertRepository.instance.createAlert(alert);
      final students = await _loadEnrolledStudentsSafely();
      final savedAlert = CtAlertModel(
        alertId: alertId,
        courseId: alert.courseId,
        courseName: alert.courseName,
        ctTitle: alert.ctTitle,
        topics: alert.topics,
        scheduledAt: alert.scheduledAt,
        durationMinutes: alert.durationMinutes,
        createdAt: alert.createdAt,
        updatedAt: alert.updatedAt,
      );
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'CT alert created successfully.',
      );
      Get.back();
      unawaited(
        CtAlertReminderService.instance.generateForAlert(
          alert: savedAlert,
          students: students,
        ),
      );
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<List<EnrollmentModel>> _loadEnrolledStudentsSafely() async {
    try {
      return await AttendanceRepository.instance.getEnrolledStudents(
        course.courseId,
      );
    } catch (_) {
      return [];
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    topicsController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
