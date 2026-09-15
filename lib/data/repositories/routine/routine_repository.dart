import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/routine_model.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';

class RoutineRepository extends GetxController {
  static RoutineRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;
  final _collection = 'routines';

  /// Create a new routine entry
  Future<String> createRoutine(RoutineModel routine) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(routine.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to create routine: $e';
    }
  }

  /// Update existing routine entry
  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(routine.routineId)
          .update({
        ...routine.toJson(),
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update routine: $e';
    }
  }

  /// Delete routine entry
  Future<void> deleteRoutine(String routineId) async {
    try {
      await _firestore.collection(_collection).doc(routineId).delete();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to delete routine: $e';
    }
  }

  /// Get all routines for a specific user (owner)
  Future<List<RoutineModel>> getUserRoutines(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      final list = snapshot.docs
          .map((doc) => RoutineModel.fromJson(doc.data(), doc.id))
          .toList();

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load routines: $e';
    }
  }

  /// Get a single routine by ID
  Future<RoutineModel?> getRoutineById(String routineId) async {
    try {
      final doc =
      await _firestore.collection(_collection).doc(routineId).get();

      if (doc.exists && doc.data() != null) {
        return RoutineModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to load routine: $e';
    }
  }
}