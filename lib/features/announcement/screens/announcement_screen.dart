import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/announcement/controllers/announcement_controller.dart';
import 'package:edutrack/features/announcement/models/announcement_model.dart';
import 'package:edutrack/features/announcement/widgets/announcement_card.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AnnouncementScreen extends StatelessWidget {
  final String role;

  const AnnouncementScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final tag = 'announcements_$role';

    final controller = Get.isRegistered<AnnouncementController>(tag: tag)
        ? Get.find<AnnouncementController>(tag: tag)
        : Get.put(AnnouncementController(role: role), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: Get.back),
      floatingActionButton: role == 'teacher'
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateSheet(context, controller),
              backgroundColor: SColors.primary,
              foregroundColor: SColors.white,
              icon: const Icon(Icons.add),
              label: const Text('New Announcement'),
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }

        if (controller.errorMessage.value != null) {
          return _StateMessage(
            message: controller.errorMessage.value!,
            onRetry: controller.loadAnnouncements,
          );
        }

        if (controller.announcements.isEmpty) {
          return const _StateMessage(message: 'No announcements yet.');
        }

        return RefreshIndicator(
          onRefresh: controller.loadAnnouncements,
          color: SColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            itemCount: controller.announcements.length,
            separatorBuilder: (_, index) =>
                const SizedBox(height: SSize.spaceBtwItems),
            itemBuilder: (_, index) {
              final announcement = controller.announcements[index];
              return AnnouncementCard(
                announcement: announcement,
                onEdit: role == 'teacher'
                    ? () => _showEditSheet(context, controller, announcement)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _showCreateSheet(
    BuildContext context,
    AnnouncementController controller,
  ) async {
    controller.resetForm();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SSize.cardRadius),
        ),
      ),
      builder: (context) {
        return _CreateAnnouncementSheet(controller: controller);
      },
    );
  }

  Future<void> _showEditSheet(
    BuildContext context,
    AnnouncementController controller,
    AnnouncementModel announcement,
  ) async {
    controller.prepareEdit(announcement);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SSize.cardRadius),
        ),
      ),
      builder: (_) => _CreateAnnouncementSheet(controller: controller),
    );
    controller.resetForm();
  }
}

class _CreateAnnouncementSheet extends StatelessWidget {
  final AnnouncementController controller;

  const _CreateAnnouncementSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SSize.defaultSpace,
        right: SSize.defaultSpace,
        top: SSize.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + SSize.defaultSpace,
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SColors.lightGrey,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusPill),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              Text(
                controller.editingAnnouncement.value == null
                    ? 'New Announcement'
                    : 'Edit Announcement',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              /// Course selector
              Obx(() {
                final selectedCourse = controller.selectedCourse.value;

                return DropdownButtonFormField<String>(
                  initialValue: selectedCourse?.courseId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Course'),

                  items: controller.courses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course.courseId,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          '${course.courseCode} • '
                          '${course.courseName} • '
                          'Section ${course.section}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value == null) {
                      controller.selectedCourse.value = null;
                      return;
                    }

                    final course = controller.courses.firstWhere(
                      (course) => course.courseId == value,
                    );

                    controller.selectedCourse.value = course;
                  },

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select the announcement course';
                    }

                    return null;
                  },
                );
              }),

              const SizedBox(height: SSize.spaceBtwItems),

              /// Title
              TextFormField(
                controller: controller.titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an announcement title';
                  }

                  return null;
                },
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              /// Message
              TextFormField(
                controller: controller.contentController,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an announcement message';
                  }

                  return null;
                },
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              /// Publish
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.editingAnnouncement.value == null
                        ? controller.createAnnouncement
                        : controller.updateAnnouncement,
                    icon: controller.isSaving.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: SColors.white,
                            ),
                          )
                        : const Icon(Icons.campaign_outlined),
                    label: Text(
                      controller.isSaving.value
                          ? 'Saving...'
                          : controller.editingAnnouncement.value == null
                          ? 'Publish Announcement'
                          : 'Save Changes',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _StateMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: SColors.textSecondary),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: SSize.spaceBtwItems),
              IconButton(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: SColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
