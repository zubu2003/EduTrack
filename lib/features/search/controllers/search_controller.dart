import 'dart:convert';

import 'package:get/get.dart';
import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/data/services/ai/ai_service.dart';
import 'package:edutrack/data/services/ai/prompt_templates.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/search/models/search_query_model.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class AppSearchController extends GetxController {
  final String role;

  AppSearchController({required this.role});

  final query = ''.obs;
  final results = <SearchResultModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final explanation = RxnString();

  Future<void> runQuickSearch(String action) async {
    await _run(() async {
      explanation.value = action;
      final user = await _currentUser();
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
          final courses = role == 'student'
              ? await CourseRepository.instance.getStudentCourses(user.uid)
              : await CourseRepository.instance.getTeacherCourses(user.uid);
          return courses
              .map(
                (course) => SearchResultModel(
                  title: course.courseName,
                  subtitle: course.courseCode,
                  detail: role == 'student'
                      ? 'Open CT Alerts to view upcoming assessments'
                      : '${course.totalStudents} enrolled students',
                ),
              )
              .toList();
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
      final response = await AIService.instance.ask(
        SPromptTemplates.nlSearch(role: role, query: query.value),
      );
      final decoded = _decodeResponse(response);
      final request = SearchQueryModel.fromJson(decoded, role: role);
      explanation.value = request.humanReadable;
      return _executeValidatedQuery(request);
    });
  }

  Future<void> _run(Future<List<SearchResultModel>> Function() action) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      results.clear();
      results.assignAll(await action());
    } catch (e) {
      errorMessage.value = e.toString();
      SSnackBarHelpers.errorSnackBar(
        title: 'Search error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> _currentUser() =>
      UserRepository.instance.getCurrentUserData();

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
    final user = await _currentUser();
    if (user == null) return [];
    if (request.collection == SearchCollection.courses) {
      final courses = role == 'teacher'
          ? await CourseRepository.instance.getTeacherCourses(user.uid)
          : await CourseRepository.instance.getStudentCourses(user.uid);
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
    }
    throw const FormatException(
      'This natural-language search is not supported yet',
    );
  }

  bool _courseMatches(CourseModel course, List<SearchFilterModel> filters) {
    for (final filter in filters) {
      final actual = switch (filter.field) {
        'courseName' => course.courseName,
        'courseCode' => course.courseCode,
        'batch' => course.batch,
        'department' => course.department,
        _ => null,
      };
      if (actual == null || !_matches(actual.toString(), filter)) return false;
    }
    return true;
  }

  bool _matches(String actual, SearchFilterModel filter) {
    final expected = filter.value.toString().toLowerCase();
    final value = actual.toLowerCase();
    return switch (filter.operator) {
      SearchOperator.equals => value == expected,
      SearchOperator.notEquals => value != expected,
      _ => throw const FormatException(
        'Numeric filters are not supported for courses',
      ),
    };
  }

  Map<String, dynamic> _decodeResponse(String response) {
    final clean = response.trim();
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
