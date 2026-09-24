import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/features/search/controllers/search_controller.dart';
import 'package:edutrack/features/search/services/search_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final course = CourseModel(
    courseId: 'course-1',
    courseCode: 'CSE321',
    courseName: 'Mathematics',
    credit: 3,
    batch: '2024',
    department: 'CSE',
    startRoll: 1,
    maxStudents: 40,
    section: 'A',
    teacherId: 'teacher-1',
    teacherName: 'Teacher',
    totalStudents: 2,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  final user = UserModel(
    uid: 'student-1',
    name: 'Student',
    email: 'student@example.com',
    phone: '',
    role: 'student',
    profileImage: '',
    studentId: 'CSE-2024-001',
    teacherId: '',
    department: 'CSE',
    batch: '2024',
    designation: '',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  SearchDataSource source({
    List<CourseModel>? courses,
    List<Map<String, dynamic>>? attendance,
    CtDataModel? ctData,
    Object? failure,
    List<CtAlertModel>? alerts,
  }) {
    return FakeSearchDataSource(
      user: user,
      courses: courses ?? [course],
      attendance: attendance ?? const [],
      ctData: ctData,
      failure: failure,
      alerts: alerts ?? const [],
    );
  }

  String response(String collection, List<Map<String, dynamic>> filters) {
    return '{"collection":"$collection","filters":${_encode(filters)},"sort":null,"limit":20,"humanReadable":"Academic search"}';
  }

  test(
    'answers a CT mark question using only the logged-in student mark',
    () async {
      final ctData = CtDataModel(
        courseId: course.courseId,
        fullMarks: 20,
        bestOfCount: 3,
        totalCTs: 4,
        cts: {
          'CT-3': CtModel(
            ctTitle: 'CT-3',
            date: '2026-09-01',
            status: 'published',
            marks: {'student-1': 18, 'student-2': 5},
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        },
        totals: {'student-1': 18, 'student-2': 5},
        updatedAt: DateTime(2026),
      );
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(ctData: ctData),
        askAi: (_) async => response('ct_marks', [
          {'field': 'courseCode', 'op': '==', 'value': 'CSE-321'},
          {'field': 'ctTitle', 'op': '==', 'value': '3'},
        ]),
      );

      await controller.runNaturalLanguageSearch(
        'What is my CT mark for Mathematics?',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results, hasLength(1));
      expect(controller.results.single.subtitle, '18.0 / 20.0');
      expect(controller.results.single.title, 'Mathematics • CT-3');
      expect(controller.results.single.highlightSubtitle, isTrue);
    },
  );

  test(
    'answers an attendance percentage question for a specific course',
    () async {
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(
          attendance: [
            {'date': '2026-09-20', 'status': 'present'},
            {'date': '2026-09-19', 'status': 'late'},
            {'date': '2026-09-18', 'status': 'absent'},
          ],
        ),
        askAi: (_) async => response('attendance', [
          {'field': 'courseCode', 'op': '==', 'value': 'CSE-321'},
        ]),
      );

      await controller.runNaturalLanguageSearch(
        'What is my attendance for CSE321?',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results.single.subtitle, '3 classes recorded');
      expect(controller.results.single.detail, '2/3 sessions attended');
    },
  );

  test(
    'answers whether the student was present on a natural-language date',
    () async {
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(
          attendance: [
            {'date': '22 Sep 2026', 'status': 'present'},
            {'date': '20 Sep 2026', 'status': 'absent'},
          ],
        ),
        askAi: (_) async => response('attendance', [
          {'field': 'courseCode', 'op': '==', 'value': 'CSE-321'},
          {'field': 'date', 'op': '==', 'value': '22 Sept 2026'},
        ]),
      );

      await controller.runNaturalLanguageSearch(
        'Did I present on 22 Sept on CSE-321?',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results.single.subtitle, 'Present');
      expect(controller.results.single.highlightSubtitle, isTrue);
    },
  );

  test('returns the total recorded class count for a course', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(
        attendance: [
          {'date': '2026-09-22', 'status': 'present'},
          {'date': '2026-09-20', 'status': 'absent'},
          {'date': '2026-09-18', 'status': 'late'},
        ],
      ),
      askAi: (_) async => response('attendance', [
        {'field': 'courseCode', 'op': '==', 'value': 'CSE 321'},
      ]),
    );

    await controller.runNaturalLanguageSearch(
      'How many classes happened on CSE 321?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.subtitle, '3 classes recorded');
    expect(controller.results.single.detail, '2/3 sessions attended');
  });

  test('handles the reported class-count typo without calling AI', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(
        attendance: [
          {'date': '2026-09-22', 'status': 'present'},
          {'date': '2026-09-20', 'status': 'absent'},
        ],
      ),
      askAi: (_) async => fail('Class count should be resolved locally'),
    );

    await controller.runNaturalLanguageSearch(
      'How many class happend on CSE 321?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.subtitle, '2 classes recorded');
  });

  test('quick Upcoming CTs returns actual CT alert details', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(
        alerts: [
          CtAlertModel(
            alertId: 'alert-1',
            courseId: course.courseId,
            courseName: course.courseName,
            ctTitle: 'CT-3',
            topics: 'Algebra',
            scheduledAt: DateTime.now().add(const Duration(days: 2)),
            durationMinutes: 60,
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      ),
    );

    await controller.runQuickSearch('Upcoming CTs');

    expect(controller.errorMessage.value, isNull);
    expect(controller.results, hasLength(1));
    expect(controller.results.single.title, 'CT-3 • Mathematics');
    expect(controller.results.single.detail, contains('days remaining'));
  });

  test(
    'resolves common attendance wording without requiring an AI response',
    () async {
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(
          attendance: [
            {'date': '22 Sep 2026', 'status': 'present'},
          ],
        ),
        askAi: (_) async =>
            fail('Direct attendance queries should not call AI'),
      );

      await controller.runNaturalLanguageSearch(
        'My attendance for CSE-321 on 22 Sept',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results.single.subtitle, 'Present');
    },
  );

  test('turns an unsupported question into a friendly error', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(),
      askAi: (_) async => response('attendance', [
        {'field': 'unknownField', 'op': '==', 'value': 'x'},
      ]),
    );

    await controller.runNaturalLanguageSearch('Who is the dean?');

    expect(
      controller.errorMessage.value,
      isNot(contains('unsupported search field')),
    );
    expect(controller.errorMessage.value, contains('could not match'));
  });

  test(
    'rejects student identity filters before any academic data is loaded',
    () async {
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(),
        askAi: (_) async => response('ct_marks', [
          {'field': 'studentId', 'op': '==', 'value': 'student-2'},
        ]),
      );

      await controller.runNaturalLanguageSearch('Show student-2 marks');

      expect(controller.errorMessage.value, contains('could not match'));
      expect(controller.errorMessage.value, isNot(contains('student-2')));
    },
  );

  test('keeps no-data searches in the empty state without an error', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(courses: const []),
      askAi: (_) async => response('ct_marks', [
        {'field': 'courseCode', 'op': '==', 'value': 'MTH999'},
      ]),
    );

    await controller.runNaturalLanguageSearch('What is my mark for MTH999?');

    expect(controller.errorMessage.value, isNull);
    expect(controller.results, isEmpty);
  });

  test(
    'translates network failures without exposing the raw exception',
    () async {
      final controller = AppSearchController(
        role: 'student',
        dataSource: source(
          failure: Exception('network timeout from Firestore'),
        ),
        askAi: (_) async => response('attendance', const []),
      );

      await controller.runNaturalLanguageSearch('What is my attendance?');

      expect(controller.errorMessage.value, contains('service is unavailable'));
      expect(controller.errorMessage.value, isNot(contains('Firestore')));
    },
  );

  test('preserves the existing upcoming CT date shortcut', () async {
    final controller = AppSearchController(
      role: 'student',
      dataSource: source(
        alerts: [
          CtAlertModel(
            alertId: 'alert-1',
            courseId: course.courseId,
            courseName: course.courseName,
            ctTitle: 'CT-3',
            topics: 'Algebra',
            scheduledAt: DateTime.now().add(const Duration(days: 2)),
            durationMinutes: 60,
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      ),
      askAi: (_) async => fail('AI should not be called for CT date lookup'),
    );

    await controller.runNaturalLanguageSearch(
      'What is the next CT date for CSE-321?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results, hasLength(1));
    expect(controller.results.single.title, 'CT-3 • Mathematics');
  });
}

String _encode(List<Map<String, dynamic>> values) {
  final encoded = values
      .map(
        (value) =>
            '{"field":"${value['field']}","op":"${value['op']}","value":"${value['value']}"}',
      )
      .join(',');
  return '[$encoded]';
}

class FakeSearchDataSource implements SearchDataSource {
  final UserModel user;
  final List<CourseModel> courses;
  final List<Map<String, dynamic>> attendance;
  final CtDataModel? ctData;
  final Object? failure;
  final List<CtAlertModel> alerts;

  FakeSearchDataSource({
    required this.user,
    required this.courses,
    required this.attendance,
    required this.ctData,
    required this.failure,
    required this.alerts,
  });

  void _throwIfNeeded() {
    if (failure != null) throw failure!;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    _throwIfNeeded();
    return user;
  }

  @override
  Future<List<CourseModel>> getAuthorizedCourses({
    required String uid,
    required String role,
  }) async {
    _throwIfNeeded();
    expect(uid, user.uid);
    expect(role, 'student');
    return courses;
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentAttendance({
    required String courseId,
    required String studentUid,
    String? studentCode,
  }) async {
    _throwIfNeeded();
    expect(studentUid, user.uid);
    expect(studentCode, user.studentId);
    return attendance;
  }

  @override
  Future<CtDataModel?> getCtData(String courseId) async {
    _throwIfNeeded();
    return ctData;
  }

  @override
  Future<List<RoutineModel>> getUserRoutines(String uid) async {
    _throwIfNeeded();
    return const [];
  }

  @override
  Future<List<CtAlertModel>> getCourseAlerts(String courseId) async {
    _throwIfNeeded();
    return alerts;
  }
}
