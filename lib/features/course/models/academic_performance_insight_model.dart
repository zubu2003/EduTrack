class AcademicPerformanceInsightModel {
  final String insight;
  final String tip;

  const AcademicPerformanceInsightModel({
    required this.insight,
    required this.tip,
  });

  factory AcademicPerformanceInsightModel.fromAiResponse(
    Map<String, dynamic> json,
  ) {
    final insight = json['insight'];
    final tip = json['tip'];

    if (insight is! String || tip is! String) {
      throw const FormatException(
        'AI response has invalid academic insight fields',
      );
    }

    final trimmedInsight = insight.trim();
    final trimmedTip = tip.trim();
    if (trimmedInsight.isEmpty || trimmedTip.isEmpty) {
      throw const FormatException(
        'AI response contains empty academic insight text',
      );
    }

    return AcademicPerformanceInsightModel(
      insight: trimmedInsight,
      tip: trimmedTip,
    );
  }
}
