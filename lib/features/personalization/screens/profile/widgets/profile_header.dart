import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage = '',
  });

  @override
  Widget build(BuildContext context) {
    // Determine role label
    final roleLabel = role.toLowerCase() == 'teacher' ? 'Teacher' : 'Student';

    return Column(
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
            child: profileImage.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: profileImage,
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
              errorWidget: (context, url, error) => Container(
                color: SColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: SColors.primary,
                  size: 50,
                ),
              ),
            )
                : Container(
              color: SColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: SColors.primary,
                size: 50,
              ),
            ),
          ),
        ),
        const SizedBox(height: SSize.spaceBtwItems),

        // Name
        Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
        const SizedBox(height: SSize.xs),

        // Email
        Text(
          email,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeMd,
          ),
        ),
        const SizedBox(height: SSize.xs),

        // Role Badge
        Container(
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
        ),
      ],
    );
  }
}