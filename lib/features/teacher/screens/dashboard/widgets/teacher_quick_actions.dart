import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherQuickActions extends StatelessWidget {
  const TeacherQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'label': 'Take Attendance',
        'icon': Iconsax.clipboard_tick,
        'color': SColors.primary,
      },
      {
        'label': 'Upload Marks',
        'icon': Iconsax.document_upload,
        'color': const Color(0xFF6C63FF),
      },
      {
        'label': 'Send Announcement',
        'icon': Iconsax.notification,
        'color': const Color(0xFF4A90D9),
      },
      {
        'label': 'View Reports',
        'icon': Iconsax.chart,
        'color': const Color(0xFF1A1A2E),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
        const SizedBox(height: SSize.spaceBtwItems),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: SSize.spaceBtwItems,
            mainAxisSpacing: SSize.spaceBtwItems,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              context,
              action['label'] as String,
              action['icon'] as IconData,
              action['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String label,
      IconData icon,
      Color color,
      ) {
    return InkWell(
      onTap: () {
        Get.snackbar(
          'Coming Soon',
          '$label feature coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(SSize.sm),
        decoration: BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Icon(
                icon,
                color: color,
                size: SSize.iconMd,
              ),
            ),
            const SizedBox(height: SSize.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}