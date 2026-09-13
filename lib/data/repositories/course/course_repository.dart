import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/enrollment_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';
import 'package:edutrack/utils/helper/student_id_parser.dart';

class CourseRepository extends GetxController {
  static CourseRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;
  final _coursesRef = 'courses';

  // ==================== CREATE ====================

  Future<String> createCourse(CourseModel course) async {
    try {
      final docRef = await _firestore
          .collection(_coursesRef)
          .add(course.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to create course: $e';
    }
  }

  // ==================== READ ====================

  /// Get teacher's courses (sorted in-app, no index needed)
  Future<List<CourseModel>> getTeacherCourses(String teacherId) async {
    try {
      final snapshot = await _firestore
          .collection(_coursesRef)
          .where('teacherId', isEqualTo: teacherId)
          .get();

      final list = snapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data(), doc.id))
          .toList();

      // Sort in-memory: newest first
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return list;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load courses: $e';
    }
  }

  /// Get student's enrolled courses (sorted in-app)
  Future<List<CourseModel>> getStudentCourses(String studentId) async {
    try {
      final coursesSnapshot = await _firestore.collection(_coursesRef).get();

      final List<CourseModel> enrolledCourses = [];

      for (final doc in coursesSnapshot.docs) {
        final enrollmentDoc = await _firestore
            .collection(_coursesRef)
            .doc(doc.id)
            .collection('enrollments')
            .doc(studentId)
            .get();

        if (enrollmentDoc.exists) {
          enrolledCourses.add(CourseModel.fromJson(doc.data(), doc.id));
        }
      }

      // Sort in-memory: newest first
      enrolledCourses.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return enrolledCourses;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load courses: $e';
    }
  }

  /// Get single course
  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final doc =
      await _firestore.collection(_coursesRef).doc(courseId).get();
      if (doc.exists && doc.data() != null) {
        return CourseModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load course: $e';
    }
  }

  /// Get enrolled students for a course (sorted by roll)
  Future<List<EnrollmentModel>> getEnrolledStudents(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection(_coursesRef)
          .doc(courseId)
          .collection('enrollments')
          .get();

      final list = snapshot.docs
          .map((doc) => EnrollmentModel.fromJson(doc.data()))
          .toList();

      // Sort by roll
      list.sort((a, b) {
        final rollA = int.tryParse(a.roll) ?? 0;
        final rollB = int.tryParse(b.roll) ?? 0;
        return rollA.compareTo(rollB);
      });

      return list;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load students: $e';
    }
  }

  // ==================== FIND STUDENTS FOR ENROLLMENT ====================

  /// Find students by batch + department + roll range
  Future<List<UserModel>> findStudentsByFilter({
    required String batch,
    required String department,
    required int startRoll,
    required int maxStudents,
  }) async {
    try {
      // Query all students in this batch+dept
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .where('batch', isEqualTo: batch)
          .where('department', isEqualTo: department)
          .get();

      // Parse and filter by roll range
      final List<UserModel> students = [];
      for (final doc in snapshot.docs) {
        final user = UserModel.fromJson(doc.data());
        final parsed = StudentIdParser.parse(user.studentId);
        final roll = int.tryParse(parsed['roll'] ?? '') ?? 0;

        if (roll >= startRoll && roll < startRoll + maxStudents) {
          students.add(user);
        }
      }

      // Sort by roll
      students.sort((a, b) {
        final rollA =
            int.tryParse(StudentIdParser.parse(a.studentId)['roll'] ?? '') ?? 0;
        final rollB =
            int.tryParse(StudentIdParser.parse(b.studentId)['roll'] ?? '') ?? 0;
        return rollA.compareTo(rollB);
      });

      return students;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to find students: $e';
    }
  }

  // ==================== ASSIGN STUDENTS ====================

  /// Assign multiple students to a course (batch write)
  Future<void> assignStudentsToCourse({
    required String courseId,
    required List<UserModel> students,
  }) async {
    try {
      final batch = _firestore.batch();

      for (final student in students) {
        final parsed = StudentIdParser.parse(student.studentId);
        final roll = int.tryParse(parsed['roll'] ?? '0') ?? 0;
        final section = StudentIdParser.getSection(roll);

        final enrollmentRef = _firestore
            .collection(_coursesRef)
            .doc(courseId)
            .collection('enrollments')
            .doc(student.uid);

        batch.set(enrollmentRef, {
          'studentId': student.uid,
          'studentName': student.name,
          'studentCode': student.studentId,
          'batch': parsed['batch'],
          'department': parsed['department'],
          'roll': parsed['roll'],
          'section': section,
          'enrolledAt': DateTime.now(),
        });
      }

      // Update total student count
      batch.update(
        _firestore.collection(_coursesRef).doc(courseId),
        {
          'totalStudents': students.length,
          'updatedAt': DateTime.now(),
        },
      );

      await batch.commit();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to assign students: $e';
    }
  }

  /// Remove a single student from course
  Future<void> removeStudentFromCourse({
    required String courseId,
    required String studentId,
  }) async {
    try {
      await _firestore
          .collection(_coursesRef)
          .doc(courseId)
          .collection('enrollments')
          .doc(studentId)
          .delete();

      // Update total count
      final snapshot = await _firestore
          .collection(_coursesRef)
          .doc(courseId)
          .collection('enrollments')
          .get();

      await _firestore.collection(_coursesRef).doc(courseId).update({
        'totalStudents': snapshot.docs.length,
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to remove student: $e';
    }
  }

  // ==================== UPDATE ====================

  Future<void> updateCourse(CourseModel course) async {
    try {
      await _firestore
          .collection(_coursesRef)
          .doc(course.courseId)
          .update({
        ...course.toJson(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update course: $e';
    }
  }

  // ==================== DELETE ====================

  Future<void> deleteCourse(String courseId) async {
    try {
      // Delete all enrollments first
      final enrollments = await _firestore
          .collection(_coursesRef)
          .doc(courseId)
          .collection('enrollments')
          .get();

      final batch = _firestore.batch();
      for (final doc in enrollments.docs) {
        batch.delete(doc.reference);
      }

      // Delete course doc
      batch.delete(_firestore.collection(_coursesRef).doc(courseId));

      await batch.commit();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to delete course: $e';
    }
  }
}