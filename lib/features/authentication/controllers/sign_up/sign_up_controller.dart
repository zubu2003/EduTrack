import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/utils/helper/network_manager.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

import '../../../../utils/constant/keys.dart';
import '../../models/user_model.dart';

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

      // Role-Email validation
      final emailLower = email.text.trim().toLowerCase();
      final isStudentEmail = emailLower.contains(SKeys.studentEmailPattern);

      if (selectedRole.value == 'student' && !isStudentEmail) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Invalid Student Email',
          message: 'Student emails must contain "@student."',
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

      // ✅ Parse student ID for batch + department
      String batch = '';
      String department = '';
      String studentIdValue = '';

      if (selectedRole.value == 'student') {
        studentIdValue = idNumber.text.trim();
        if (studentIdValue.length >= 4) {
          batch = studentIdValue.substring(0, 2);
          department = studentIdValue.substring(2, 4);
        }
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

      // Step 2: Save user data with parsed batch/department
      final newUser = UserModel(
        uid: userCredential.user!.uid,
        name: name.text.trim(),
        email: email.text.trim(),
        phone: '',
        role: selectedRole.value,
        profileImage: '',
        studentId: selectedRole.value == 'student' ? studentIdValue : '',
        teacherId: selectedRole.value == 'teacher' ? idNumber.text.trim() : '',
        department: department,   // ✅ Parsed from ID
        batch: batch,             // ✅ Parsed from ID
        designation: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await UserRepository.instance.saveUserData(newUser);

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