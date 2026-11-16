import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/authentication/controllers/forgot_password/forgot_password_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'name@university.edu',
              hintStyle: TextStyle(
                color: SColors.textSecondary.withOpacity(0.7),
              ),
              prefixIcon: const Icon(Iconsax.sms, color: SColors.grey),
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
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(email)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            onFieldSubmitted: (_) => controller.sendPasswordResetEmail(),
          ),
          const SizedBox(height: SSize.spaceBtwSections),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: SSize.buttonHeight,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  controller.isSubmitting.value
                      ? 'Sending...'
                      : 'Send Reset Link',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: SColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
