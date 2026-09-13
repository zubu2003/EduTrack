import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/courses/teacher_courses_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/helper/student_id_parser.dart';
import 'package:iconsax/iconsax.dart';

class AssignStudentsScreen extends StatelessWidget {
  final CourseModel course;

  const AssignStudentsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherCoursesController());

    // Pre-fill with course data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAssignDefaults(course);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SSize.md),
                decoration: BoxDecoration(
                  color: SColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(SSize.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseCode,
                      style: TextStyle(
                        color: SColors.primary,
                        fontSize: SSize.fontSizeLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      course.courseName,
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Title
              Text(
                'Manage Students',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                'Find students by batch, department, and roll range.',
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwSections),

              _buildField(
                controller: controller.assignBatchController,
                label: 'Batch',
                hint: 'e.g. 22',
                icon: Iconsax.calendar,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Department Dropdown
              Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    DropdownButtonFormField<String>(
                      value: controller.assignDept.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.building,
                            color: SColors.grey),
                        filled: true,
                        fillColor: SColors.inputFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(SSize.inputFieldRadius),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      items: SDepartments.deptCodes.map((code) {
                        return DropdownMenuItem(
                          value: code,
                          child: Text(SDepartments.getDeptLabel(code)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) controller.assignDept.value = val;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildField(
                controller: controller.assignStartRollController,
                label: 'Start Roll',
                hint: 'e.g. 1 or 67',
                icon: Iconsax.hashtag,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildField(
                controller: controller.assignMaxStudentsController,
                label: 'Max Students',
                hint: 'e.g. 40, 66, 100',
                icon: Iconsax.people,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Preview Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: controller.previewStudents,
                  icon: const Icon(Iconsax.search_normal,
                      color: SColors.primary),
                  label: const Text(
                    'Preview Students',
                    style: TextStyle(
                      color: SColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // Found Students List
              Obx(
                    () {
                  if (controller.foundStudents.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Found: ${controller.foundStudents.length} students',
                            style: TextStyle(
                              color: SColors.textPrimary,
                              fontSize: SSize.fontSizeMd,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final allSelected = controller.selectedStudents
                                  .values
                                  .every((v) => v == true);
                              controller.selectAllStudents(!allSelected);
                            },
                            child: Text(
                              controller.selectedStudents.values
                                  .every((v) => v == true)
                                  ? 'Deselect All'
                                  : 'Select All',
                              style: const TextStyle(color: SColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SSize.sm),

                      // ✅ Student list (NO inner Obx)
                      ...controller.foundStudents.map((student) {
                        final parsed =
                        StudentIdParser.parse(student.studentId);
                        final roll = parsed['roll'] ?? '';
                        final section = StudentIdParser.getSection(
                          int.tryParse(roll) ?? 0,
                        );
                        final isSelected =
                            controller.selectedStudents[student.uid] ?? false;

                        return Container(
                          margin: const EdgeInsets.only(bottom: SSize.xs),
                          decoration: BoxDecoration(
                            color: SColors.white,
                            borderRadius:
                            BorderRadius.circular(SSize.borderRadiusMd),
                            border: Border.all(
                              color: isSelected
                                  ? SColors.primary.withOpacity(0.3)
                                  : SColors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: isSelected,
                            onChanged: (_) =>
                                controller.toggleStudent(student.uid),
                            activeColor: SColors.primary,
                            title: Text(
                              student.name,
                              style: TextStyle(
                                color: SColors.textPrimary,
                                fontSize: SSize.fontSizeMd,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Roll $roll • Sec $section • ${student.studentId}',
                              style: TextStyle(
                                color: SColors.textSecondary,
                                fontSize: SSize.fontSizeSm,
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Space for sticky button
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ✅ STICKY BOTTOM SAVE BUTTON
      bottomNavigationBar: Obx(
            () {
          if (controller.foundStudents.isEmpty) {
            return const SizedBox.shrink();
          }

          final selectedCount = controller.selectedStudents.values
              .where((v) => v == true)
              .length;

          return Container(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            decoration: BoxDecoration(
              color: SColors.white,
              boxShadow: [
                BoxShadow(
                  color: SColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: SSize.buttonHeight,
                child: ElevatedButton(
                  onPressed: selectedCount == 0
                      ? null
                      : () => controller
                      .assignSelectedStudents(course.courseId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    disabledBackgroundColor:
                    SColors.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    selectedCount == 0
                        ? 'Select Students'
                        : 'Save Changes ($selectedCount)',
                    style: const TextStyle(
                      color: SColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SSize.fontSizeLg,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
}