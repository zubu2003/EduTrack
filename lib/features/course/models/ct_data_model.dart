import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents ONE class test (CT-1, CT-2, etc.)
class CtModel {
  final String ctTitle;
  final String date; // ISO format "2026-09-15"
  final String status; // "draft" | "published"
  final Map<String, double> marks; // { studentUid: mark }
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
      marks[key] = (value as num).toDouble();
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
      'marks': marks,
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

  /// Compute average marks for this CT
  double get average {
    if (marks.isEmpty) return 0;
    final total = marks.values.fold<double>(0, (sum, m) => sum + m);
    return total / marks.length;
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

  /// Compute best-of-3 total for a student
  double computeBestOf3(String studentUid) {
    // First, check if Excel provided a Total
    if (totals.containsKey(studentUid)) {
      return totals[studentUid]!;
    }

    // Otherwise, compute from CT marks
    final marks = <double>[];
    for (final ct in cts.values) {
      if (ct.marks.containsKey(studentUid)) {
        marks.add(ct.marks[studentUid]!);
      }
    }
    marks.sort((a, b) => b.compareTo(a)); // descending
    return marks.take(bestOfCount).fold<double>(0, (sum, m) => sum + m);
  }
}