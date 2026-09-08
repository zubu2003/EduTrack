import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final infoItems = [
      {'icon': Iconsax.document, 'label': 'Student/Teacher ID', 'value': 'STU-2024-001'},
      {'icon': Iconsax.building, 'label': 'Department', 'value': 'CSE'},
      {'icon': Iconsax.calendar, 'label': 'Batch/Year', 'value': '2024'},
      {'icon': Iconsax.sms, 'label': 'Email', 'value': 'zubayer@university.edu'},
      {'icon': Iconsax.call, 'label': 'Phone', 'value': '+880 1234 567890'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Title
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
              const SizedBox(width: SSize.sm),
              Text(
                'Personal Information',
                style: TextStyle(
                  color: SColors.textPrimary,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Divider
          Divider(
            color: SColors.grey.withOpacity(0.2),
            height: 1,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // Info Items
          ...infoItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: SSize.xs),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: SColors.primary,
                    size: SSize.iconSm,
                  ),
                  const SizedBox(width: SSize.spaceBtwItems),
                  SizedBox(
                    width: 120,
                    child: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeSm,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['value'] as String,
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}