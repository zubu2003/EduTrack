import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/personalization/controllers/profile_image_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileImageController>();

    return Column(
      children: [
        // Avatar with picker
        Obx(() {
          final user = controller.user.value;
          final hasImage = user.profileImage.isNotEmpty;

          return GestureDetector(
            onTap: controller.isUploading.value
                ? null
                : controller.showImageSourceSheet,
            child: Stack(
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: SColors.primary,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SColors.primary.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: hasImage
                        ? CachedNetworkImage(
                      imageUrl: user.profileImage,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      placeholder: (context, url) => Container(
                        color: SColors.primary.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: SColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _defaultAvatar(),
                    )
                        : _defaultAvatar(),
                  ),
                ),

                // Upload overlay
                if (controller.isUploading.value)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: SColors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: SColors.white,
                        ),
                      ),
                    ),
                  ),

                // Camera badge
                if (!controller.isUploading.value)
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
                        Iconsax.camera,
                        color: SColors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),

        const SizedBox(height: SSize.spaceBtwItems),

        // Name
        Obx(
              () => Text(
            controller.user.value.name.isNotEmpty
                ? controller.user.value.name
                : 'User',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: SSize.xs),

        // Email
        Obx(
              () => Text(
            controller.user.value.email.isNotEmpty
                ? controller.user.value.email
                : 'No email',
            style: TextStyle(
              color: SColors.textSecondary,
              fontSize: SSize.fontSizeMd,
            ),
          ),
        ),
        const SizedBox(height: SSize.xs),

        // Role badge
        Obx(
              () {
            final role = controller.user.value.role;
            final roleLabel = role.toLowerCase() == 'teacher'
                ? 'Teacher'
                : 'Student';

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.md,
                vertical: SSize.xs,
              ),
              decoration: BoxDecoration(
                color: SColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Text(
                roleLabel,
                style: TextStyle(
                  color: SColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: SSize.fontSizeSm,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: SColors.primary.withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.person,
          color: SColors.primary,
          size: 50,
        ),
      ),
    );
  }
}