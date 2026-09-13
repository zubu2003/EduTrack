import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/authentication/controllers/login/login_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: controller.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: STextStrings.emailOrStudentId,
              prefixIcon: const Icon(Iconsax.user, color: SColors.grey),
              filled: true,
              fillColor: SColors.inputFieldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
            value!.isEmpty ? 'Please enter email' : null,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Password Field
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
              value!.isEmpty ? 'Please enter password' : null,
            ),
          ),
          const SizedBox(height: SSize.sm),

          // Remember Me + Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember Me
              Row(
                children: [
                  Obx(
                        () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (val) =>
                      controller.rememberMe.value = val ?? false,
                      activeColor: SColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: TextStyle(
                      color: SColors.textSecondary,
                      fontSize: SSize.fontSizeSm,
                    ),
                  ),
                ],
              ),
              // Forgot Password
              TextButton(
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
            ],
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: ElevatedButton(
              onPressed: controller.loginWithEmailAndPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: SColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: SColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // OR Divider
          Row(
            children: [
              Expanded(child: Divider(color: SColors.grey.withOpacity(0.3))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SSize.sm),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeSm,
                  ),
                ),
              ),
              Expanded(child: Divider(color: SColors.grey.withOpacity(0.3))),
            ],
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Google Sign In Button
          SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: OutlinedButton(
              onPressed: controller.googleSignIn,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: SColors.grey.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/google_logo.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.g_mobiledata, size: 28),
                  ),
                  const SizedBox(width: SSize.sm),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}