class CourseReportModel {
  final String overview;
  final String attendanceSummary;
  final String ctSummary;
  final List<String> risks;
  final List<String> recommendations;

  const CourseReportModel({
    required this.overview,
    required this.attendanceSummary,
    required this.ctSummary,
    required this.risks,
    required this.recommendations,
  });

  factory CourseReportModel.fromAiResponse(Map<String, dynamic> json) {
    final overview = _requiredText(json['overview'], 'overview');
    final attendanceSummary = _requiredText(
      json['attendanceSummary'],
      'attendanceSummary',
    );
    final ctSummary = _requiredText(json['ctSummary'], 'ctSummary');
    final risks = _requiredList(json['risks'], 'risks');
    final recommendations = _requiredList(
      json['recommendations'],
      'recommendations',
    );

    return CourseReportModel(
      overview: overview,
      attendanceSummary: attendanceSummary,
      ctSummary: ctSummary,
      risks: risks,
      recommendations: recommendations,
    );
  }

  static String _requiredText(dynamic value, String field) {
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('AI report field "$field" is invalid');
    }
    return value.trim();
  }

  static List<String> _requiredList(dynamic value, String field) {
    if (value is! List) {
      throw FormatException('AI report field "$field" is invalid');
    }
    final values = value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (values.isEmpty) {
      throw FormatException('AI report field "$field" is empty');
    }
    return values;
  }
}

class CourseReportStats {
  final int totalStudents;
  final double averageAttendance;
  final double averageCt;
  final int atRiskCount;
  final int totalSessions;

  const CourseReportStats({
    required this.totalStudents,
    required this.averageAttendance,
    required this.averageCt,
    required this.atRiskCount,
    required this.totalSessions,
  });
}
