enum AttendanceRiskLevel { low, medium, high }

extension AttendanceRiskLevelX on AttendanceRiskLevel {
  String get label => name.toUpperCase();

  static AttendanceRiskLevel parse(String value) {
    switch (value.trim().toUpperCase()) {
      case 'LOW':
        return AttendanceRiskLevel.low;
      case 'MEDIUM':
        return AttendanceRiskLevel.medium;
      case 'HIGH':
        return AttendanceRiskLevel.high;
      default:
        throw FormatException('Invalid attendance risk level: $value');
    }
  }
}

class AttendanceRiskModel {
  final String studentId;
  final String studentName;
  final double attendancePercent;
  final AttendanceRiskLevel riskLevel;
  final String reason;
  final String recommendation;

  const AttendanceRiskModel({
    required this.studentId,
    required this.studentName,
    required this.attendancePercent,
    required this.riskLevel,
    required this.reason,
    required this.recommendation,
  });

  factory AttendanceRiskModel.fromAiResponse({
    required String studentId,
    required String studentName,
    required double attendancePercent,
    required Map<String, dynamic> json,
  }) {
    final riskValue = json['riskLevel'];
    final reason = json['reason'];
    final recommendation = json['recommendation'];

    if (riskValue is! String ||
        reason is! String ||
        recommendation is! String) {
      throw const FormatException(
        'AI response has invalid attendance-risk fields',
      );
    }

    final trimmedReason = reason.trim();
    final trimmedRecommendation = recommendation.trim();
    if (trimmedReason.isEmpty || trimmedRecommendation.isEmpty) {
      throw const FormatException(
        'AI response contains empty attendance-risk text',
      );
    }

    return AttendanceRiskModel(
      studentId: studentId,
      studentName: studentName,
      attendancePercent: attendancePercent,
      riskLevel: AttendanceRiskLevelX.parse(riskValue),
      reason: trimmedReason,
      recommendation: trimmedRecommendation,
    );
  }
}
