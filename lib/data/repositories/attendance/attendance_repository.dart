import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/attendance_record_model.dart';
import 'package:edutrack/features/course/models/attendance_session_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';

class AttendanceRepository extends GetxController {
  static AttendanceRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  /// Fetch enrolled students for a course
  Future<List<EnrollmentModel>> getEnrolledStudents(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('enrollments')
          .get();

      final list = snapshot.docs
          .map((doc) => EnrollmentModel.fromJson(doc.data()))
          .toList();

      list.sort((a, b) {
        final aRoll = int.tryParse(a.roll) ?? 0;
        final bRoll = int.tryParse(b.roll) ?? 0;
        return aRoll.compareTo(bRoll);
      });

      return list;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load students: $e';
    }
  }

  /// Create a new attendance session
  Future<String> createSession({
    required String courseId,
    required String date,
    required String lecture,
    required List<AttendanceRecordModel> records,
  }) async {
    try {
      final presentCount = records.where((r) => r.status == 'present').length;
      final absentCount = records.where((r) => r.status == 'absent').length;
      final lateCount = records.where((r) => r.status == 'late').length;

      final docRef = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .add({
        'courseId': courseId,
        'date': date,
        'lecture': lecture,
        'totalStudents': records.length,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'lateCount': lateCount,
        'records': records.map((r) => r.toJson()).toList(),
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      return docRef.id;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to save attendance: $e';
    }
  }

  /// Update existing session
  Future<void> updateSession({
    required String courseId,
    required String sessionId,
    required String lecture,
    required List<AttendanceRecordModel> records,
  }) async {
    try {
      final presentCount = records.where((r) => r.status == 'present').length;
      final absentCount = records.where((r) => r.status == 'absent').length;
      final lateCount = records.where((r) => r.status == 'late').length;

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .doc(sessionId)
          .update({
        'lecture': lecture,
        'totalStudents': records.length,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'lateCount': lateCount,
        'records': records.map((r) => r.toJson()).toList(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update attendance: $e';
    }
  }

  /// Create or update the single session for this course + date.
  Future<String> upsertSession({
    required String courseId,
    required String date,
    required String lecture,
    required List<AttendanceRecordModel> records,
  }) async {
    try {
      final presentCount =
          records.where((r) => r.status == 'present').length;
      final absentCount =
          records.where((r) => r.status == 'absent').length;
      final lateCount = records.where((r) => r.status == 'late').length;

      final payload = {
        'courseId': courseId,
        'date': date,
        'lecture': lecture,
        'totalStudents': records.length,
        'presentCount': presentCount,
        'absentCount': absentCount,
        'lateCount': lateCount,
        'records': records.map((r) => r.toJson()).toList(),
        'updatedAt': DateTime.now(),
      };

      final existing = await getSessionByDate(courseId: courseId, date: date);

      if (existing != null) {
        await _firestore
            .collection('courses')
            .doc(courseId)
            .collection('attendance_sessions')
            .doc(existing.sessionId)
            .update(payload);
        return existing.sessionId;
      }

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .doc(date)
          .set({
        ...payload,
        'createdAt': DateTime.now(),
      });
      return date;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to save attendance: $e';
    }
  }

  /// Get the session for a course on a given date, if it exists.
  Future<AttendanceSessionModel?> getSessionByDate({
    required String courseId,
    required String date,
  }) async {
    try {
      final byId = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .doc(date)
          .get();

      if (byId.exists && byId.data() != null) {
        return AttendanceSessionModel.fromJson(byId.data()!, byId.id);
      }

      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .where('date', isEqualTo: date)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return AttendanceSessionModel.fromJson(doc.data(), doc.id);
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load session: $e';
    }
  }

  /// Get today's session for a course (if exists)
  Future<AttendanceSessionModel?> getTodaySession(String courseId) {
    return getSessionByDate(courseId: courseId, date: _todayISO());
  }

  /// Student's status per session for one course (newest first).
  Future<List<Map<String, dynamic>>> getStudentAttendance({
    required String courseId,
    required String studentUid,
    String? studentCode,
  }) async {
    try {
      final sessions = await getSessions(courseId);

      return sessions.map((session) {
        AttendanceRecordModel? record;
        for (final r in session.records) {
          if (r.studentId == studentUid) {
            record = r;
            break;
          }
          if (studentCode != null &&
              studentCode.isNotEmpty &&
              r.studentCode == studentCode) {
            record = r;
            break;
          }
        }

        return {
          'date': session.formattedDate,
          'lecture': session.lecture,
          'status': record?.status ?? 'absent',
          'createdAt': session.createdAt,
        };
      }).toList();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load attendance: $e';
    }
  }

  /// Get all sessions for a course (sorted by date descending)
  Future<List<AttendanceSessionModel>> getSessions(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .get();

      final list = snapshot.docs
          .map((doc) => AttendanceSessionModel.fromJson(doc.data(), doc.id))
          .toList();

      // Sort in-memory by date (newest first)
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return list;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load sessions: $e';
    }
  }

  /// Delete a session
  Future<void> deleteSession({
    required String courseId,
    required String sessionId,
  }) async {
    try {
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .doc(sessionId)
          .delete();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to delete session: $e';
    }
  }

  /// Get a single session by ID
  Future<AttendanceSessionModel?> getSessionById({
    required String courseId,
    required String sessionId,
  }) async {
    try {
      final doc = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('attendance_sessions')
          .doc(sessionId)
          .get();

      if (doc.exists && doc.data() != null) {
        return AttendanceSessionModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load session: $e';
    }
  }

  /// Today's date in ISO format
  String _todayISO() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}