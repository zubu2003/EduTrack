import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/courses/teacher_courses_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CreateCourseScreen extends StatelessWidget {
  final CourseModel? course; // null = create, non-null = edit

  const CreateCourseScreen({super.key, this.course});

  @override
  @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherCoursesController());

    // Load existing data if editing; else clear
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (course != null) {
        controller.loadCourseForEdit(course!);
      } else {
        controller.clearCreateForm();
      }
    });

    final isEdit = course != null;

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
            key: controller.createCourseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Course' : 'Create New Course',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SColors.textPrimary,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  isEdit
                      ? 'Update course information'
                      : 'Fill in the details to create a new course',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
                const SizedBox(height: SSize.spaceBtwSections),

                _buildField(
                  controller: controller.courseCodeController,
                  label: 'Course Code',
                  hint: 'e.g. CSE 356',
                  icon: Iconsax.code,
                  validator: (v) =>
                  v!.isEmpty ? 'Please enter course code' : null,
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                _buildField(
                  controller: controller.courseNameController,
                  label: 'Course Name',
                  hint: 'e.g. Software Engineering',
                  icon: Iconsax.book,
                  validator: (v) =>
                  v!.isEmpty ? 'Please enter course name' : null,
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                _buildField(
                  controller: controller.creditController,
                  label: 'Credit',
                  hint: 'e.g. 3',
                  icon: Iconsax.award,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Please enter credit' : null,
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                _buildField(
                  controller: controller.batchController,
                  label: 'Batch',
                  hint: 'e.g. 22, 23, 24',
                  icon: Iconsax.calendar,
                  validator: (v) => v!.isEmpty ? 'Please enter batch' : null,
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
                        value: controller.selectedDept.value,
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(SSize.inputFieldRadius),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(SSize.inputFieldRadius),
                            borderSide: const BorderSide(
                                color: SColors.primary, width: 1),
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
                          if (val != null) {
                            controller.selectedDept.value = val;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                _buildField(
                  controller: controller.startRollController,
                  label: 'Start Roll',
                  hint: 'e.g. 1 (for Sec A) or 67 (for Sec B)',
                  icon: Iconsax.hashtag,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Please enter start roll';
                    final n = int.tryParse(v);
                    if (n == null || n < 1 || n > 132) {
                      return 'Roll must be 1-132';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: SSize.spaceBtwItems),

                _buildField(
                  controller: controller.maxStudentsController,
                  label: 'Max Students',
                  hint: 'e.g. 40, 66, 100',
                  icon: Iconsax.people,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Please enter max students';
                    final n = int.tryParse(v);
                    if (n == null || n < 1) {
                      return 'Must be at least 1';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: SSize.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
      // ✅ Sticky bottom Save button — always visible
      bottomNavigationBar: Container(
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
              onPressed: () {
                if (isEdit) {
                  controller.updateCourse(course!);
                } else {
                  controller.createCourse();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
              ),
              child: Text(
                isEdit ? 'Save Changes' : 'Create Course',
                style: const TextStyle(
                  color: SColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SSize.fontSizeLg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
}