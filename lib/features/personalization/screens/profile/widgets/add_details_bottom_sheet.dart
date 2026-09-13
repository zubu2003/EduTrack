import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/personalization/controllers/profile_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AddDetailsBottomSheet extends StatelessWidget {
  const AddDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Obx(
          () {
        final user = controller.user.value;
        final isTeacher = user.role == 'teacher';

        // Determine which fields are EMPTY (need to be added)
        final needsPhone = user.phone.trim().isEmpty;
        final needsDepartment = user.department.trim().isEmpty;
        final needsBatch = user.batch.trim().isEmpty;
        final needsDesignation = user.designation.trim().isEmpty;
        final needsStudentId = user.studentId.trim().isEmpty;
        final needsTeacherId = user.teacherId.trim().isEmpty;

        // If everything is filled
        final allFilled = !needsPhone &&
            !needsDepartment &&
            (isTeacher ? (!needsTeacherId && !needsDesignation) : (!needsStudentId && !needsBatch));

        return Container(
          padding: EdgeInsets.only(
            left: SSize.defaultSpace,
            right: SSize.defaultSpace,
            top: SSize.defaultSpace,
            bottom: MediaQuery.of(context).viewInsets.bottom + SSize.defaultSpace,
          ),
          decoration: const BoxDecoration(
            color: SColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(SSize.cardRadius),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.addDetailsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: SColors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: SSize.spaceBtwItems),

                  // Title
                  Text(
                    'Add Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Text(
                    'Complete your profile by adding the missing information.',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                  const SizedBox(height: SSize.spaceBtwItems),

                  Divider(color: SColors.grey.withOpacity(0.2), height: 1),
                  const SizedBox(height: SSize.spaceBtwItems),

                  // ✅ Show only EMPTY fields
                  if (needsPhone) ...[
                    _buildField(
                      controller: controller.phoneController,
                      label: 'Phone',
                      hint: 'e.g. +880 1234 567890',
                      icon: Iconsax.call,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  if (needsDepartment) ...[
                    _buildField(
                      controller: controller.departmentController,
                      label: 'Department',
                      hint: 'e.g. CSE',
                      icon: Iconsax.building,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  if (isTeacher && needsTeacherId) ...[
                    _buildField(
                      controller: controller.teacherIdController,
                      label: 'Teacher ID',
                      hint: 'e.g. TCH-001',
                      icon: Iconsax.document,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  if (isTeacher && needsDesignation) ...[
                    _buildField(
                      controller: controller.designationController,
                      label: 'Designation',
                      hint: 'e.g. Professor',
                      icon: Iconsax.award,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  if (!isTeacher && needsStudentId) ...[
                    _buildField(
                      controller: controller.studentIdController,
                      label: 'Student ID',
                      hint: 'e.g. STU-2024-001',
                      icon: Iconsax.document,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  if (!isTeacher && needsBatch) ...[
                    _buildField(
                      controller: controller.batchController,
                      label: 'Batch',
                      hint: 'e.g. 2024',
                      icon: Iconsax.calendar,
                    ),
                    const SizedBox(height: SSize.spaceBtwItems),
                  ],

                  // Empty state — everything filled
                  if (allFilled) ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.tick_circle,
                            color: SColors.success,
                            size: 48,
                          ),
                          const SizedBox(height: SSize.sm),
                          Text(
                            'All details added!',
                            style: TextStyle(
                              color: SColors.textPrimary,
                              fontSize: SSize.fontSizeLg,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: SSize.xs),
                          Text(
                            'Edit them from the Edit Profile screen.',
                            style: TextStyle(
                              color: SColors.textSecondary,
                              fontSize: SSize.fontSizeSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Add Button (only if there's something to add)
                  if (!allFilled) ...[
                    const SizedBox(height: SSize.spaceBtwItems),
                    SizedBox(
                      width: double.infinity,
                      height: SSize.buttonHeight,
                      child: ElevatedButton(
                        onPressed: controller.addDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(SSize.borderRadiusMd),
                          ),
                        ),
                        child: const Text(
                          'Add Details',
                          style: TextStyle(
                            color: SColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SSize.fontSizeMd,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: SSize.spaceBtwItems),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        allFilled ? 'Close' : 'Cancel',
                        style: TextStyle(
                          color: SColors.textSecondary,
                          fontSize: SSize.fontSizeMd,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: SColors.grey.withOpacity(0.5)),
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
          ),
        ),
      ],
    );
  }
}