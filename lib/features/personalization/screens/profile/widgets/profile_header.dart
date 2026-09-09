import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: SColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: SColors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: SColors.white,
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Name
          Text(
            'Zubayer Muntasir',
            style: const TextStyle(
              color: SColors.white,
              fontSize: SSize.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SSize.xs),

          // Email
          Text(
            'zubayer@university.edu',
            style: TextStyle(
              color: SColors.white.withOpacity(0.8),
              fontSize: SSize.fontSizeMd,
            ),
          ),
          const SizedBox(height: SSize.xs),

          // Role & Department
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SSize.md,
              vertical: SSize.xs,
            ),
            decoration: BoxDecoration(
              color: SColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: const Text(
              'Student • CSE Department',
              style: TextStyle(
                color: SColors.white,
                fontWeight: FontWeight.w600,
                fontSize: SSize.fontSizeSm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}