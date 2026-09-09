import 'package:edutrack/features/authentication/controllers/login/login_controller.dart';
import 'package:edutrack/features/authentication/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SSize.defaultSpace,
        vertical: SSize.spaceBtwSections,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            STextStrings.dontHaveAccount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: SColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.signUp),
            child: Text(
              " ${STextStrings.createOne}",
              style: TextStyle(
                color: SColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}