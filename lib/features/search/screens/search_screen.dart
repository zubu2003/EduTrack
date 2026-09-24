import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/search/controllers/search_controller.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class SearchScreen extends StatelessWidget {
  final String role;

  const SearchScreen({super.key, required this.role});

  List<String> get _quickActions => role == 'student'
      ? const [
          'My Attendance',
          'My CT Marks',
          'Upcoming CTs',
          'My Courses',
          'My Routine',
        ]
      : const [
          "Today's Attendance",
          'Low Attendance Students',
          'Recent CT Performance',
          'Upcoming CTs',
          'Students Who Missed Classes',
        ];

  @override
  Widget build(BuildContext context) {
    final tag = 'search_$role';
    final controller = Get.isRegistered<AppSearchController>(tag: tag)
        ? Get.find<AppSearchController>(tag: tag)
        : Get.put(AppSearchController(role: role), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: Get.back),
      body: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => controller.query.value = value,
              onSubmitted: controller.runNaturalLanguageSearch,
              decoration: InputDecoration(
                hintText: role == 'student'
                    ? 'Search courses, attendance, or CT marks'
                    : 'Search students, attendance, or courses',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => controller.runNaturalLanguageSearch(
                    controller.query.value,
                  ),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'Quick searches',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.sm),
            Wrap(
              spacing: SSize.sm,
              runSpacing: SSize.sm,
              children: _quickActions
                  .map(
                    (action) => ActionChip(
                      label: Text(action),
                      onPressed: () => controller.runQuickSearch(action),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: SColors.primary),
                  );
                }
                if (controller.errorMessage.value != null) {
                  return _StateMessage(
                    message: controller.errorMessage.value!,
                    onRetry: controller.query.value.isEmpty
                        ? null
                        : () => controller.runNaturalLanguageSearch(
                            controller.query.value,
                          ),
                  );
                }
                if (controller.results.isEmpty) {
                  return const _StateMessage(message: 'No results found.');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.explanation.value != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: SSize.sm),
                        child: Text(
                          controller.explanation.value!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: SColors.textSecondary),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.results.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: SSize.sm),
                        itemBuilder: (context, index) {
                          final result = controller.results[index];
                          return Card(
                            color: SColors.white,
                            child: ListTile(
                              title: Text(result.title),
                              subtitle: Text(
                                result.subtitle,
                                style: result.highlightSubtitle
                                    ? Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        color: SColors.primary,
                                        fontWeight: FontWeight.w800,
                                      )
                                    : null,
                              ),
                              trailing: result.detail == null
                                  ? null
                                  : Text(
                                      result.detail!,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _StateMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: SColors.textSecondary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: SSize.sm),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: SColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}
