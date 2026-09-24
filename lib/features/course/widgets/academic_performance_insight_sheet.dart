import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/academic_performance_insight_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AcademicPerformanceInsightSheet extends StatelessWidget {
  final AcademicPerformanceInsightModel insight;

  const AcademicPerformanceInsightSheet({super.key, required this.insight});

  static Future<void> show(
    BuildContext context,
    AcademicPerformanceInsightModel insight,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: SColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SSize.borderRadiusXl),
        ),
      ),
      builder: (_) => AcademicPerformanceInsightSheet(insight: insight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SSize.defaultSpace,
            SSize.spaceBtwItems,
            SSize.defaultSpace,
            SSize.defaultSpace,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: SSize.xs,
                  decoration: BoxDecoration(
                    color: SColors.lightGrey,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusPill),
                  ),
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Text(
                'AI Academic Insight',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              Text(
                insight.insight,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: SSize.spaceBtwSections),
              Text(
                'Tips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(insight.tip, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
