import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceStudentItem extends StatelessWidget {
  final String name;
  final String id;
  final bool isPresent;
  final VoidCallback onTap;

  const AttendanceStudentItem({
    super.key,
    required this.name,
    required this.id,
    required this.isPresent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SSize.sm,
          vertical: SSize.xs,
        ),
        decoration: BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isPresent
                ? SColors.success.withOpacity(0.3)
                : SColors.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox visual (whole row is tappable)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isPresent ? SColors.success : Colors.transparent,
                borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                border: Border.all(
                  color: isPresent ? SColors.success : SColors.grey,
                  width: 2,
                ),
              ),
              child: isPresent
                  ? const Icon(
                Icons.check,
                color: SColors.white,
                size: 16,
              )
                  : null,
            ),
            const SizedBox(width: SSize.sm),

            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: SColors.primary.withOpacity(0.08),
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: TextStyle(
                  color: SColors.primary,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: SSize.spaceBtwItems),

            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Row(
                    children: [
                      Icon(
                        Iconsax.document,
                        color: SColors.grey,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        'ID: $id',
                        style: TextStyle(
                          color: SColors.textSecondary,
                          fontSize: SSize.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SSize.md,
                vertical: SSize.xs,
              ),
              decoration: BoxDecoration(
                color: isPresent
                    ? SColors.success.withOpacity(0.1)
                    : SColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                border: Border.all(
                  color: isPresent
                      ? SColors.success.withOpacity(0.3)
                      : SColors.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                isPresent ? 'Present' : 'Absent',
                style: TextStyle(
                  color: isPresent ? SColors.success : SColors.error,
                  fontSize: SSize.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}