import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/utils/constant/keys.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;

  /// Save User Record (Google Sign-In / after Auth user creation)
  /// Document ID = Firebase Auth UID
  Future<void> saveUserRecord(
      UserCredential? userCredentials, {
        String role = 'student',
        String? name,
        String? idNumber,
      }) async {
    try {
      if (userCredentials != null) {
        final user = userCredentials.user;
        if (user == null) return;

        // Check if user already exists
        final doc = await _firestore
            .collection(SCollections.users)
            .doc(user.uid)
            .get();

        if (doc.exists) return;

        // Create new user model
        final newUser = UserModel(
          uid: user.uid,
          name: name ?? user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          role: role,
          profileImage: user.photoURL ?? '',
          studentId: role == 'student' ? (idNumber ?? '') : '',
          teacherId: role == 'teacher' ? (idNumber ?? '') : '',
          department: '',
          batch: '',
          designation: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to Firestore (UID as Document ID)
        await _firestore
            .collection(SCollections.users)
            .doc(user.uid)
            .set(newUser.toJson());
      }
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Save User Data (Manual Registration with email/password)
  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore
          .collection(SCollections.users)
          .doc(user.uid)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get User Data by UID
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc =
      await _firestore.collection(SCollections.users).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Current User Data (uses Firebase Auth current user UID)
  Future<UserModel?> getCurrentUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      return await getUserData(uid);
    } catch (e) {
      throw 'Error fetching current user: $e';
    }
  }

  /// Update User Data (full update using set with merge)
  Future<void> updateUserRecord(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(SCollections.users)
          .doc(user.uid)
          .set(updatedUser.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update Single Field
  Future<void> updateSingleField(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore
          .collection(SCollections.users)
          .doc(uid)
          .update(data);
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Delete User Record
  Future<void> deleteUserRecord(String uid) async {
    try {
      await _firestore.collection(SCollections.users).doc(uid).delete();
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Check if User Exists
  Future<bool> isUserExists(String uid) async {
    try {
      final doc = await _firestore
          .collection(SCollections.users)
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      throw 'Error checking user: $e';
    }
  }
}