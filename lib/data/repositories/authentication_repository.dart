import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/routes/app_routes.dart';
import 'package:edutrack/utils/constant/keys.dart';
import 'package:edutrack/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:edutrack/utils/exceptions/firebase_exceptions.dart';
import 'package:edutrack/utils/exceptions/format_exceptions.dart';
import 'package:edutrack/utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final localStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Current user
  User? get currentUser => _auth.currentUser;


  /// Central navigation based on auth state
  Future<void> screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userData = await UserRepository.instance.getUserData(user.uid);
      if (userData != null) {
        if (userData.role == SRoles.student) {
          Get.offAllNamed(AppRoutes.studentDashboard);
        } else if (userData.role == SRoles.teacher) {
          Get.offAllNamed(AppRoutes.teacherDashboard);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Register with Email & Password
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
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

  /// Login with Email & Password
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 55));
      return userCredential;
    } on TimeoutException {
      throw 'Connection timed out. Check your internet.';
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  /// Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // ✅ Initialize with Web Client ID (serverClientId)
      await googleSignIn.initialize(
        serverClientId: SKeys.googleWebClientId,
      );

      GoogleSignInAccount userAccount = await googleSignIn.authenticate();

      final idToken = userAccount.authentication.idToken;
      if (idToken == null) {
        throw 'Failed to get ID token from Google';
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw 'Connection timed out. Check your internet.';
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw SFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw SFirebaseException(e.code).message;
    } on FormatException {
      throw FormatException();
    } on PlatformException catch (e) {
      throw SPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong';
    }
  }
}