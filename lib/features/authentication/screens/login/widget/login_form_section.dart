import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widget/button/SElevatedbutton.dart';
import '../../../../student/screens/dashboard/student_dashboard_screen.dart';
import '../../forget_password/forgot_password_screen.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email / Student ID Field
        TextFormField(
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

        // Password Field
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: STextStrings.password,
            prefixIcon: const Icon(Iconsax.lock, color: SColors.grey),
            suffixIcon: const Icon(
              Iconsax.eye_slash,
              color: SColors.grey,
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

        const SizedBox(height: SSize.sm),

        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Get.to(ForgotPasswordScreen()),
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

        // Sign In Button
        SizedBox(
          width: double.infinity,
          height: SSize.buttonHeight,
          child: SElevatedbutton(
            text: "Sign In",
            onPressed:()=> Get.to(const StudentDashboardScreen()) ,
          ),
        ),
      ],
    );
  }
}