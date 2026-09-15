import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/personalization/controllers/profile_image_controller.dart';
import 'package:edutrack/features/personalization/screens/profile/widgets/profile_header.dart';
import 'package:edutrack/features/personalization/screens/profile/widgets/profile_info_card.dart';
import 'package:edutrack/features/personalization/screens/profile/widgets/profile_action_buttons.dart';
import 'package:edutrack/features/personalization/screens/profile/widgets/profile_settings_card.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole;

  const ProfileScreen({
    super.key,
    this.userRole = 'student',
  });

  @override
  Widget build(BuildContext context) {
    // Initialize profile image controller
    Get.put(ProfileImageController());

    final bottomNav = userRole == 'teacher'
        ? const TeacherBottomNav(currentIndex: 3)
        : const StudentBottomNav(currentIndex: 3);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(showBackButton: false),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            children: [
              SizedBox(height: SSize.sm),
              ProfileHeader(),
              SizedBox(height: SSize.spaceBtwSections),
              ProfileInfoCard(),
              SizedBox(height: SSize.spaceBtwItems),
              ProfileActionButtons(),
              SizedBox(height: SSize.spaceBtwItems),
              ProfileSettingsCard(),
              SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}