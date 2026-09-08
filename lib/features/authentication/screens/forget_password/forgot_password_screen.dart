import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/forgot_password_header.dart';
import 'widgets/forgot_password_form.dart';
import 'widgets/forgot_password_footer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      backgroundColor: SColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: SSize.spaceBtwSections),

              // 1. Header Section
              const ForgotPasswordHeader(),

              const SizedBox(height: SSize.spaceBtwSections),

              // 2. Form Section (White Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SSize.defaultSpace),
                decoration: BoxDecoration(
                  color: SColors.white,
                  borderRadius: BorderRadius.circular(SSize.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: SColors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const ForgotPasswordForm(),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // 3. Footer Section
              const ForgotPasswordFooter(),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}