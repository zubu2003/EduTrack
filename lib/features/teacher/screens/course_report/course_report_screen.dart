import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/controllers/course_report_controller.dart';
import 'package:edutrack/data/services/export/course_report_export_service.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CourseReportScreen extends StatelessWidget {
  final CourseModel course;

  const CourseReportScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final tag = 'course_report_${course.courseId}';
    final controller = Get.isRegistered<CourseReportController>(tag: tag)
        ? Get.find<CourseReportController>(tag: tag)
        : Get.put(CourseReportController(course: course), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: Get.back),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: SColors.primary),
          );
        }
        final stats = controller.stats.value;
        if (stats == null) {
          return _Status(message: 'No course statistics are available.');
        }

        final report = controller.report.value;
        return RefreshIndicator(
          onRefresh: controller.loadReport,
          color: SColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            children: [
              Text(
                'Course Report',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                '${course.courseName} (${course.courseCode})',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              _StatsCard(stats: stats),
              const SizedBox(height: SSize.spaceBtwItems),
              if (report == null) ...[
                _Status(
                  message:
                      controller.errorMessage.value ??
                      'AI narrative is unavailable.',
                  onRetry: controller.generateNarrative,
                ),
              ] else ...[
                _ReportSection(title: 'Overview', body: [report.overview]),
                _ReportSection(
                  title: 'Attendance Summary',
                  body: [report.attendanceSummary],
                ),
                _ReportSection(
                  title: 'CT Performance',
                  body: [report.ctSummary],
                ),
                _ReportSection(title: 'Risks', body: report.risks),
                _ReportSection(
                  title: 'Recommendations',
                  body: report.recommendations,
                ),
              ],
              const SizedBox(height: SSize.spaceBtwItems),
              if (report != null) ...[
                OutlinedButton.icon(
                  onPressed: () => _exportPdf(context, stats, report),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Export PDF'),
                ),
                const SizedBox(height: SSize.sm),
                OutlinedButton.icon(
                  onPressed: () => _exportExcel(context, stats, report),
                  icon: const Icon(Icons.table_view_outlined),
                  label: const Text('Export Excel'),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    dynamic stats,
    dynamic report,
  ) async {
    try {
      await CourseReportExportService.instance.sharePdf(
        course: course,
        stats: stats,
        report: report,
      );
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _exportExcel(
    BuildContext context,
    dynamic stats,
    dynamic report,
  ) async {
    try {
      final file = await CourseReportExportService.instance.exportExcel(
        course: course,
        stats: stats,
        report: report,
      );
      Get.snackbar('Report exported', 'Saved to ${file.path}');
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(Object error) {
    Get.snackbar('Export failed', error.toString());
  }
}

class _StatsCard extends StatelessWidget {
  final dynamic stats;

  const _StatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final values = [
      ('Students', '${stats.totalStudents}'),
      ('Attendance', '${stats.averageAttendance.toStringAsFixed(1)}%'),
      ('CT average', '${stats.averageCt.toStringAsFixed(1)} / 20'),
      ('At risk', '${stats.atRiskCount}'),
    ];
    return Card(
      color: SColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(SSize.md),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: SSize.md,
          children: values
              .map(
                (item) => SizedBox(
                  width: 125,
                  child: Column(
                    children: [
                      Text(
                        item.$2,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: SColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.$1,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: SColors.white.withValues(alpha: 0.75),
                            ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  final String title;
  final List<String> body;

  const _ReportSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.white,
      margin: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
      child: Padding(
        padding: const EdgeInsets.all(SSize.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.sm),
            ...body.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: SSize.xs),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _Status({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.white,
      child: Padding(
        padding: const EdgeInsets.all(SSize.md),
        child: Row(
          children: [
            Expanded(child: Text(message)),
            if (onRetry != null)
              IconButton(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: SColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
