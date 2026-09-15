import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';

class CtMarksRepository extends GetxController {
  static CtMarksRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  Future<CtDataModel?> getCtData(String courseId) async {
    try {
      final doc = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .get();

      if (doc.exists && doc.data() != null) {
        return CtDataModel.fromJson(doc.data()!, courseId);
      }
      return null;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load CT data: $e';
    }
  }

  /// Merge parsed Excel data into Firestore.
  /// Converts studentCode → Firebase UID before saving.
  Future<void> mergeExcelData({
    required String courseId,
    required Map<String, Map<String, double>> marksByCt,
    required Map<String, double> totals,
    required double fullMarks,
    int bestOfCount = 3,
    int totalCTs = 4,
  }) async {
    try {
      final enrollmentsSnapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('enrollments')
          .get();

      final codeToUid = <String, String>{};
      for (final doc in enrollmentsSnapshot.docs) {
        final data = doc.data();
        final studentCode = (data['studentCode'] ?? '').toString();
        final studentId = (data['studentId'] ?? '').toString();
        if (studentCode.isNotEmpty && studentId.isNotEmpty) {
          codeToUid[studentCode] = studentId;
        }
      }

      final uidMarksByCt = <String, Map<String, double>>{};
      for (final entry in marksByCt.entries) {
        final uidMarks = <String, double>{};
        entry.value.forEach((code, mark) {
          final uid = codeToUid[code];
          if (uid != null) uidMarks[uid] = mark;
        });
        uidMarksByCt[entry.key] = uidMarks;
      }

      final uidTotals = <String, double>{};
      totals.forEach((code, total) {
        final uid = codeToUid[code];
        if (uid != null) uidTotals[uid] = total;
      });

      final existing = await getCtData(courseId) ?? CtDataModel.empty();

      final mergedCts = Map<String, CtModel>.from(existing.cts);

      for (final entry in uidMarksByCt.entries) {
        final ctTitle = entry.key;
        final newMarks = entry.value;

        if (mergedCts.containsKey(ctTitle)) {
          final oldCt = mergedCts[ctTitle]!;
          final mergedMarks = Map<String, double>.from(oldCt.marks);
          newMarks.forEach((uid, mark) => mergedMarks[uid] = mark);
          mergedCts[ctTitle] = oldCt.copyWith(
            marks: mergedMarks,
            updatedAt: DateTime.now(),
          );
        } else {
          mergedCts[ctTitle] = CtModel(
            ctTitle: ctTitle,
            date: _todayISO(),
            status: 'draft',
            marks: newMarks,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }

      final mergedTotals = Map<String, double>.from(existing.totals);
      uidTotals.forEach((uid, total) => mergedTotals[uid] = total);

      final updated = existing.copyWith(
        courseId: courseId,
        fullMarks: fullMarks,
        bestOfCount: bestOfCount,
        totalCTs: totalCTs,
        cts: mergedCts,
        totals: mergedTotals,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .set(updated.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to merge CT data: $e';
    }
  }

  Future<void> updateCtMarks({
    required String courseId,
    required String ctTitle,
    required Map<String, double> marks,
  }) async {
    try {
      final existing = await getCtData(courseId);
      if (existing == null) throw 'CT data not found';

      final ct = existing.cts[ctTitle];
      if (ct == null) throw 'CT "$ctTitle" not found';

      final updatedCt = ct.copyWith(
        marks: marks,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .update({
        'cts.$ctTitle': updatedCt.toJson(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update CT marks: $e';
    }
  }

  Future<void> updateCtStatus({
    required String courseId,
    required String ctTitle,
    required String status,
  }) async {
    try {
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .update({
        'cts.$ctTitle.status': status,
        'cts.$ctTitle.updatedAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update CT status: $e';
    }
  }

  Future<void> updateTotals({
    required String courseId,
    required Map<String, double> totals,
  }) async {
    try {
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .update({
        'totals': totals,
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update totals: $e';
    }
  }

  Future<void> createManualCt({
    required String courseId,
    required String ctTitle,
    required double fullMarks,
  }) async {
    try {
      final existing = await getCtData(courseId);
      if (existing == null) throw 'CT data not initialized';
      if (existing.cts.containsKey(ctTitle)) {
        throw 'CT "$ctTitle" already exists';
      }

      final newCt = CtModel(
        ctTitle: ctTitle,
        date: _todayISO(),
        status: 'draft',
        marks: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .update({
        'cts.$ctTitle': newCt.toJson(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to create CT: $e';
    }
  }

  Future<void> deleteCt({
    required String courseId,
    required String ctTitle,
  }) async {
    try {
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .update({
        'cts.$ctTitle': FieldValue.delete(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to delete CT: $e';
    }
  }

  Future<void> initializeCtData({
    required String courseId,
    required double fullMarks,
    int bestOfCount = 3,
    int totalCTs = 4,
  }) async {
    try {
      final existing = await getCtData(courseId);
      if (existing != null) return;

      final data = CtDataModel.empty().copyWith(
        courseId: courseId,
        fullMarks: fullMarks,
        bestOfCount: bestOfCount,
        totalCTs: totalCTs,
      );

      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('ct_data')
          .doc('main')
          .set(data.toJson());
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to initialize CT data: $e';
    }
  }

  String _todayISO() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}