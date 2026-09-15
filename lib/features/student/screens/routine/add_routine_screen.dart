import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/features/student/controllers/routine/routine_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AddRoutineScreen extends StatelessWidget {
  final String userRole;
  final RoutineModel? routine;

  const AddRoutineScreen({
    super.key,
    required this.userRole,
    this.routine,
  });

  bool get isEditing => routine != null;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RoutineController(userRole: userRole),
      tag: 'routine_$userRole',
    );

    // Load existing data if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEditing) {
        controller.loadRoutineForEdit(routine!);
      } else {
        controller.clearForm();
      }
    });

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSize.defaultSpace),
          child: Form(
            key: controller.addRoutineFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Routine' : 'Add Routine',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  isEditing
                      ? 'Update your routine'
                      : 'Add a new entry to your routine',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
                const SizedBox(height: SSize.spaceBtwSections),

                // Day Dropdown
                Obx(() => _buildDaySelector(
                  controller.selectedDayForm.value,
                  controller.selectFormDay,
                )),
                const SizedBox(height: SSize.spaceBtwItems),

                // Course Dropdown
                Obx(() => _buildCourseDropdown(
                  context,
                  controller.myCourses,
                  controller.selectedCourseCode.value,
                  controller.selectCourse,
                )),
                const SizedBox(height: SSize.spaceBtwItems),

                // Course Name (auto or custom)
                Obx(() {
                  final isOther =
                      controller.selectedCourseCode.value == 'Others';
                  if (isOther) {
                    return _buildTextField(
                      controller: controller.customCourseNameController,
                      label: 'Routine Name',
                      hint: 'e.g. Break, Lunch, Study',
                      icon: Iconsax.edit,
                      validator: (v) =>
                      v!.isEmpty ? 'Please enter a name' : null,
                    );
                  } else {
                    return _buildReadonlyField(
                      label: 'Course Name',
                      value: controller.selectedCourseName.value,
                      icon: Iconsax.book,
                    );
                  }
                }),
                const SizedBox(height: SSize.spaceBtwItems),

                // Start Time
                Obx(() => _buildTimeField(
                  context,
                  label: 'Start Time',
                  value: controller.startTime.value,
                  onPick: (t) => controller.startTime.value = t,
                )),
                const SizedBox(height: SSize.spaceBtwItems),

                // End Time
                Obx(() => _buildTimeField(
                  context,
                  label: 'End Time',
                  value: controller.endTime.value,
                  onPick: (t) => controller.endTime.value = t,
                )),
                const SizedBox(height: SSize.spaceBtwItems),

                // Room
                _buildTextField(
                  controller: controller.roomController,
                  label: 'Room',
                  hint: 'e.g. Room 301',
                  icon: Iconsax.location,
                ),
                const SizedBox(height: SSize.spaceBtwSections),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: SSize.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        controller.updateRoutine(routine!);
                      } else {
                        controller.createRoutine();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(SSize.borderRadiusMd),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Add Routine',
                      style: const TextStyle(
                        color: SColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeLg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(String selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: SSize.sm),
          decoration: BoxDecoration(
            color: SColors.inputFieldBackground,
            borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
          ),
          child: DropdownButtonFormField<String>(
            value: selected,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.calendar, color: SColors.grey),
              border: InputBorder.none,
            ),
            items: RoutineController.days
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) {
              if (v != null) onSelect(v);
            },
            icon: const Icon(Icons.keyboard_arrow_down, color: SColors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDropdown(
      BuildContext context,
      List courses,
      String selected,
      Function(String, String, String) onSelect,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course / Activity',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: SSize.sm),
          decoration: BoxDecoration(
            color: SColors.inputFieldBackground,
            borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
          ),
          child: DropdownButtonFormField<String>(
            value: selected,
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.book, color: SColors.grey),
              border: InputBorder.none,
            ),
            items: [
              ...courses.map((c) {
                return DropdownMenuItem<String>(
                  value: c.courseCode as String,
                  child: Text(
                    '${c.courseCode} - ${c.courseName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
              const DropdownMenuItem<String>(
                value: 'Others',
                child: Text('Others'),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              if (v == 'Others') {
                onSelect('Others', '', '');
              } else {
                final matched =
                courses.firstWhere((c) => c.courseCode == v);
                onSelect(
                  matched.courseCode as String,
                  matched.courseId as String,
                  matched.courseName as String,
                );
              }
            },
            icon: const Icon(Icons.keyboard_arrow_down, color: SColors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadonlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: SColors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
          ),
          child: Row(
            children: [
              Icon(icon, color: SColors.grey, size: SSize.iconMd),
              const SizedBox(width: SSize.md),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(
      BuildContext context, {
        required String label,
        required String value,
        required Function(String) onPick,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        GestureDetector(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
            );
            if (time != null) {
              final hour = time.hour == 0
                  ? 12
                  : (time.hour > 12 ? time.hour - 12 : time.hour);
              final min = time.minute.toString().padLeft(2, '0');
              final period = time.hour >= 12 ? 'PM' : 'AM';
              onPick('$hour:$min $period');
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: SColors.inputFieldBackground,
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
            ),
            child: Row(
              children: [
                Icon(Iconsax.clock,
                    color: SColors.grey, size: SSize.iconMd),
                const SizedBox(width: SSize.md),
                Text(
                  value,
                  style: TextStyle(
                    color: SColors.textPrimary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down,
                    color: SColors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}