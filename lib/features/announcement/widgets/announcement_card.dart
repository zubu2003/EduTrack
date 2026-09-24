import 'package:flutter/material.dart';
import 'package:edutrack/features/announcement/models/announcement_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onEdit;

  const AnnouncementCard({super.key, required this.announcement, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.white,
      elevation: SSize.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(SSize.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: SColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: SSize.sm),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    tooltip: 'Edit announcement',
                    icon: const Icon(Icons.edit_outlined),
                    color: SColors.primary,
                  )
                else
                  Text(
                    _formatDate(announcement.updatedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: SSize.sm),
            Text(
              '${announcement.courseCode} • ${announcement.courseName} • Section ${announcement.courseSection}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: SColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: SSize.sm),
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SSize.sm),
            Text(
              'By ${announcement.authorName}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: SColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    return '${local.day}/${local.month}/${local.year}';
  }
}
