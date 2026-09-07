import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SSize.xl * 2),

        // EA Logo Design
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: SColors.primary,
            borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
          ),
          child: const Center(
            child: Text(
              "EA",
              style: TextStyle(
                color: SColors.white,
                fontSize: SSize.fontSizeXxl,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

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