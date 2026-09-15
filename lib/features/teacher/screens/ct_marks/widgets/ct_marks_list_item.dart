import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CtMarksListItem extends StatelessWidget {
  final CtModel ct;
  final double fullMarks;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const CtMarksListItem({
    super.key,
    required this.ct,
    required this.fullMarks,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = ct.isPublished;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(SSize.md),
        decoration: BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isPublished
                ? SColors.success.withOpacity(0.2)
                : SColors.warning.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: SColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Icon(
                Iconsax.document_text,
                color: SColors.primary,
                size: SSize.iconMd,
              ),
            ),
            const SizedBox(width: SSize.spaceBtwItems),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ct.ctTitle,
                    style: TextStyle(
                      color: SColors.textPrimary,
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Iconsax.document,
                        color: SColors.grey,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        'Full: ${fullMarks.toInt()}',
                        style: TextStyle(
                          color: SColors.textSecondary,
                          fontSize: SSize.fontSizeSm,
                        ),
                      ),
                      const SizedBox(width: SSize.md),
                      Icon(
                        Iconsax.people,
                        color: SColors.grey,
                        size: SSize.iconSm,
                      ),
                      const SizedBox(width: SSize.xs),
                      Text(
                        '${ct.studentCount}',
                        style: TextStyle(
                          color: SColors.textSecondary,
                          fontSize: SSize.fontSizeSm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SSize.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPublished
                          ? SColors.success.withOpacity(0.1)
                          : SColors.warning.withOpacity(0.1),
                      borderRadius:
                      BorderRadius.circular(SSize.borderRadiusSm),
                    ),
                    child: Text(
                      isPublished ? '● Published' : '● Draft',
                      style: TextStyle(
                        color: isPublished
                            ? SColors.success
                            : SColors.warning,
                        fontSize: SSize.fontSizeSm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: SColors.grey,
              size: SSize.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}