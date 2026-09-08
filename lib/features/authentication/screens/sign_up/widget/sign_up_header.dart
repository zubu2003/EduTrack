import 'package:edutrack/common/widget/logo/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SAppLogo(
            isCircular: false,
            showText: true
        ),

        const SizedBox(height: SSize.spaceBtwItems),


        // Subtitle
        Text(
          STextStrings.signUpSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),

      ],
    );
  }
}