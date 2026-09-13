import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/authentication/controllers/sign_up/sign_up_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class SignUpFormSection extends StatelessWidget {
  const SignUpFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Form(
      key: controller.signUpFormKey,
      child: Column(
        children: [
          // Role Selector
          Obx(
                () => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: SColors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Row(
                children: [
                  // Student
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectRole('student'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: SSize.sm),
                        decoration: BoxDecoration(
                          color: controller.selectedRole.value == 'student'
                              ? SColors.white
                              : SColors.transparent,
                          borderRadius:
                          BorderRadius.circular(SSize.borderRadiusMd),
                        ),
                        child: Text(
                          'Student',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: controller.selectedRole.value == 'student'
                                ? SColors.primary
                                : SColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Teacher
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectRole('teacher'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: SSize.sm),
                        decoration: BoxDecoration(
                          color: controller.selectedRole.value == 'teacher'
                              ? SColors.white
                              : SColors.transparent,
                          borderRadius:
                          BorderRadius.circular(SSize.borderRadiusMd),
                        ),
                        child: Text(
                          'Teacher',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: controller.selectedRole.value == 'teacher'
                                ? SColors.primary
                                : SColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Full Name
          TextFormField(
            controller: controller.name,
            decoration: InputDecoration(
              hintText: STextStrings.fullName,
              prefixIcon: const Icon(Iconsax.user, color: SColors.grey),
              filled: true,
              fillColor: SColors.inputFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
            value!.isEmpty ? 'Please enter your full name' : null,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Student/Teacher ID
          TextFormField(
            controller: controller.idNumber,
            decoration: InputDecoration(
              hintText: STextStrings.studentTeacherId,
              prefixIcon: const Icon(Iconsax.document, color: SColors.grey),
              filled: true,
              fillColor: SColors.inputFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Email
          TextFormField(
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: STextStrings.universityEmail,
              prefixIcon: const Icon(Iconsax.sms, color: SColors.grey),
              filled: true,
              fillColor: SColors.inputFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter email';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Password
          Obx(
                () => TextFormField(
              controller: controller.password,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                hintText: STextStrings.password,
                prefixIcon: const Icon(Iconsax.lock, color: SColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: SColors.grey,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: SColors.inputFieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) =>
              value!.length < 6 ? 'Password must be 6+ characters' : null,
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Confirm Password
          Obx(
                () => TextFormField(
              controller: controller.confirmPassword,
              obscureText: controller.isConfirmPasswordHidden.value,
              decoration: InputDecoration(
                hintText: STextStrings.confirmPassword,
                prefixIcon: const Icon(Iconsax.lock, color: SColors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                    color: SColors.grey,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                filled: true,
                fillColor: SColors.inputFieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) =>
              value!.isEmpty ? 'Please confirm password' : null,
            ),
          ),

          const SizedBox(height: SSize.spaceBtwSections),

          // Create Account Button
          SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: ElevatedButton(
              onPressed: controller.registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: SColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  color: SColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}