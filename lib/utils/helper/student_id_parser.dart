import 'package:edutrack/utils/constant/departments.dart';

class StudentIdParser {
  /// Parse student ID like "2204067"
  /// Returns: { batch: "22", department: "04", roll: "067" }
  static Map<String, String> parse(String studentId) {
    if (studentId.length < 7) {
      return {'batch': '', 'department': '', 'roll': ''};
    }
    return {
      'batch': studentId.substring(0, 2),
      'department': studentId.substring(2, 4),
      'roll': studentId.substring(4),
    };
  }

  /// Auto-calculate section from roll (66 per section)
  static String getSection(int roll) {
    if (roll <= 66) return 'A';
    if (roll <= 132) return 'B';
    return 'C';
  }

  /// Get section range label
  static String getSectionRange(String section) {
    switch (section) {
      case 'A':
        return 'Rolls 001-066';
      case 'B':
        return 'Rolls 067-132';
      case 'C':
        return 'Rolls 133-198';
      default:
        return '';
    }
  }

  /// Build student ID from parts
  static String buildId({
    required String batch,
    required String department,
    required int roll,
  }) {
    final rollStr = roll.toString().padLeft(3, '0');
    return '$batch$department$rollStr';
  }

  /// Get department name from student ID
  static String getDeptName(String studentId) {
    final parsed = parse(studentId);
    return SDepartments.getDeptName(parsed['department'] ?? '');
  }
}