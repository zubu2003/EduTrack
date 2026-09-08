import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      {
        'icon': Iconsax.moon,
        'label': 'Dark Mode',
        'type': 'switch',
      },
      {
        'icon': Iconsax.logout,
        'label': 'Logout',
        'type': 'logout',
      },
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
          // Title
          Row(
            children: [
              Icon(
                Iconsax.setting_2,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
              const SizedBox(width: SSize.sm),
              Text(
                'Settings',
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

          // Settings Items
          ...settings.map((item) {
            final isLogout = item['type'] == 'logout';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: SSize.xs),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isLogout ? SColors.error : SColors.primary,
                    size: SSize.iconMd,
                  ),
                  const SizedBox(width: SSize.spaceBtwItems),
                  Expanded(
                    child: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isLogout ? SColors.error : SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (item['type'] == 'switch')
                    Switch(
                      value: false,
                      onChanged: (_) {},
                      activeColor: SColors.primary,
                    ),
                  if (isLogout)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: SColors.error,
                      size: SSize.iconSm,
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