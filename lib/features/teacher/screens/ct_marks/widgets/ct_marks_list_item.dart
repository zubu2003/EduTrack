import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CtMarksListItem extends StatelessWidget {
  final String title;
  final String date;
  final int fullMarks;
  final String status;
  final VoidCallback onTap;

  const CtMarksListItem({
    super.key,
    required this.title,
    required this.date,
    required this.fullMarks,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPublished = status.toLowerCase() == 'published';

    final Color statusColor =
    isPublished ? SColors.success : SColors.warning;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: SSize.xs,
          ),
          decoration: BoxDecoration(
            color: SColors.white,
            borderRadius: BorderRadius.circular(SSize.cardRadius),
            border: Border.all(
              color: statusColor.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: SColors.black.withOpacity(0.045),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SSize.cardRadius),
            child: Stack(
              children: [
                // Subtle top/left accent
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: statusColor,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(SSize.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------------------------
                      // Icon
                      // -------------------------------------------------
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SColors.primary.withOpacity(0.16),
                              SColors.primary.withOpacity(0.07),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            SSize.borderRadiusMd,
                          ),
                        ),
                        child: Icon(
                          Iconsax.document_text_1,
                          color: SColors.primary,
                          size: SSize.iconMd,
                        ),
                      ),

                      const SizedBox(width: SSize.spaceBtwItems),

                      // -------------------------------------------------
                      // Main Content
                      // -------------------------------------------------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: SColors.textPrimary,
                                fontSize: SSize.fontSizeMd,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),

                            const SizedBox(height: SSize.sm),

                            // Metadata
                            Wrap(
                              spacing: SSize.md,
                              runSpacing: SSize.xs,
                              children: [
                                _InfoItem(
                                  icon: Iconsax.calendar_1,
                                  text: date,
                                ),
                                _InfoItem(
                                  icon: Iconsax.document,
                                  text: 'Full Marks: $fullMarks',
                                ),
                              ],
                            ),

                            const SizedBox(height: SSize.sm),

                            // Status
                            _StatusBadge(
                              status: status,
                              color: statusColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: SSize.sm),

                      // -------------------------------------------------
                      // Arrow
                      // -------------------------------------------------
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: SColors.grey.withOpacity(0.07),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.arrow_right_3,
                          size: 16,
                          color: SColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// Info Item
// ================================================================

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: SSize.iconSm,
          color: SColors.grey,
        ),
        const SizedBox(width: SSize.xs),
        Text(
          text,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// Status Badge
// ================================================================

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SSize.sm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: SSize.fontSizeSm,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
