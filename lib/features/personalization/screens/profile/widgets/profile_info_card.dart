import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class ProfileInfoCard extends StatelessWidget {
  final String uid;
  final String studentId;
  final String teacherId;
  final String department;
  final String batch;
  final String designation;
  final String email;
  final String phone;
  final String role;

  const ProfileInfoCard({
    super.key,
    required this.uid,
    required this.studentId,
    required this.teacherId,
    required this.department,
    required this.batch,
    required this.designation,
    required this.email,
    required this.phone,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isTeacher = role.toLowerCase() == 'teacher';

    // Build info items based on role
    final List<Map<String, dynamic>> infoItems = [
      {
        'icon': Iconsax.user,
        'label': isTeacher ? 'Teacher ID' : 'Student ID',
        'value': isTeacher
            ? (teacherId.isNotEmpty ? teacherId : 'Not set')
            : (studentId.isNotEmpty ? studentId : 'Not set'),
      },
      {
        'icon': Iconsax.building,
        'label': 'Department',
        'value': department.isNotEmpty ? department : 'Not set',
      },
      if (!isTeacher)
        {
          'icon': Iconsax.calendar,
          'label': 'Batch',
          'value': batch.isNotEmpty ? batch : 'Not set',
        },
      if (isTeacher)
        {
          'icon': Iconsax.award,
          'label': 'Designation',
          'value': designation.isNotEmpty ? designation : 'Not set',
        },
      {
        'icon': Iconsax.sms,
        'label': 'Email',
        'value': email.isNotEmpty ? email : 'Not set',
      },
      {
        'icon': Iconsax.call,
        'label': 'Phone',
        'value': phone.isNotEmpty ? phone : 'Not set',
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
          // Header
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
  }
}