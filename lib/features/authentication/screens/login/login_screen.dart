import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widget/login_footer.dart';
import 'widget/login_form_section.dart';
import 'widget/login_header.dart';
import 'widget/login_role_selector.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.md),
          child: Column(
            children: [
              const SizedBox(height: SSize.defaultSpace * 2),

              // 1. Header Section (Logo + Welcome Text)
              const LoginHeader(),

              // Central White Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(SSize.md),
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
                child: Column(
                  children: const [
                    // 2. Role Selector
                    LoginRoleSelector(),
                    SizedBox(height: SSize.spaceBtwSections),

                    // 3. Form Section
                    LoginFormSection(),
                    SizedBox(height: SSize.spaceBtwItems),

                    // 4. Footer Section
                    LoginFooter(),
                  ],
                ),
              ),
              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}