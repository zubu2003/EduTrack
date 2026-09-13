import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/personalization/controllers/profile_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: SColors.primary),
            );
          }

          final user = controller.user.value;
          final isTeacher = user.role == 'teacher';

          // Determine which fields have values
          final hasPhone = user.phone.trim().isNotEmpty;
          final hasDepartment = user.department.trim().isNotEmpty;
          final hasBatch = user.batch.trim().isNotEmpty;
          final hasDesignation = user.designation.trim().isNotEmpty;
          final hasStudentId = user.studentId.trim().isNotEmpty;
          final hasTeacherId = user.teacherId.trim().isNotEmpty;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(SSize.defaultSpace),
              child: Form(
                key: controller.editProfileFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: SSize.xs),
                    Text(
                      'Update your personal information',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                    const SizedBox(height: SSize.spaceBtwSections),

                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: SColors.primary,
                                width: 3,
                              ),
                            ),
                            child: ClipOval(
                              child: Container(
                                color: SColors.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  color: SColors.primary,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: SColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: SColors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: SColors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SSize.sm),
                    Center(
                      child: Text(
                        'Tap to change photo',
                        style: TextStyle(
                          color: SColors.primary,
                          fontSize: SSize.fontSizeSm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: SSize.spaceBtwSections),

                    // ✅ Name (always shown — required)
                    _buildTextField(
                      controller: controller.nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Iconsax.user,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your name'
                          : null,
                    ),

                    // Email (read-only)
                    const SizedBox(height: SSize.spaceBtwItems),
                    _buildTextField(
                      controller: TextEditingController(text: user.email),
                      label: 'Email',
                      hint: 'Email',
                      icon: Iconsax.sms,
                      enabled: false,
                    ),

                    // ✅ Only show fields that HAVE values
                    if (hasPhone) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.phoneController,
                        label: 'Phone',
                        hint: 'Enter phone number',
                        icon: Iconsax.call,
                      ),
                    ],

                    if (hasDepartment) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.departmentController,
                        label: 'Department',
                        hint: 'e.g. CSE',
                        icon: Iconsax.building,
                      ),
                    ],

                    if (isTeacher && hasTeacherId) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.teacherIdController,
                        label: 'Teacher ID',
                        hint: 'e.g. TCH-001',
                        icon: Iconsax.document,
                      ),
                    ],

                    if (isTeacher && hasDesignation) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.designationController,
                        label: 'Designation',
                        hint: 'e.g. Professor',
                        icon: Iconsax.award,
                      ),
                    ],

                    if (!isTeacher && hasStudentId) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.studentIdController,
                        label: 'Student ID',
                        hint: 'e.g. STU-2024-001',
                        icon: Iconsax.document,
                      ),
                    ],

                    if (!isTeacher && hasBatch) ...[
                      const SizedBox(height: SSize.spaceBtwItems),
                      _buildTextField(
                        controller: controller.batchController,
                        label: 'Batch',
                        hint: 'e.g. 2024',
                        icon: Iconsax.calendar,
                      ),
                    ],

                    // Empty state if no editable fields
                    if (!hasPhone &&
                        !hasDepartment &&
                        !hasBatch &&
                        !hasDesignation &&
                        !hasStudentId &&
                        !hasTeacherId) ...[
                      const SizedBox(height: SSize.spaceBtwSections),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              color: SColors.textSecondary.withOpacity(0.5),
                              size: 48,
                            ),
                            const SizedBox(height: SSize.sm),
                            Text(
                              'No details to edit yet.\nAdd details first!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: SColors.textSecondary,
                                fontSize: SSize.fontSizeMd,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: SSize.spaceBtwSections),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: SSize.buttonHeight,
                      child: ElevatedButton(
                        onPressed: controller.updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(SSize.borderRadiusMd),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            color: SColors.white,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
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
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: enabled ? SColors.grey : SColors.grey.withOpacity(0.5),
            ),
            filled: true,
            fillColor: enabled
                ? SColors.inputFieldBackground
                : SColors.grey.withOpacity(0.05),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}