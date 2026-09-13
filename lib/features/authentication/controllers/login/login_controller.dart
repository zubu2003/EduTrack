import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/utils/constant/keys.dart';
import 'package:edutrack/utils/helper/network_manager.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  final password = TextEditingController();
  RxBool isPasswordHidden = true.obs;
  RxBool rememberMe = false.obs;
  RxString selectedRole = SRoles.student.obs;
  final loginFormKey = GlobalKey<FormState>();
  final localStorage = GetStorage();

  @override
  void onInit() {
    email.text = localStorage.read(SKeys.rememberMeEmail) ?? '';
    password.text = localStorage.read(SKeys.rememberMePassword) ?? '';
    rememberMe.value = localStorage.read(SKeys.rememberMeCheckbox) ?? false;
    super.onInit();
  }

  /// Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Select Role
  void selectRole(String role) {
    selectedRole.value = role;
  }

  /// Forgot Password
  Future<void> forgotPassword() async {
    if (email.text.trim().isEmpty) {
      SSnackBarHelpers.warningSnackBar(
        title: 'Email required',
        message: 'Please enter your email first',
      );
      return;
    }

    try {
      SFullScreenLoader.openLoadingDialog('Sending reset link...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.warningSnackBar(title: 'No internet connection');
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Email sent',
        message: 'Check your inbox to reset your password',
      );
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Login with Email & Password
  Future<void> loginWithEmailAndPassword() async {
    try {
      SFullScreenLoader.openLoadingDialog('Logging you in...');

      // Validate
      if (!loginFormKey.currentState!.validate()) {
        SFullScreenLoader.stopLoading();
        return;
      }

      // Check Network
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.warningSnackBar(title: 'No internet connection');
        return;
      }

      // Remember Me
      if (rememberMe.value) {
        localStorage.write(SKeys.rememberMeEmail, email.text.trim());
        localStorage.write(SKeys.rememberMePassword, password.text.trim());
        localStorage.write(SKeys.rememberMeCheckbox, true);
      } else {
        localStorage.remove(SKeys.rememberMeEmail);
        localStorage.remove(SKeys.rememberMePassword);
        localStorage.remove(SKeys.rememberMeCheckbox);
      }

      // Firebase Auth Login
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Fetch user data
      final userData = await UserRepository.instance.getCurrentUserData();

      if (userData == null) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.errorSnackBar(
          title: 'Error',
          message: 'User data not found. Please contact support.',
        );
        await Future.delayed(const Duration(seconds: 2));
        await AuthenticationRepository.instance.logout();
        return;
      }

      // Role mismatch
      if (userData.role != selectedRole.value) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.errorSnackBar(
          title: 'Role Mismatch',
          message:
          'This account is registered as a ${userData.role}. Please select the correct role.',
        );
        await Future.delayed(const Duration(seconds: 3));
        await AuthenticationRepository.instance.logout();
        return;
      }

      SFullScreenLoader.stopLoading();

      // Redirect based on role
      await AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Google Sign In
  Future<void> googleSignIn() async {
    try {
      SFullScreenLoader.openLoadingDialog('Logging you in...');

      // Check Network
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.warningSnackBar(title: 'No internet connection');
        return;
      }

      // Google Auth
      UserCredential userCredential =
      await AuthenticationRepository.instance.signInWithGoogle();

      // Validate email pattern matches selected role
      final userEmail = userCredential.user?.email ?? '';
      final emailLower = userEmail.toLowerCase();
      final isStudentEmail = emailLower.contains(SKeys.studentEmailPattern);

      // Student with non-student email
      if (selectedRole.value == SRoles.student && !isStudentEmail) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Student Account',
          message:
          'Please use a student email address (must contain "@student.").',
        );
        await Future.delayed(const Duration(seconds: 3));
        await AuthenticationRepository.instance.logout();
        return;
      }

      // Teacher with student email
      if (selectedRole.value == SRoles.teacher && isStudentEmail) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Teacher Account',
          message: 'Teachers cannot use student email addresses.',
        );
        await Future.delayed(const Duration(seconds: 3));
        await AuthenticationRepository.instance.logout();
        return;
      }

      // Check if existing user has different role
      final existingUser =
      await UserRepository.instance.getUserData(userCredential.user!.uid);

      if (existingUser != null && existingUser.role != selectedRole.value) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.errorSnackBar(
          title: 'Role Mismatch',
          message:
          'This account is registered as a ${existingUser.role}. Please select the correct role.',
        );
        await Future.delayed(const Duration(seconds: 3));
        await AuthenticationRepository.instance.logout();
        return;
      }

      // Save user record (only creates if doesn't exist)
      await UserRepository.instance.saveUserRecord(
        userCredential,
        role: selectedRole.value,
      );

      SFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      SFullScreenLoader.stopLoading();

      // Silent ignore if user cancelled Google Sign-In
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('cancel')) {
        return;
      }

      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}