import 'package:edutrack/features/authentication/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widget/button/SElevatedbutton.dart';
import '../../forget_password/forgot_password_screen.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize LoginController
    final controller =LoginController.instance;

    return Column(
      children: [
        // Email / Student ID Field
        TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(
            hintText: STextStrings.emailOrStudentId,
            prefixIcon: const Icon(Iconsax.user, color: SColors.grey),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Password Field - Wrap only the suffixIcon with Obx
        Obx(
              () => TextFormField(
            controller: controller.passwordController,
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: const BorderSide(color: SColors.primary, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            ),
          ),
        ),

        const SizedBox(height: SSize.sm),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.forgotPassword,
            child: Text(
              STextStrings.forgotPassword,
              style: const TextStyle(
                color: SColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: SSize.fontSizeSm,
              ),
            ),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems / 2),

        // Sign In Button - Wrap only the button with Obx
         SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: SElevatedbutton(
              text: "Sign In",
              onPressed: controller.login,
            ),
          ),

      ],
    );
  }
}