import 'package:flutter/material.dart';
import 'package:edutrack/common/widget/shimmer/shimmer.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AcademicPerformanceInsightLoadingCard extends StatelessWidget {
  final bool showAction;

  const AcademicPerformanceInsightLoadingCard({
    super.key,
    this.showAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        border: Border.all(color: SColors.secondary.withValues(alpha: 0.2)),
      ),
      child: SShimmer(
        baseColor: SColors.secondary.withValues(alpha: 0.12),
        child: Row(
          children: [
            const SShimmerBox(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.all(
                Radius.circular(SSize.borderRadiusMd),
              ),
            ),
            const SizedBox(width: SSize.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SShimmerBox(width: 100, height: SSize.fontSizeSm),
                  SizedBox(height: SSize.sm),
                  SShimmerBox(width: double.infinity, height: SSize.fontSizeMd),
                  SizedBox(height: SSize.xs),
                  FractionallySizedBox(
                    widthFactor: 0.72,
                    child: SShimmerBox(height: SSize.fontSizeMd),
                  ),
                ],
              ),
            ),
            if (showAction) ...[
              const SizedBox(width: SSize.sm),
              const SShimmerBox(
                width: 18,
                height: 18,
                borderRadius: BorderRadius.all(
                  Radius.circular(SSize.borderRadiusPill),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
