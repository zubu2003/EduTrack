enum SearchCollection { courses, attendance, ctMarks, routines, users }

enum SearchOperator {
  equals,
  notEquals,
  greaterThan,
  lessThan,
  greaterOrEqual,
  lessOrEqual,
}

enum SearchSortDirection { asc, desc }

class SearchFilterModel {
  final String field;
  final SearchOperator operator;
  final dynamic value;

  const SearchFilterModel({
    required this.field,
    required this.operator,
    required this.value,
  });
}

class SearchQueryModel {
  final String? intent;
  final SearchCollection collection;
  final List<SearchFilterModel> filters;
  final String? sortField;
  final SearchSortDirection? sortDirection;
  final int limit;
  final String humanReadable;

  const SearchQueryModel({
    this.intent,
    required this.collection,
    required this.filters,
    required this.sortField,
    required this.sortDirection,
    required this.limit,
    required this.humanReadable,
  });

  factory SearchQueryModel.fromJson(
    Map<String, dynamic> json, {
    required String role,
  }) {
    final intent = json['intent'];
    if (intent != null &&
        (intent is! String || !_allowedIntents.contains(intent))) {
      throw FormatException('Unsupported search intent: $intent');
    }
    final collection = _parseCollection(json['collection']);
    _authorizeCollection(collection, role);

    final rawFilters = json['filters'];
    if (rawFilters is! List) {
      throw const FormatException('Search filters are invalid');
    }

    final filters = rawFilters.map((raw) {
      if (raw is! Map) throw const FormatException('Search filter is invalid');
      final field = raw['field'];
      if (field is! String || !_allowedFields(collection).contains(field)) {
        throw FormatException('Unsupported search field: $field');
      }
      if (role == 'student' &&
          (collection == SearchCollection.attendance ||
              collection == SearchCollection.ctMarks) &&
          (field == 'studentId' || field == 'studentCode')) {
        throw const FormatException(
          'Students cannot search another student\'s academic data',
        );
      }
      return SearchFilterModel(
        field: field,
        operator: _parseOperator(raw['op']),
        value: raw['value'],
      );
    }).toList();

    final sort = json['sort'];
    String? sortField;
    SearchSortDirection? sortDirection;
    if (sort != null) {
      if (sort is! Map || sort['field'] is! String) {
        throw const FormatException('Search sort is invalid');
      }
      sortField = sort['field'] as String;
      if (!_allowedFields(collection).contains(sortField)) {
        throw FormatException('Unsupported sort field: $sortField');
      }
      sortDirection = _parseDirection(sort['direction']);
    }

    final rawLimit = json['limit'];
    final limit = rawLimit is num ? rawLimit.toInt() : 20;
    if (limit < 1 || limit > 50) {
      throw const FormatException('Search limit must be between 1 and 50');
    }

    final humanReadable = json['humanReadable'];
    if (humanReadable is! String || humanReadable.trim().isEmpty) {
      throw const FormatException('Search explanation is invalid');
    }

    return SearchQueryModel(
      intent: intent as String?,
      collection: collection,
      filters: filters,
      sortField: sortField,
      sortDirection: sortDirection,
      limit: limit,
      humanReadable: humanReadable.trim(),
    );
  }

  static const Set<String> _allowedIntents = {
    'course_search',
    'attendance_summary',
    'attendance_absentees',
    'ct_count',
    'ct_absentees',
    'ct_highest_mark',
    'academic_summary',
    'course_comparison',
    'routine_search',
    'upcoming_cts',
  };

  static SearchCollection _parseCollection(dynamic value) {
    switch (value) {
      case 'courses':
        return SearchCollection.courses;
      case 'attendance':
        return SearchCollection.attendance;
      case 'ct_marks':
        return SearchCollection.ctMarks;
      case 'routines':
        return SearchCollection.routines;
      case 'users':
        return SearchCollection.users;
      default:
        throw FormatException('Unsupported search collection: $value');
    }
  }

  static void _authorizeCollection(SearchCollection collection, String role) {
    if (role == 'student' && collection == SearchCollection.users) {
      throw const FormatException('Students cannot search users');
    }
  }

  static Set<String> _allowedFields(SearchCollection collection) {
    switch (collection) {
      case SearchCollection.courses:
        return {'courseName', 'courseCode', 'batch', 'department'};
      case SearchCollection.attendance:
        return {
          'courseName',
          'courseCode',
          'status',
          'date',
          'studentId',
          'studentCode',
        };
      case SearchCollection.ctMarks:
        return {
          'courseName',
          'courseCode',
          'studentId',
          'studentCode',
          'ctTitle',
          'mark',
        };
      case SearchCollection.routines:
        return {'day', 'courseName', 'courseCode', 'room'};
      case SearchCollection.users:
        return {'name', 'studentId', 'batch', 'department', 'role'};
    }
  }

  static SearchOperator _parseOperator(dynamic value) {
    switch (value) {
      case '==':
        return SearchOperator.equals;
      case '!=':
        return SearchOperator.notEquals;
      case '>':
        return SearchOperator.greaterThan;
      case '<':
        return SearchOperator.lessThan;
      case '>=':
        return SearchOperator.greaterOrEqual;
      case '<=':
        return SearchOperator.lessOrEqual;
      default:
        throw FormatException('Unsupported search operator: $value');
    }
  }

  static SearchSortDirection _parseDirection(dynamic value) {
    switch (value) {
      case 'asc':
        return SearchSortDirection.asc;
      case 'desc':
        return SearchSortDirection.desc;
      default:
        throw FormatException('Unsupported sort direction: $value');
    }
  }
}

class SearchResultModel {
  final String title;
  final String subtitle;
  final String? detail;
  final bool highlightSubtitle;

  const SearchResultModel({
    required this.title,
    required this.subtitle,
    this.detail,
    this.highlightSubtitle = false,
  });
}
