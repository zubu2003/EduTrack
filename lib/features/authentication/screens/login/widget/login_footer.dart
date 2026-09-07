import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              // Navigation will be added later
            },
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