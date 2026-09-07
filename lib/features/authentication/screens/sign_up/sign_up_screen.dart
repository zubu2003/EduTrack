import 'package:edutrack/features/authentication/screens/sign_up/widget/sign_up_footer.dart';
import 'package:edutrack/features/authentication/screens/sign_up/widget/sign_up_form_section.dart';
import 'package:edutrack/features/authentication/screens/sign_up/widget/sign_up_header.dart';
import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      backgroundColor: SColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              // 1. Header Section
              const SignUpHeader(),

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
                child: const SignUpFormSection(),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // 3. Footer Section
              const SignUpFooter(),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}