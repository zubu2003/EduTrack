import 'package:flutter/material.dart';
import 'package:edutrack/common/widget/shimmer/shimmer.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceRiskLoadingCard extends StatelessWidget {
  const AttendanceRiskLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.borderRadiusLg),
        border: Border.all(color: SColors.secondary.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: SColors.secondary.withValues(alpha: 0.08),
            blurRadius: SSize.md,
            offset: const Offset(0, SSize.xs),
          ),
        ],
      ),
      child: SShimmer(
        baseColor: SColors.secondary.withValues(alpha: 0.12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: SColors.secondary,
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: const Icon(Icons.auto_awesome, color: SColors.white),
            ),
            const SizedBox(width: SSize.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SShimmerBox(width: 145, height: SSize.fontSizeLg),
                  const SizedBox(height: SSize.sm),
                  const SShimmerBox(
                    width: double.infinity,
                    height: SSize.fontSizeMd,
                  ),
                  const SizedBox(height: SSize.xs),
                  FractionallySizedBox(
                    widthFactor: 0.68,
                    child: const SShimmerBox(height: SSize.fontSizeMd),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SSize.md),
            const SShimmerBox(
              width: 64,
              height: SSize.fontSizeLg,
              borderRadius: BorderRadius.all(
                Radius.circular(SSize.borderRadiusPill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
