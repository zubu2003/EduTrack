import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.xs),

              Text(
                'Update your personal information',
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwSections),

              // Avatar
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A2E),
                                Color(0xFF2D2D44),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: SColors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: SColors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: SColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: SColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: SColors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SSize.sm),
                    Text(
                      'Tap to change photo',
                      style: TextStyle(
                        color: SColors.primary,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // Form Fields
              _buildTextField(
                label: 'Full Name',
                hint: 'Zubayer Ahmed',
                icon: Iconsax.user,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildTextField(
                label: 'Email',
                hint: 'zubayer@university.edu',
                icon: Iconsax.sms,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildTextField(
                label: 'Phone',
                hint: '+880 1234 567890',
                icon: Iconsax.call,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildTextField(
                label: 'Department',
                hint: 'CSE',
                icon: Iconsax.building,
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              _buildTextField(
                label: 'Batch/Year',
                hint: '2024',
                icon: Iconsax.calendar,
              ),
              const SizedBox(height: SSize.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: SSize.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      'Coming Soon',
                      'Save functionality will be added later',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: SColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SSize.xs),
        TextFormField(
          initialValue: hint,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: SColors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide(
                color: SColors.grey.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide(
                color: SColors.grey.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}