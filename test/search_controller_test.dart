import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
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
    List<EnrollmentModel>? enrolledStudents,
    List<AttendanceSessionModel>? attendanceSessions,
    List<RoutineModel>? routines,
    String role = 'student',
  }) {
    return FakeSearchDataSource(
      user: user,
      courses: courses ?? [course],
      attendance: attendance ?? const [],
      ctData: ctData,
      failure: failure,
      alerts: alerts ?? const [],
      enrolledStudents: enrolledStudents ?? const [],
      attendanceSessions: attendanceSessions ?? const [],
      routines: routines ?? const [],
      role: role,
    );
  }

  String response(String collection, List<Map<String, dynamic>> filters) {
    return '{"collection":"$collection","filters":${_encode(filters)},"sort":null,"limit":20,"humanReadable":"Academic search"}';
  }

  String responseWithIntent(
    String intent,
    String collection,
    List<Map<String, dynamic>> filters,
  ) {
    return '{"intent":"$intent","collection":"$collection","filters":${_encode(filters)},"sort":null,"limit":20,"humanReadable":"Academic search"}';
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

  test('teacher can ask how many CTs happened for a course', () async {
    final ctData = CtDataModel(
      courseId: course.courseId,
      fullMarks: 20,
      bestOfCount: 3,
      totalCTs: 4,
      cts: {
        'CT-1': CtModel(
          ctTitle: 'CT-1',
          date: '2026-09-01',
          status: 'published',
          marks: {},
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        'CT-2': CtModel(
          ctTitle: 'CT-2',
          date: '2026-09-10',
          status: 'published',
          marks: {},
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      },
      totals: {},
      updatedAt: DateTime(2026),
    );
    final controller = AppSearchController(
      role: 'teacher',
      dataSource: source(
        ctData: ctData,
        role: 'teacher',
        enrolledStudents: [
          _enrollment('student-present', 'Present Student'),
          _enrollment('student-absent', 'Absent Student'),
        ],
      ),
      askAi: (_) async => fail('Teacher CT count should be deterministic'),
    );

    await controller.runNaturalLanguageSearch('How many CSE-321 CT happened?');

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.subtitle, '2 CTs happened');
  });

  test('teacher can ask for the next class', () async {
    final controller = AppSearchController(
      role: 'teacher',
      dataSource: source(
        role: 'teacher',
        routines: [
          RoutineModel(
            routineId: 'routine-1',
            ownerId: user.uid,
            ownerRole: 'teacher',
            courseId: course.courseId,
            courseCode: course.courseCode,
            courseName: course.courseName,
            day: _todayDay(),
            startTime: _futureTime(),
            endTime: _futureTime(),
            room: 'Room 201',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      ),
      askAi: (_) async => fail('Next class should be resolved locally'),
    );

    await controller.runNaturalLanguageSearch('What is my next class?');

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.title, 'Mathematics');
    expect(controller.results.single.detail, 'Room 201');
  });

  test('teacher can find students absent from a specific CT', () async {
    final ctData = CtDataModel(
      courseId: course.courseId,
      fullMarks: 20,
      bestOfCount: 3,
      totalCTs: 4,
      cts: {
        'CT-1': CtModel(
          ctTitle: 'CT-1',
          date: '2026-09-01',
          status: 'published',
          marks: {'student-present': 15, 'student-absent': -1},
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      },
      totals: {},
      updatedAt: DateTime(2026),
    );
    final controller = AppSearchController(
      role: 'teacher',
      dataSource: source(
        ctData: ctData,
        role: 'teacher',
        enrolledStudents: [
          _enrollment('student-present', 'Present Student'),
          _enrollment('student-absent', 'Absent Student'),
        ],
      ),
      askAi: (_) async => fail('Teacher CT absence should be deterministic'),
    );

    await controller.runNaturalLanguageSearch(
      'Which students did not attend CT 1 for CSE 321?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.title, 'Absent Student');
    expect(controller.results.single.subtitle, 'Did not attend CT-1');
    expect(controller.results.single.detail, contains('Student ID: 2204065'));
    expect(controller.results.single.detail, contains('Course Code: CSE-321'));
  });

  test(
    'teacher CT absence search scans all owned courses without a code',
    () async {
      final ctData = CtDataModel(
        courseId: course.courseId,
        fullMarks: 20,
        bestOfCount: 3,
        totalCTs: 4,
        cts: {
          'CT-1': CtModel(
            ctTitle: 'CT-1',
            date: '2026-09-01',
            status: 'published',
            marks: {'student-absent': -1},
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        },
        totals: {},
        updatedAt: DateTime(2026),
      );
      final secondCourse = course.copyWith(
        courseId: 'course-2',
        courseCode: 'CSE322',
        courseName: 'Physics',
      );
      final controller = AppSearchController(
        role: 'teacher',
        dataSource: source(
          role: 'teacher',
          courses: [course, secondCourse],
          ctData: ctData,
          enrolledStudents: [_enrollment('student-absent', 'Absent Student')],
        ),
        askAi: (_) async =>
            fail('All-course CT absence should be deterministic'),
      );

      await controller.runNaturalLanguageSearch(
        'Which students did not attend CT 1?',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results, hasLength(2));
      expect(controller.results[0].detail, contains('CSE-321'));
      expect(controller.results[1].detail, contains('CSE-322'));
    },
  );

  test('teacher absent CT query works without a CT number', () async {
    final ctData = CtDataModel(
      courseId: course.courseId,
      fullMarks: 20,
      bestOfCount: 3,
      totalCTs: 4,
      cts: {
        'CT-1': CtModel(
          ctTitle: 'CT-1',
          date: '2026-09-01',
          status: 'published',
          marks: {'student-present': 15, 'student-absent': -1},
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      },
      totals: {},
      updatedAt: DateTime(2026),
    );
    final controller = AppSearchController(
      role: 'teacher',
      dataSource: source(
        ctData: ctData,
        role: 'teacher',
        enrolledStudents: [
          _enrollment('student-present', 'Present Student'),
          _enrollment('student-absent', 'Absent Student'),
        ],
      ),
      askAi: (_) async => fail('Absent CT queries should be resolved locally'),
    );

    await controller.runNaturalLanguageSearch(
      'Which student absent on CSE 321 CT?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.title, 'Absent Student');
    expect(controller.results.single.subtitle, 'Absent from CT-1');
  });

  test(
    'teacher class absence query works without today-only wording',
    () async {
      final controller = AppSearchController(
        role: 'teacher',
        dataSource: source(
          role: 'teacher',
          attendance: const [],
          enrolledStudents: [_enrollment('student-absent', 'Absent Student')],
          attendanceSessions: [
            _attendanceSession(
              courseId: course.courseId,
              date: '2026-09-20',
              studentId: 'student-absent',
              status: 'absent',
            ),
          ],
        ),
        askAi: (_) async => fail('Teacher class absence should be local'),
      );

      await controller.runNaturalLanguageSearch(
        'Which students did not attend class CSE 321?',
      );

      expect(controller.errorMessage.value, isNull);
      expect(controller.results.single.title, 'Absent Student');
      expect(controller.results.single.subtitle, contains('Missed class'));
    },
  );

  test('teacher can find the highest mark for CT-1 in a course', () async {
    final ctData = CtDataModel(
      courseId: course.courseId,
      fullMarks: 20,
      bestOfCount: 3,
      totalCTs: 4,
      cts: {
        'CT-1': CtModel(
          ctTitle: 'CT-1',
          date: '2026-09-01',
          status: 'published',
          marks: {'student-present': 18, 'student-absent': 15},
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      },
      totals: {},
      updatedAt: DateTime(2026),
    );
    final controller = AppSearchController(
      role: 'teacher',
      dataSource: source(
        role: 'teacher',
        ctData: ctData,
        enrolledStudents: [
          _enrollment('student-present', 'Top Student'),
          _enrollment('student-absent', 'Other Student'),
        ],
      ),
      askAi: (_) async => responseWithIntent('ct_highest_mark', 'ct_marks', [
        {'field': 'courseCode', 'op': '==', 'value': 'CSE-321'},
        {'field': 'ctTitle', 'op': '==', 'value': 'CT 1'},
      ]),
    );

    await controller.runNaturalLanguageSearch(
      'Which student got highest mark in CT 1 in CSE 321?',
    );

    expect(controller.errorMessage.value, isNull);
    expect(controller.results.single.title, 'Top Student');
    expect(controller.results.single.subtitle, 'Highest mark: 18.0 / 20.0');
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

AttendanceSessionModel _attendanceSession({
  required String courseId,
  required String date,
  required String studentId,
  required String status,
}) {
  return AttendanceSessionModel(
    sessionId: date,
    courseId: courseId,
    date: date,
    lecture: 'Lecture',
    totalStudents: 1,
    presentCount: status == 'present' ? 1 : 0,
    absentCount: status == 'absent' ? 1 : 0,
    records: [
      AttendanceRecordModel(
        studentId: studentId,
        studentName: 'Student',
        studentCode: '2204065',
        status: status,
      ),
    ],
    createdAt: DateTime(2026, 9, 20),
    updatedAt: DateTime(2026, 9, 20),
  );
}

EnrollmentModel _enrollment(
  String studentId,
  String studentName, {
  String studentCode = '2204065',
}) {
  return EnrollmentModel(
    studentId: studentId,
    studentName: studentName,
    studentCode: studentCode,
    batch: '2024',
    department: 'CSE',
    roll: '1',
    section: 'A',
    enrolledAt: DateTime(2026),
  );
}

String _todayDay() {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[DateTime.now().weekday - 1];
}

String _futureTime() {
  final now = DateTime.now();
  if (now.hour == 23 && now.minute < 59) return '11:59 PM';
  final hour = now.hour + 1;
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$displayHour:00 $period';
}

class FakeSearchDataSource implements SearchDataSource {
  final UserModel user;
  final List<CourseModel> courses;
  final List<Map<String, dynamic>> attendance;
  final CtDataModel? ctData;
  final Object? failure;
  final List<CtAlertModel> alerts;
  final List<EnrollmentModel> enrolledStudents;
  final List<AttendanceSessionModel> attendanceSessions;
  final List<RoutineModel> routines;
  final String role;

  FakeSearchDataSource({
    required this.user,
    required this.courses,
    required this.attendance,
    required this.ctData,
    required this.failure,
    required this.alerts,
    required this.enrolledStudents,
    required this.attendanceSessions,
    required this.routines,
    required this.role,
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
    expect(role, this.role);
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
  Future<List<EnrollmentModel>> getEnrolledStudents(String courseId) async {
    _throwIfNeeded();
    return enrolledStudents;
  }

  @override
  Future<List<AttendanceSessionModel>> getAttendanceSessions(
    String courseId,
  ) async {
    _throwIfNeeded();
    return attendanceSessions;
  }

  @override
  Future<List<RoutineModel>> getUserRoutines(String uid) async {
    _throwIfNeeded();
    return routines;
  }

  @override
  Future<List<CtAlertModel>> getCourseAlerts(String courseId) async {
    _throwIfNeeded();
    return alerts;
  }
}
