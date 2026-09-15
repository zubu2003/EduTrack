import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/personalization/controllers/profile_image_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileImageController>();

    return Obx(() {
      final user = controller.user.value;
      final isTeacher = user.role.toLowerCase() == 'teacher';

      // Convert department code → name
      final deptName = user.department.isNotEmpty
          ? SDepartments.getDeptName(user.department)
          : '';

      final List<Map<String, dynamic>> infoItems = [
        {
          'icon': Iconsax.user,
          'label': isTeacher ? 'Teacher ID' : 'Student ID',
          'value': isTeacher
              ? (user.teacherId.isNotEmpty ? user.teacherId : 'Not set')
              : (user.studentId.isNotEmpty ? user.studentId : 'Not set'),
        },
        {
          'icon': Iconsax.building,
          'label': 'Department',
          'value': deptName.isNotEmpty ? deptName : 'Not set',
        },
        if (!isTeacher)
          {
            'icon': Iconsax.calendar,
            'label': 'Batch',
            'value': user.batch.isNotEmpty ? user.batch : 'Not set',
          },
        if (isTeacher)
          {
            'icon': Iconsax.award,
            'label': 'Designation',
            'value':
            user.designation.isNotEmpty ? user.designation : 'Not set',
          },
        {
          'icon': Iconsax.sms,
          'label': 'Email',
          'value': user.email.isNotEmpty ? user.email : 'Not set',
        },
        {
          'icon': Iconsax.call,
          'label': 'Phone',
          'value': user.phone.isNotEmpty ? user.phone : 'Not set',
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

            Divider(
              color: SColors.grey.withOpacity(0.2),
              height: 1,
            ),
            const SizedBox(height: SSize.spaceBtwItems),

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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}