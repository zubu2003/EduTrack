import 'package:edutrack/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  static LoginController get instance => Get.find();

  // Observable variables
  var selectedRole = 'Student'.obs;
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Select Role (Student/Teacher)
  void selectRole(String role) {
    selectedRole.value = role;
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Forgot Password - Demo Only
  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  // Login - Frontend Only
  void login() {


    isLoading.value = true;

    // Simulate loading
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;

      // Navigate based on selected role
      if (selectedRole.value == 'Student') {
        Get.offAllNamed(AppRoutes.studentDashboard);
      } else {
        Get.offAllNamed(AppRoutes.teacherDashboard);
      }

      Get.snackbar(
        'Welcome',
        'Logged in as ${selectedRole.value}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}