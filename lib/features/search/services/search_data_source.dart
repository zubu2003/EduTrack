import 'package:edutrack/data/repositories/attendance/attendance_repository.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/ct_alert_repository.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/data/repositories/routine/routine_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/ct_alert_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/routine_model.dart';

abstract class SearchDataSource {
  Future<UserModel?> getCurrentUser();

  Future<List<CourseModel>> getAuthorizedCourses({
    required String uid,
    required String role,
  });

  Future<List<Map<String, dynamic>>> getStudentAttendance({
    required String courseId,
    required String studentUid,
    String? studentCode,
  });

  Future<CtDataModel?> getCtData(String courseId);

  Future<List<RoutineModel>> getUserRoutines(String uid);

  Future<List<CtAlertModel>> getCourseAlerts(String courseId);
}

class FirestoreSearchDataSource implements SearchDataSource {
  @override
  Future<UserModel?> getCurrentUser() =>
      UserRepository.instance.getCurrentUserData();

  @override
  Future<List<CourseModel>> getAuthorizedCourses({
    required String uid,
    required String role,
  }) {
    return role == 'teacher'
        ? CourseRepository.instance.getTeacherCourses(uid)
        : CourseRepository.instance.getStudentCourses(uid);
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentAttendance({
    required String courseId,
    required String studentUid,
    String? studentCode,
  }) {
    return AttendanceRepository.instance.getStudentAttendance(
      courseId: courseId,
      studentUid: studentUid,
      studentCode: studentCode,
    );
  }

  @override
  Future<CtDataModel?> getCtData(String courseId) =>
      CtMarksRepository.instance.getCtData(courseId);

  @override
  Future<List<RoutineModel>> getUserRoutines(String uid) =>
      RoutineRepository.instance.getUserRoutines(uid);

  @override
  Future<List<CtAlertModel>> getCourseAlerts(String courseId) =>
      CtAlertRepository.instance.getCourseAlerts(courseId);
}
