import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Field
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@university.edu',
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.sms, color: SColors.grey),
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

        const SizedBox(height: SSize.spaceBtwSections),

        // Send Reset Link Button
        SizedBox(
          width: double.infinity,
          height: SSize.buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset link sent to your email!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              elevation: 2,
            ),
            child: Text(
              'Send Reset Link',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: SColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}