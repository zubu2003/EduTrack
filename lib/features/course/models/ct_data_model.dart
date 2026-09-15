import 'package:cloud_firestore/cloud_firestore.dart';

/// Sentinel stored as double in memory; written to Firestore as "abs".
class CtMark {
  static const double absent = -1;

  static bool isAbsent(double? value) => value != null && value < 0;

  static bool isAbsentText(String raw) {
    final s = raw.trim().toLowerCase();
    return s == 'abs' || s == 'absent';
  }

  static String display(double? value) {
    if (value == null) return '—';
    if (isAbsent(value)) return 'abs';
    return value.toStringAsFixed(0);
  }

  static double? parse(dynamic value) {
    if (value == null) return null;
    if (value is num) {
      return value.toDouble();
    }
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    if (isAbsentText(s)) return absent;
    return double.tryParse(s);
  }
}

/// Represents ONE class test (CT-1, CT-2, etc.)
class CtModel {
  final String ctTitle;
  final String date; // ISO format "2026-09-15"
  final String status; // "draft" | "published"
  final Map<String, double> marks; // { studentUid: mark }  // -1 => abs
  final DateTime createdAt;
  final DateTime updatedAt;

  CtModel({
    required this.ctTitle,
    required this.date,
    required this.status,
    required this.marks,
    required this.createdAt,
    required this.updatedAt,
  });

  static CtModel empty() => CtModel(
    ctTitle: '',
    date: '',
    status: 'draft',
    marks: {},
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory CtModel.fromJson(Map<String, dynamic> json) {
    final rawMarks = json['marks'] as Map<String, dynamic>? ?? {};
    final marks = <String, double>{};
    rawMarks.forEach((key, value) {
      final parsed = CtMark.parse(value);
      if (parsed != null) marks[key] = parsed;
    });

    return CtModel(
      ctTitle: json['ctTitle'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'draft',
      marks: marks,
      createdAt:
      (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
      (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ctTitle': ctTitle,
      'date': date,
      'status': status,
      'marks': marks.map(
        (key, value) => MapEntry(key, CtMark.isAbsent(value) ? 'abs' : value),
      ),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CtModel copyWith({
    String? ctTitle,
    String? date,
    String? status,
    Map<String, double>? marks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CtModel(
      ctTitle: ctTitle ?? this.ctTitle,
      date: date ?? this.date,
      status: status ?? this.status,
      marks: marks ?? this.marks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';

  /// Students who have a mark (not empty)
  int get studentCount => marks.length;

  /// Compute average marks for this CT (skips abs)
  double get average {
    final numeric = marks.values.where((m) => !CtMark.isAbsent(m)).toList();
    if (numeric.isEmpty) return 0;
    final total = numeric.fold<double>(0, (sum, m) => sum + m);
    return total / numeric.length;
  }
}

/// Holds ALL CTs for a course
class CtDataModel {
  final String courseId;
  final double fullMarks; // per CT (e.g., 20)
  final int bestOfCount; // best 3
  final int totalCTs; // expected count (n+1)
  final Map<String, CtModel> cts; // { "CT-1": CtModel, "CT-2": CtModel }
  final Map<String, double> totals; // { studentUid: totalFromExcel }
  final DateTime updatedAt;

  CtDataModel({
    required this.courseId,
    required this.fullMarks,
    required this.bestOfCount,
    required this.totalCTs,
    required this.cts,
    required this.totals,
    required this.updatedAt,
  });

  static CtDataModel empty() => CtDataModel(
    courseId: '',
    fullMarks: 20,
    bestOfCount: 3,
    totalCTs: 4,
    cts: {},
    totals: {},
    updatedAt: DateTime.now(),
  );

  factory CtDataModel.fromJson(Map<String, dynamic> json, String courseId) {
    final rawCts = json['cts'] as Map<String, dynamic>? ?? {};
    final cts = <String, CtModel>{};
    rawCts.forEach((key, value) {
      cts[key] = CtModel.fromJson(value as Map<String, dynamic>);
    });

    final rawTotals = json['totals'] as Map<String, dynamic>? ?? {};
    final totals = <String, double>{};
    rawTotals.forEach((key, value) {
      totals[key] = (value as num).toDouble();
    });

    return CtDataModel(
      courseId: courseId,
      fullMarks: (json['fullMarks'] as num?)?.toDouble() ?? 20,
      bestOfCount: json['bestOfCount'] ?? 3,
      totalCTs: json['totalCTs'] ?? 4,
      cts: cts,
      totals: totals,
      updatedAt:
      (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'fullMarks': fullMarks,
      'bestOfCount': bestOfCount,
      'totalCTs': totalCTs,
      'cts': cts.map((key, value) => MapEntry(key, value.toJson())),
      'totals': totals,
      'updatedAt': updatedAt,
    };
  }

  CtDataModel copyWith({
    String? courseId,
    double? fullMarks,
    int? bestOfCount,
    int? totalCTs,
    Map<String, CtModel>? cts,
    Map<String, double>? totals,
    DateTime? updatedAt,
  }) {
    return CtDataModel(
      courseId: courseId ?? this.courseId,
      fullMarks: fullMarks ?? this.fullMarks,
      bestOfCount: bestOfCount ?? this.bestOfCount,
      totalCTs: totalCTs ?? this.totalCTs,
      cts: cts ?? this.cts,
      totals: totals ?? this.totals,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Sorted CT keys: ["CT-1", "CT-2", "CT-3", "CT-4"]
  List<String> get sortedCtKeys {
    final keys = cts.keys.toList();
    keys.sort((a, b) => _ctNumber(a).compareTo(_ctNumber(b)));
    return keys;
  }

  int _ctNumber(String title) {
    final match = RegExp(r'(\d+)').firstMatch(title);
    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
  }

  /// Numeric CT marks only (abs is skipped).
  List<double> numericMarksFor(String studentUid) {
    final marks = <double>[];
    for (final ct in cts.values) {
      final m = ct.marks[studentUid];
      if (m != null && !CtMark.isAbsent(m)) {
        marks.add(m);
      }
    }
    return marks;
  }

  /// Credit n → expected n+1 CTs, total = top n numeric marks.
  double computeCourseTotal(String studentUid, int credit) {
    final n = credit > 0 ? credit : bestOfCount;
    return computeBestOf(studentUid, n);
  }

  /// Best [n] numeric CT marks. Abs entries are ignored.
  double computeBestOf(String studentUid, int n) {
    if (n <= 0) return 0;
    final marks = numericMarksFor(studentUid);
    marks.sort((a, b) => b.compareTo(a));
    return marks.take(n).fold<double>(0, (sum, m) => sum + m);
  }

  double computeTotal(String studentUid, {int? credit}) {
    return computeCourseTotal(studentUid, credit ?? bestOfCount);
  }

  double computeBestOf3(String studentUid) {
    return computeBestOf(studentUid, bestOfCount);
  }
}