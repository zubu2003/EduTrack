import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceRiskStatus extends StatelessWidget {
  final bool isError;
  final VoidCallback? onRetry;

  const AttendanceRiskStatus({super.key, required this.isError, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        color: SColors.white,
        borderRadius: BorderRadius.circular(SSize.borderRadiusLg),
        border: Border.all(color: SColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.warning_amber_rounded : Icons.insights_outlined,
            color: isError ? SColors.warning : SColors.textSecondary,
          ),
          const SizedBox(width: SSize.sm),
          Expanded(
            child: Text(
              isError
                  ? 'Attendance risk could not be loaded.'
                  : 'Attendance risk will appear after attendance is recorded.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
            ),
          ),
          if (isError)
            IconButton(
              onPressed: onRetry,
              tooltip: 'Retry attendance risk',
              icon: const Icon(Icons.refresh, color: SColors.primary),
            ),
        ],
      ),
    );
  }
}
