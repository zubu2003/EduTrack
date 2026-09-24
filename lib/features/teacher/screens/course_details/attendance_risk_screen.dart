import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/controllers/attendance_risk_controller.dart';
import 'package:edutrack/features/course/models/attendance_risk_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/widgets/attendance_risk_detail_sheet.dart';
import 'package:edutrack/common/widget/shimmer/attendance_risk_loading_card.dart';
import 'package:edutrack/features/teacher/screens/course_details/widgets/attendance_risk_student_card.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AttendanceRiskScreen extends StatelessWidget {
  final CourseModel course;

  const AttendanceRiskScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final tag = 'attendance_risk_teacher_${course.courseId}';
    final controller = Get.isRegistered<AttendanceRiskController>(tag: tag)
        ? Get.find<AttendanceRiskController>(tag: tag)
        : Get.put(AttendanceRiskController(course: course), tag: tag);

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(showBackButton: true, onBackPressed: () => Get.back()),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            children: const [
              AttendanceRiskLoadingCard(),
              SizedBox(height: SSize.spaceBtwItems),
              AttendanceRiskLoadingCard(),
              SizedBox(height: SSize.spaceBtwItems),
              AttendanceRiskLoadingCard(),
            ],
          );
        }

        if (controller.errorMessage.value != null) {
          return _ErrorState(onRetry: controller.loadRisks);
        }

        if (controller.risks.isEmpty) {
          return const _EmptyState();
        }

        final low = _count(controller.risks, AttendanceRiskLevel.low);
        final medium = _count(controller.risks, AttendanceRiskLevel.medium);
        final high = _count(controller.risks, AttendanceRiskLevel.high);

        return RefreshIndicator(
          onRefresh: controller.loadRisks,
          color: SColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(SSize.defaultSpace),
            children: [
              Text(
                'Attendance Risk',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: SColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: SSize.xs),
              Text(
                course.courseName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SColors.textSecondary),
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              _SummaryCard(
                total: controller.risks.length,
                low: low,
                medium: medium,
                high: high,
              ),
              const SizedBox(height: SSize.spaceBtwItems),
              ...controller.risks.map(
                (risk) => Padding(
                  padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                  child: AttendanceRiskStudentCard(
                    risk: risk,
                    onTap: () => AttendanceRiskDetailSheet.show(context, risk),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  int _count(List<AttendanceRiskModel> risks, AttendanceRiskLevel level) {
    return risks.where((risk) => risk.riskLevel == level).length;
  }
}

class _SummaryCard extends StatelessWidget {
  final int total;
  final int low;
  final int medium;
  final int high;

  const _SummaryCard({
    required this.total,
    required this.low,
    required this.medium,
    required this.high,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SColors.primary,
      elevation: SSize.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(SSize.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(label: 'TOTAL', value: total, color: SColors.white),
            _SummaryItem(label: 'LOW', value: low, color: SColors.success),
            _SummaryItem(
              label: 'MEDIUM',
              value: medium,
              color: SColors.warning,
            ),
            _SummaryItem(label: 'HIGH', value: high, color: SColors.error),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: SSize.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: SColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.user_search,
              size: 72,
              color: SColors.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            Text(
              'No enrolled students',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Unable to load attendance risk',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: SColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
