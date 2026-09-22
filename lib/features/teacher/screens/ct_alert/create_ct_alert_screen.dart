import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/ct_alert_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CreateCtAlertScreen extends StatelessWidget {
  final CourseModel course;

  const CreateCtAlertScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final tag = 'create_ct_alert_${course.courseId}';
    final controller = Get.isRegistered<CtAlertController>(tag: tag)
        ? Get.find<CtAlertController>(tag: tag)
        : Get.put(CtAlertController(course: course), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: Get.back),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create CT Alert',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                course.courseName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
              ),
              const SizedBox(height: SSize.spaceBtwSections),
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: 'CT title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a CT title'
                    : null,
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              TextFormField(
                controller: controller.topicsController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Topics'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter the CT topics'
                    : null,
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Obx(
                () => OutlinedButton.icon(
                  onPressed: () => controller.pickDateTime(context),
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    controller.scheduledAt.value == null
                        ? 'Select date and time'
                        : _formatDate(controller.scheduledAt.value!),
                  ),
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              TextFormField(
                controller: controller.durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                validator: (value) {
                  final duration = int.tryParse(value?.trim() ?? '');
                  return duration == null || duration <= 0
                      ? 'Enter a valid duration'
                      : null;
                },
              ),
              const SizedBox(height: SSize.spaceBtwSections),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.createAlert,
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Create CT Alert'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.day}/${local.month}/${local.year} at $hour:$minute $period';
  }
}
