import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remember your password? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate back to Login
            Navigator.pop(context);
          },
          child: Text(
            'Sign In',
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