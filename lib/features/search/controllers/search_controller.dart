import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/search/models/search_query_model.dart';
import 'package:edutrack/features/search/services/search_data_source.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class AppSearchController extends GetxController {
  final String role;
  final SearchDataSource _dataSource;
  final Future<String> Function(String prompt) _askAi;

  AppSearchController({
    required this.role,
    SearchDataSource? dataSource,
    Future<String> Function(String prompt)? askAi,
  }) : _dataSource = dataSource ?? FirestoreSearchDataSource(),
       _askAi = askAi ?? ((prompt) => AIService.instance.ask(prompt));

  final query = ''.obs;
  final results = <SearchResultModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final explanation = RxnString();

  Future<void> runQuickSearch(String action) async {
    await _run(() async {
      explanation.value = action;
      final user = await _dataSource.getCurrentUser();
      if (user == null) return [];

      switch (action) {
        case 'My Attendance':
          final courses = await CourseRepository.instance.getStudentCourses(
            user.uid,
          );
          final output = <SearchResultModel>[];
          for (final course in courses) {
            final records = await AttendanceRepository.instance
                .getStudentAttendance(
                  courseId: course.courseId,
                  studentUid: user.uid,
                  studentCode: user.studentId,
                );
            final attended = records
                .where(
                  (record) =>
                      record['status'] == 'present' ||
                      record['status'] == 'late',
                )
                .length;
            final percent = records.isEmpty
                ? 0
                : attended / records.length * 100;
            output.add(
              SearchResultModel(
                title: course.courseName,
                subtitle: '${percent.toStringAsFixed(1)}% attendance',
                detail: '${records.length} recorded sessions',
              ),
            );
          }
          return output;
        case 'My CT Marks':
          final courses = await CourseRepository.instance.getStudentCourses(
            user.uid,
          );
          return _studentCtResults(courses, user);
        case 'Upcoming CTs':
          final courses = await _dataSource.getAuthorizedCourses(
            uid: user.uid,
            role: role,
          );
          return _upcomingCtResults(courses);
        case 'My Courses':
          final courses = await CourseRepository.instance.getStudentCourses(
            user.uid,
          );
          return courses
              .map(
                (course) => SearchResultModel(
                  title: course.courseName,
                  subtitle: course.courseCode,
                  detail: 'Batch ${course.batch} • Section ${course.section}',
                ),
              )
              .toList();
        case 'My Routine':
          final routines = await RoutineRepository.instance.getUserRoutines(
            user.uid,
          );
          return routines
              .map(
                (routine) => SearchResultModel(
                  title: routine.courseName,
                  subtitle:
                      '${routine.day} • ${routine.startTime} - ${routine.endTime}',
                  detail: routine.room,
                ),
              )
              .toList();
        case "Today's Attendance":
          final courses = await CourseRepository.instance.getTeacherCourses(
            user.uid,
          );
          final output = <SearchResultModel>[];
          for (final course in courses) {
            final session = await AttendanceRepository.instance.getTodaySession(
              course.courseId,
            );
            if (session == null) continue;
            final percent = session.totalStudents == 0
                ? 0
                : session.presentCount / session.totalStudents * 100;
            output.add(
              SearchResultModel(
                title: course.courseName,
                subtitle: '${percent.toStringAsFixed(1)}% attendance today',
                detail:
                    '${session.presentCount}/${session.totalStudents} present',
              ),
            );
          }
          return output;
        case 'Low Attendance Students':
          return _teacherLowAttendance(user);
        case 'Recent CT Performance':
          return _teacherCtPerformance(user);
        case 'Students Who Missed Classes':
          return _teacherMissedClasses(user);
        default:
          throw const FormatException('Unsupported quick search');
      }
    });
  }

  Future<void> runNaturalLanguageSearch(String text) async {
    query.value = text.trim();
    if (query.value.isEmpty) return;

    await _run(() async {
      final directCtResults = await _searchUpcomingCtDate(query.value);
      if (directCtResults != null) {
        explanation.value = 'Upcoming CT dates matching your query';
        return directCtResults;
      }

      final directAttendanceResults = await _searchDirectAttendanceQuery(
        query.value,
      );
      if (directAttendanceResults != null) {
        explanation.value = 'Attendance results matching your query';
        return directAttendanceResults;
      }

      final response = await _askAi(
        SPromptTemplates.nlSearch(role: role, query: query.value),
      );
      final decoded = _decodeResponse(response);
      final request = SearchQueryModel.fromJson(decoded, role: role);
      explanation.value = request.humanReadable;
      return _executeValidatedQuery(request);
    });
  }

  Future<List<SearchResultModel>?> _searchUpcomingCtDate(String text) async {
    final normalized = text.toLowerCase();
    if (!normalized.contains('ct') ||
        (!normalized.contains('date') && !normalized.contains('next'))) {
      return null;
    }

    final courseCodeMatch = RegExp(
      r'\b[a-z]{2,5}[- ]?\d{3}\b',
      caseSensitive: false,
    ).firstMatch(text);
    final requestedCode = courseCodeMatch
        ?.group(0)
        ?.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();

    final user = await _dataSource.getCurrentUser();
    if (user == null) return <SearchResultModel>[];
    final courses = await _dataSource.getAuthorizedCourses(
      uid: user.uid,
      role: role,
    );
    final matchingCourses = requestedCode == null
        ? courses
        : courses.where((course) {
            final code = course.courseCode
                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                .toLowerCase();
            return code == requestedCode;
          }).toList();

    final output = <SearchResultModel>[];
    for (final course in matchingCourses) {
      final alerts = await _dataSource.getCourseAlerts(course.courseId);
      for (final alert in alerts.take(1)) {
        output.add(
          SearchResultModel(
            title: '${alert.ctTitle} • ${course.courseName}',
            subtitle: alert.formattedDate,
            detail: alert.daysRemaining == 0
                ? 'Today'
                : '${alert.daysRemaining} days remaining',
          ),
        );
      }
    }
    return output;
  }

  Future<List<SearchResultModel>?> _searchDirectAttendanceQuery(
    String text,
  ) async {
    if (role != 'student') return null;
    final normalized = text.toLowerCase();
    final asksAttendance =
        normalized.contains('attendance') ||
        normalized.contains('present') ||
        normalized.contains('attend') ||
        normalized.contains('class count') ||
        normalized.contains('total class') ||
        normalized.contains('class happened') ||
        normalized.contains('classes happened') ||
        normalized.contains('class happend') ||
        normalized.contains('classes happend') ||
        normalized.contains('how many class');
    if (!asksAttendance) return null;

    final courseCodeMatch = RegExp(
      r'\b[a-z]{2,5}[- ]?\d{3}\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (courseCodeMatch == null) return null;

    final filters = <SearchFilterModel>[
      SearchFilterModel(
        field: 'courseCode',
        operator: SearchOperator.equals,
        value: courseCodeMatch.group(0),
      ),
    ];
    final dateMatch = RegExp(
      r'\b\d{1,2}\s+(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:t|tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:\s+\d{4})?\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (dateMatch != null) {
      filters.add(
        SearchFilterModel(
          field: 'date',
          operator: SearchOperator.equals,
          value: dateMatch.group(0),
        ),
      );
    }

    final user = await _dataSource.getCurrentUser();
    if (user == null) return <SearchResultModel>[];
    final request = SearchQueryModel(
      collection: SearchCollection.attendance,
      filters: filters,
      sortField: null,
      sortDirection: null,
      limit: 20,
      humanReadable: 'Attendance results matching your query',
    );
    final courses = await _dataSource.getAuthorizedCourses(
      uid: user.uid,
      role: role,
    );
    return _searchAttendance(user: user, courses: courses, request: request);
  }

  Future<List<SearchResultModel>> _upcomingCtResults(
    List<CourseModel> courses,
  ) async {
    final output = <SearchResultModel>[];
    for (final course in courses) {
      final alerts = await _dataSource.getCourseAlerts(course.courseId);
      for (final alert in alerts) {
        if (alert.daysRemaining < 0) continue;
        output.add(
          SearchResultModel(
            title: '${alert.ctTitle} • ${course.courseName}',
            subtitle: alert.formattedDate,
            detail: alert.daysRemaining == 0
                ? 'Today'
                : '${alert.daysRemaining} days remaining',
          ),
        );
      }
    }
    return output;
  }

  Future<void> _run(Future<List<SearchResultModel>> Function() action) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      results.clear();
      results.assignAll(await action());
    } catch (e) {
      final message = _friendlyError(e);
      errorMessage.value = message;
      SSnackBarHelpers.errorSnackBar(title: 'Search error', message: message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<SearchResultModel>> _studentCtResults(
    List<CourseModel> courses,
    UserModel user,
  ) async {
    final output = <SearchResultModel>[];
    for (final course in courses) {
      final data = await CtMarksRepository.instance.getCtData(course.courseId);
      if (data == null) continue;
      final marks = data.numericMarksFor(user.uid);
      final average = marks.isEmpty
          ? 0
          : marks.reduce((a, b) => a + b) / marks.length;
      output.add(
        SearchResultModel(
          title: course.courseName,
          subtitle: '${average.toStringAsFixed(1)} / ${data.fullMarks}',
          detail: '${marks.length} CT marks available',
        ),
      );
    }
    return output;
  }

  Future<List<SearchResultModel>> _teacherLowAttendance(UserModel user) async {
    final courses = await CourseRepository.instance.getTeacherCourses(user.uid);
    final output = <SearchResultModel>[];
    for (final course in courses) {
      final students = await AttendanceRepository.instance.getEnrolledStudents(
        course.courseId,
      );
      final sessions = await AttendanceRepository.instance.getSessions(
        course.courseId,
      );
      for (final student in students) {
        final records = sessions
            .expand((session) => session.records)
            .where((record) => record.studentId == student.studentId)
            .toList();
        if (records.isEmpty) continue;
        final attended = records
            .where(
              (record) => record.status == 'present' || record.status == 'late',
            )
            .length;
        final percent = attended / records.length * 100;
        if (percent < 75) {
          output.add(
            SearchResultModel(
              title: student.studentName,
              subtitle: '${percent.toStringAsFixed(1)}% • ${course.courseCode}',
              detail: student.studentCode,
            ),
          );
        }
      }
    }
    return output;
  }

  Future<List<SearchResultModel>> _teacherCtPerformance(UserModel user) async {
    final courses = await CourseRepository.instance.getTeacherCourses(user.uid);
    final output = <SearchResultModel>[];
    for (final course in courses) {
      final data = await CtMarksRepository.instance.getCtData(course.courseId);
      if (data == null) continue;
      final marks = data.cts.values
          .expand((ct) => ct.marks.values)
          .where((mark) => !CtMark.isAbsent(mark))
          .toList();
      if (marks.isEmpty) continue;
      final average = marks.reduce((a, b) => a + b) / marks.length;
      output.add(
        SearchResultModel(
          title: course.courseName,
          subtitle: '${average.toStringAsFixed(1)} / ${data.fullMarks}',
          detail: 'Recent recorded CT performance',
        ),
      );
    }
    return output;
  }

  Future<List<SearchResultModel>> _teacherMissedClasses(UserModel user) async {
    final courses = await CourseRepository.instance.getTeacherCourses(user.uid);
    final output = <SearchResultModel>[];
    for (final course in courses) {
      final students = await AttendanceRepository.instance.getEnrolledStudents(
        course.courseId,
      );
      final sessions = await AttendanceRepository.instance.getSessions(
        course.courseId,
      );
      for (final student in students) {
        final missed = sessions
            .where(
              (session) => session.records.any(
                (record) =>
                    record.studentId == student.studentId &&
                    record.status == 'absent',
              ),
            )
            .length;
        if (missed > 0) {
          output.add(
            SearchResultModel(
              title: student.studentName,
              subtitle: '$missed missed classes • ${course.courseCode}',
              detail: student.studentCode,
            ),
          );
        }
      }
    }
    return output;
  }

  Future<List<SearchResultModel>> _executeValidatedQuery(
    SearchQueryModel request,
  ) async {
    final user = await _dataSource.getCurrentUser();
    if (user == null) return [];

    final courses = await _dataSource.getAuthorizedCourses(
      uid: user.uid,
      role: role,
    );

    switch (request.collection) {
      case SearchCollection.courses:
        return courses
            .where((course) => _courseMatches(course, request.filters))
            .take(request.limit)
            .map(
              (course) => SearchResultModel(
                title: course.courseName,
                subtitle: course.courseCode,
                detail: 'Batch ${course.batch} • Section ${course.section}',
              ),
            )
            .toList();
      case SearchCollection.attendance:
        return _searchAttendance(
          user: user,
          courses: courses,
          request: request,
        );
      case SearchCollection.ctMarks:
        return _searchCtMarks(user: user, courses: courses, request: request);
      case SearchCollection.routines:
        return _searchRoutines(user.uid, request);
      case SearchCollection.users:
        throw const FormatException(
          'Searching users is not supported for this account',
        );
    }
  }

  Future<List<SearchResultModel>> _searchAttendance({
    required UserModel user,
    required List<CourseModel> courses,
    required SearchQueryModel request,
  }) async {
    if (role != 'student') {
      throw const FormatException(
        'Attendance questions for other students are not supported',
      );
    }

    final output = <SearchResultModel>[];
    for (final course in _matchingCourses(courses, request.filters)) {
      final records = await _dataSource.getStudentAttendance(
        courseId: course.courseId,
        studentUid: user.uid,
        studentCode: user.studentId,
      );
      final matchingRecords = records
          .where((record) => _attendanceMatches(record, request.filters))
          .toList();
      if (matchingRecords.isEmpty) continue;

      final attended = matchingRecords
          .where(
            (record) =>
                record['status'] == 'present' || record['status'] == 'late',
          )
          .length;
      final percentage = attended / matchingRecords.length * 100;
      final hasDateFilter = request.filters.any(
        (filter) => filter.field == 'date',
      );
      final hasStatusFilter = request.filters.any(
        (filter) => filter.field == 'status',
      );
      final status = matchingRecords.first['status']?.toString() ?? 'unknown';
      final subtitle = hasDateFilter
          ? _attendanceStatusText(status)
          : hasStatusFilter
          ? '${matchingRecords.length} matching classes'
          : '${matchingRecords.length} classes recorded';
      output.add(
        SearchResultModel(
          title: course.courseName,
          subtitle: subtitle,
          detail: hasDateFilter
              ? 'Attendance on ${matchingRecords.first['date']}'
              : hasStatusFilter
              ? '${percentage.toStringAsFixed(1)}% attendance'
              : '$attended/${matchingRecords.length} sessions attended',
          highlightSubtitle: hasDateFilter,
        ),
      );
      if (output.length == request.limit) break;
    }
    return output;
  }

  Future<List<SearchResultModel>> _searchCtMarks({
    required UserModel user,
    required List<CourseModel> courses,
    required SearchQueryModel request,
  }) async {
    if (role != 'student') {
      throw const FormatException(
        'CT mark questions for other students are not supported',
      );
    }

    final output = <SearchResultModel>[];
    for (final course in _matchingCourses(courses, request.filters)) {
      final data = await _dataSource.getCtData(course.courseId);
      if (data == null) continue;

      final matchingCts = data.cts.values.where((ct) {
        final mark = ct.marks[user.uid];
        if (mark == null || CtMark.isAbsent(mark)) return false;
        return request.filters
            .where(
              (filter) => filter.field == 'ctTitle' || filter.field == 'mark',
            )
            .every(
              (filter) => filter.field == 'ctTitle'
                  ? _matchesCtTitle(ct.ctTitle, filter)
                  : _matchesNumber(mark, filter),
            );
      }).toList();
      if (matchingCts.isEmpty) continue;

      for (final ct in matchingCts) {
        final mark = ct.marks[user.uid]!;
        output.add(
          SearchResultModel(
            title: '${course.courseName} • ${ct.ctTitle}',
            subtitle: '${mark.toStringAsFixed(1)} / ${data.fullMarks}',
            detail: course.courseCode,
            highlightSubtitle: true,
          ),
        );
        if (output.length == request.limit) return output;
      }
    }
    return output;
  }

  Future<List<SearchResultModel>> _searchRoutines(
    String uid,
    SearchQueryModel request,
  ) async {
    final routines = await _dataSource.getUserRoutines(uid);
    return routines
        .where((routine) {
          for (final filter in request.filters) {
            final actual = switch (filter.field) {
              'day' => routine.day,
              'courseName' => routine.courseName,
              'courseCode' => routine.courseCode,
              'room' => routine.room,
              _ => null,
            };
            if (actual == null || !_matches(actual, filter)) return false;
          }
          return true;
        })
        .take(request.limit)
        .map(
          (routine) => SearchResultModel(
            title: routine.courseName,
            subtitle:
                '${routine.day} • ${routine.startTime} - ${routine.endTime}',
            detail: routine.room,
          ),
        )
        .toList();
  }

  List<CourseModel> _matchingCourses(
    List<CourseModel> courses,
    List<SearchFilterModel> filters,
  ) {
    return courses.where((course) => _courseMatches(course, filters)).toList();
  }

  bool _attendanceMatches(
    Map<String, dynamic> record,
    List<SearchFilterModel> filters,
  ) {
    for (final filter in filters) {
      if (filter.field != 'status' && filter.field != 'date') continue;
      final actual = record[filter.field];
      if (actual == null) return false;
      final matches = filter.field == 'date'
          ? _matchesAttendanceDate(actual.toString(), filter)
          : _matches(actual.toString(), filter);
      if (!matches) return false;
    }
    return true;
  }

  String _attendanceStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return 'Present';
      case 'late':
        return 'Late, counted present';
      case 'absent':
        return 'Absent';
      default:
        return status;
    }
  }

  bool _matchesAttendanceDate(String actual, SearchFilterModel filter) {
    final expected = _parseSearchDate(filter.value.toString());
    final parsedActual = _parseSearchDate(actual);
    if (expected == null || parsedActual == null) {
      return _matches(actual, filter);
    }

    final sameDate =
        parsedActual.year == expected.year &&
        parsedActual.month == expected.month &&
        parsedActual.day == expected.day;
    return switch (filter.operator) {
      SearchOperator.equals => sameDate,
      SearchOperator.notEquals => !sameDate,
      _ => false,
    };
  }

  DateTime? _parseSearchDate(String value) {
    final trimmed = value.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;

    final match = RegExp(
      r'^(\d{1,2})\s+([a-zA-Z]+)(?:\s+(\d{4}))?$',
    ).firstMatch(trimmed);
    if (match == null) return null;

    const months = {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'sept': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    };
    final month = months[match.group(2)!.toLowerCase()];
    if (month == null) return null;
    final year = int.tryParse(match.group(3) ?? '') ?? DateTime.now().year;
    final day = int.tryParse(match.group(1)!);
    if (day == null) return null;
    return DateTime(year, month, day);
  }

  bool _courseMatches(CourseModel course, List<SearchFilterModel> filters) {
    for (final filter in filters) {
      if (filter.field != 'courseName' &&
          filter.field != 'courseCode' &&
          filter.field != 'batch' &&
          filter.field != 'department') {
        continue;
      }
      final actual = switch (filter.field) {
        'courseName' => course.courseName,
        'courseCode' => course.courseCode,
        'batch' => course.batch,
        'department' => course.department,
        _ => null,
      };
      if (actual == null) return false;
      final matches = filter.field == 'courseCode'
          ? _matchesCourseCode(actual, filter)
          : _matches(actual.toString(), filter);
      if (!matches) return false;
    }
    return true;
  }

  bool _matches(String actual, SearchFilterModel filter) {
    final expected = filter.value.toString().toLowerCase();
    final value = actual.toLowerCase();
    return switch (filter.operator) {
      SearchOperator.equals => value == expected,
      SearchOperator.notEquals => value != expected,
      _ => _matchesNumber(double.tryParse(actual), filter),
    };
  }

  bool _matchesCtTitle(String actual, SearchFilterModel filter) {
    final normalizedActual = _normalizeCtTitle(actual);
    final normalizedExpected = _normalizeCtTitle(filter.value.toString());
    return switch (filter.operator) {
      SearchOperator.equals => normalizedActual == normalizedExpected,
      SearchOperator.notEquals => normalizedActual != normalizedExpected,
      _ => false,
    };
  }

  bool _matchesCourseCode(String actual, SearchFilterModel filter) {
    final normalizedActual = _normalizeCourseCode(actual);
    final normalizedExpected = _normalizeCourseCode(filter.value.toString());
    return switch (filter.operator) {
      SearchOperator.equals => normalizedActual == normalizedExpected,
      SearchOperator.notEquals => normalizedActual != normalizedExpected,
      _ => false,
    };
  }

  String _normalizeCtTitle(String value) {
    final normalized = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (RegExp(r'^\d+$').hasMatch(normalized)) return 'ct$normalized';
    final match = RegExp(r'ct(\d+)').firstMatch(normalized);
    return match == null ? normalized : 'ct${match.group(1)}';
  }

  String _normalizeCourseCode(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  bool _matchesNumber(num? actual, SearchFilterModel filter) {
    final expected = num.tryParse(filter.value.toString());
    if (actual == null || expected == null) return false;
    return switch (filter.operator) {
      SearchOperator.equals => actual == expected,
      SearchOperator.notEquals => actual != expected,
      SearchOperator.greaterThan => actual > expected,
      SearchOperator.lessThan => actual < expected,
      SearchOperator.greaterOrEqual => actual >= expected,
      SearchOperator.lessOrEqual => actual <= expected,
    };
  }

  String _friendlyError(Object error) {
    final raw = error.toString().toLowerCase();
    if (raw.contains('students cannot search') ||
        raw.contains('unsupported search') ||
        raw.contains('not supported') ||
        raw.contains('invalid search')) {
      return 'I could not match that question to an available academic search.';
    }
    if (raw.contains('permission-denied') ||
        raw.contains('unauthorized') ||
        raw.contains('permission denied')) {
      return 'You do not have permission to view that academic data.';
    }
    if (raw.contains('network') ||
        raw.contains('timeout') ||
        raw.contains('unable to resolve') ||
        raw.contains('unavailable') ||
        raw.contains('connection')) {
      return 'The search service is unavailable. Check your connection and try again.';
    }
    if (raw.contains('ai search response') ||
        raw.contains('json') ||
        raw.contains('format')) {
      return 'I could not understand the search response. Please rephrase the question.';
    }
    return 'Something went wrong while searching. Please try again.';
  }

  Map<String, dynamic> _decodeResponse(String response) {
    final clean = response.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'no response generated') {
      throw const FormatException(
        'No response was generated. Try a quick search or rephrase your query.',
      );
    }
    final start = clean.indexOf('{');
    final end = clean.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const FormatException('AI search response did not contain JSON');
    }
    final decoded = jsonDecode(clean.substring(start, end + 1));
    if (decoded is! Map) {
      throw const FormatException('AI search response was invalid');
    }
    return Map<String, dynamic>.from(decoded);
  }
}
