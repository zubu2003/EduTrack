import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/features/personalization/controllers/profile_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_action_buttons.dart';
import 'widgets/profile_settings_card.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole;

  const ProfileScreen({
    super.key,
    this.userRole = 'student',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    final bottomNav = userRole == 'teacher'
        ? const TeacherBottomNav(currentIndex: 3)
        : const StudentBottomNav(currentIndex: 3);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: const SAppbar(
        showBackButton: false,
      ),
      body: Obx(
            () {
          // Loading state
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: SColors.primary),
            );
          }

          final user = controller.user.value;

          return RefreshIndicator(
            onRefresh: controller.refreshUserData,
            color: SColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.defaultSpace,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: SSize.sm),

                    // Header
                    ProfileHeader(
                      name: user.name.isNotEmpty ? user.name : 'User',
                      email: user.email.isNotEmpty ? user.email : 'No email',
                      role: user.role.isNotEmpty ? user.role : userRole,
                      profileImage: user.profileImage,
                    ),

                    const SizedBox(height: SSize.spaceBtwSections),

                    // Info Card
                    ProfileInfoCard(
                      uid: user.uid,
                      studentId: user.studentId,
                      teacherId: user.teacherId,
                      department: user.department,
                      batch: user.batch,
                      designation: user.designation,
                      email: user.email,
                      phone: user.phone,
                      role: user.role.isNotEmpty ? user.role : userRole,
                    ),

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
          );
        },
      ),
      bottomNavigationBar: bottomNav,
    );
  }
}