class AttendanceRecordModel {
  final String studentId;
  final String studentName;
  final String studentCode;
  final String status; // "present" | "absent" | "late"

  AttendanceRecordModel({
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.status,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentCode: json['studentCode'] ?? '',
      status: json['status'] ?? 'absent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentCode': studentCode,
      'status': status,
    };
  }

  AttendanceRecordModel copyWith({
    String? studentId,
    String? studentName,
    String? studentCode,
    String? status,
  }) {
    return AttendanceRecordModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentCode: studentCode ?? this.studentCode,
      status: status ?? this.status,
    );
  }
}