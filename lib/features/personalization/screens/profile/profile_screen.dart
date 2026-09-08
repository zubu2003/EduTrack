import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_buttons.dart';
import 'widgets/profile_settings_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: SSize.sm),

              // Header with Avatar & Name
              const ProfileHeader(),

              const SizedBox(height: SSize.spaceBtwSections),

              // Info Card
              const ProfileInfoCard(),

              const SizedBox(height: SSize.spaceBtwItems),

              // Action Buttons
              const ProfileActionButtons(),

              const SizedBox(height: SSize.spaceBtwItems),

              // Settings Card
              const ProfileSettingsCard(),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const StudentBottomNav(
        currentIndex: 3,
      ),
    );
  }
}