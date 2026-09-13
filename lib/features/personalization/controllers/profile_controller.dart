import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Observable user
  Rx<UserModel> user = UserModel.empty().obs;
  RxBool isLoading = true.obs;

  // Form key
  final editProfileFormKey = GlobalKey<FormState>();
  final addDetailsFormKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();
  final batchController = TextEditingController();
  final designationController = TextEditingController();
  final studentIdController = TextEditingController();
  final teacherIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      final userData = await UserRepository.instance.getCurrentUserData();
      if (userData != null) {
        user.value = userData;

        // Pre-fill form fields
        nameController.text = userData.name;
        phoneController.text = userData.phone;
        departmentController.text = userData.department;
        batchController.text = userData.batch;
        designationController.text = userData.designation;
        studentIdController.text = userData.studentId;
        teacherIdController.text = userData.teacherId;
      }
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await fetchUserData();
  }

  /// Update user profile
  Future<void> updateProfile() async {
    try {
      if (!editProfileFormKey.currentState!.validate()) return;

      SFullScreenLoader.openLoadingDialog('Updating your profile...');

      final updatedUser = user.value.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        department: departmentController.text.trim(),
        batch: batchController.text.trim(),
        designation: designationController.text.trim(),
        studentId: studentIdController.text.trim(),
        teacherId: teacherIdController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await UserRepository.instance.updateUserRecord(updatedUser);

      user.value = updatedUser;

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Profile updated successfully',
      );

      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Add missing details (only saves provided fields)
  Future<void> addDetails() async {
    try {
      if (!addDetailsFormKey.currentState!.validate()) return;

      SFullScreenLoader.openLoadingDialog('Saving your details...');

      final updatedUser = user.value.copyWith(
        phone: phoneController.text.trim(),
        department: departmentController.text.trim(),
        batch: batchController.text.trim(),
        designation: designationController.text.trim(),
        studentId: studentIdController.text.trim(),
        teacherId: teacherIdController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await UserRepository.instance.updateUserRecord(updatedUser);

      user.value = updatedUser;

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Details added successfully',
      );

      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    batchController.dispose();
    designationController.dispose();
    studentIdController.dispose();
    teacherIdController.dispose();
    super.onClose();
  }
}