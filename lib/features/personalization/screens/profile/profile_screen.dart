import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_buttons.dart';
import 'widgets/profile_settings_card.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole; // 'student' or 'teacher'

  const ProfileScreen({
    super.key,
    this.userRole = 'student',
  });

  @override
  Widget build(BuildContext context) {
    // Determine bottom nav based on role
    final bottomNav = userRole == 'teacher'
        ? const TeacherBottomNav(currentIndex: 3)
        : const StudentBottomNav(currentIndex: 3);

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
              const ProfileHeader(),
              const SizedBox(height: SSize.spaceBtwSections),
              const ProfileInfoCard(),
              const SizedBox(height: SSize.spaceBtwItems),
              const ProfileActionButtons(),
              const SizedBox(height: SSize.spaceBtwItems),
              const ProfileSettingsCard(),
              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}