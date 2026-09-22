import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AcademicPerformanceInsightStatus extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AcademicPerformanceInsightStatus({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        border: Border.all(color: SColors.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              tooltip: 'Retry AI insight',
              icon: const Icon(Icons.refresh, color: SColors.primary),
            ),
        ],
      ),
    );
  }
}
