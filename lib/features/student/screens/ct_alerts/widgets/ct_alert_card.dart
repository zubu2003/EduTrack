import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CtAlertCard extends StatelessWidget {
  final CtAlertModel alert;
  final VoidCallback onTap;

  const CtAlertCard({super.key, required this.alert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.white,
      elevation: SSize.cardElevation,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(SSize.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      alert.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: SColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _DaysBadge(days: alert.daysRemaining),
                ],
              ),
              const SizedBox(height: SSize.xs),
              Text(
                alert.ctTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.sm),
              Text(
                alert.formattedDate,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: SColors.textSecondary),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                alert.topics,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (alert.reminder != null) ...[
                const SizedBox(height: SSize.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: SSize.iconSm,
                      color: SColors.secondary,
                    ),
                    const SizedBox(width: SSize.xs),
                    Expanded(
                      child: Text(
                        alert.reminder!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: SColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DaysBadge extends StatelessWidget {
  final int days;

  const _DaysBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    final label = days == 0 ? 'Today' : '$days days';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SSize.sm,
        vertical: SSize.xs,
      ),
      decoration: BoxDecoration(
        color: SColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(SSize.borderRadiusPill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: SColors.warning,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
