import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/utils/helper/network_manager.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

import '../../../../utils/constant/keys.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final signUpFormKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final idNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  RxString selectedRole = 'student'.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  Future<void> registerUser() async {
    try {
      if (!signUpFormKey.currentState!.validate()) return;

      if (password.text.trim() != confirmPassword.text.trim()) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Password mismatch',
          message: 'Passwords do not match',
        );
        return;
      }

      // ✅ Role-Email matching validation
      final emailLower = email.text.trim().toLowerCase();
      final isStudentEmail = emailLower.contains(SKeys.studentEmailPattern);

      if (selectedRole.value == 'student' && !isStudentEmail) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Student Email',
          message:
          'Student emails must contain "@student." (e.g., u1234@student.university.edu)',
        );
        return;
      }

      if (selectedRole.value == 'teacher' && isStudentEmail) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Teacher Email',
          message: 'Teachers cannot use student email addresses.',
        );
        return;
      }

      SFullScreenLoader.openLoadingDialog('Creating your account...');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        SFullScreenLoader.stopLoading();
        SSnackBarHelpers.warningSnackBar(title: 'No internet connection');
        return;
      }

      // Step 1: Firebase Auth
      final userCredential = await AuthenticationRepository.instance
          .registerUser(email.text.trim(), password.text.trim());

      // Step 2: Firestore
      await UserRepository.instance.saveUserRecord(
        userCredential,
        role: selectedRole.value,
        name: name.text.trim(),
        idNumber: idNumber.text.trim(),
      );

      SFullScreenLoader.stopLoading();

      SSnackBarHelpers.successSnackBar(
        title: 'Account Created',
        message: 'Welcome to EduTrack!',
      );

      await AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  @override
  void onClose() {
    name.dispose();
    idNumber.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}