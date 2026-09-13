class SDepartments {
  static const Map<String, String> deptMap = {
    '01': 'Civil',
    '02': 'EEE',
    '03': 'ME',
    '04': 'CSE',
  };

  static String getDeptName(String code) {
    return deptMap[code] ?? 'Unknown';
  }

  static List<String> get deptCodes => deptMap.keys.toList();
  static List<String> get deptNames => deptMap.values.toList();

  /// Get full label: "04 - CSE"
  static String getDeptLabel(String code) {
    return '$code - ${deptMap[code] ?? "Unknown"}';
  }
}