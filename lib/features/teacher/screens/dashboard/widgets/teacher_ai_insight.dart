import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/shimmer/academic_performance_insight_loading_card.dart';
import 'package:edutrack/features/course/controllers/academic_performance_insight_controller.dart';
import 'package:edutrack/features/course/widgets/academic_performance_insight_card.dart';
import 'package:edutrack/features/course/widgets/academic_performance_insight_status.dart';

class TeacherAIInsight extends StatelessWidget {
  const TeacherAIInsight({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AcademicPerformanceInsightController>(
      tag: 'teacher_academic_insight',
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return const AcademicPerformanceInsightLoadingCard();
      }

      final insight = controller.insight.value;
      if (insight == null) {
        return AcademicPerformanceInsightStatus(
          message: controller.errorMessage.value == null
              ? 'AI insight will appear after course performance data is available.'
              : 'AI insight could not be loaded.',
          onRetry: controller.errorMessage.value == null
              ? null
              : controller.loadInsight,
        );
      }

      return AcademicPerformanceInsightCard(
        insight: insight,
        subtitle: 'AI Insight',
      );
    });
  }
}
