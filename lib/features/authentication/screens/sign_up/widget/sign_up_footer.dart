import 'package:edutrack/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:get/get.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          STextStrings.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.offAll(LoginScreen());
          },
          child: Text(
            " ${STextStrings.signIn}",
            style: TextStyle(
              color: SColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}