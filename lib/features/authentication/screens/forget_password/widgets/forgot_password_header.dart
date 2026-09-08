import 'package:flutter/material.dart';
import 'package:edutrack/common/widget/logo/app_logo.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        const SAppLogo(showText: false),

        const SizedBox(height: SSize.spaceBtwSections),

        // Title
        Text(
          'Forgotten Password',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.primary,
          ),
        ),

        const SizedBox(height: SSize.sm),

        // Subtitle
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),

        const SizedBox(height: SSize.sm),
      ],
    );
  }
}