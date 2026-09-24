import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:edutrack/features/course/models/academic_performance_insight_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AcademicPerformanceInsightCard extends StatelessWidget {
  final AcademicPerformanceInsightModel insight;
  final VoidCallback? onTap;
  final String subtitle;

  const AcademicPerformanceInsightCard({
    super.key,
    required this.insight,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF2D2D44)],
        ),
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: const Icon(
              Iconsax.magic_star,
              color: SColors.white,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: SColors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  insight.insight,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: SColors.white),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: SSize.sm),
            const Icon(Icons.chevron_right, color: SColors.white),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: card,
    );
  }
}
