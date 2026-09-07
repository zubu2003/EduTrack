import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';

import '../../../../../common/widget/logo/app_logo.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SSize.xl * 2),

        // Logo
        SAppLogo(showText: true),


        const SizedBox(height: SSize.spaceBtwSections),

        // Welcome Back Title
        Text(
          STextStrings.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.primary,
          ),
        ),

        const SizedBox(height: SSize.xs),

        // Subtitle
        Text(
          STextStrings.loginSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),

        const SizedBox(height: SSize.spaceBtwSections),
      ],
    );
  }
}