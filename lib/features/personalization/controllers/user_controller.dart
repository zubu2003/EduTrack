import 'package:get/get.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Observable User
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    if (AuthenticationRepository.instance.currentUser != null) {
      fetchUserRecord();
    }
  }

  /// Fetch Current User Record
  Future<void> fetchUserRecord() async {
    try {
      final userData = await userRepository.getCurrentUserData();
      if (userData != null) {
        user.value = userData;
      }
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Save User Record
  Future<void> saveUserRecord(UserModel userData) async {
    try {
      await userRepository.updateUserRecord(userData);
      user.value = userData;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Update User Data
  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      SFullScreenLoader.openLoadingDialog('Updating your profile...');
      await userRepository.updateUserRecord(updatedUser);
      user.value = updatedUser;
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Profile updated successfully',
      );
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Update Single Field
  Future<void> updateSingleField(String key, dynamic value) async {
    try {
      final uid = user.value.uid;
      if (uid.isEmpty) return;

      await userRepository.updateSingleField(uid, {key: value});

      // Update local observable
      user.value = user.value.copyWith(
        updatedAt: DateTime.now(),
      );
      // Refresh
      await fetchUserRecord();
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Delete User Account & Data
  Future<void> deleteUserAccount() async {
    try {
      SFullScreenLoader.openLoadingDialog('Deleting your account...');

      final uid = user.value.uid;
      if (uid.isEmpty) {
        SFullScreenLoader.stopLoading();
        return;
      }

      // Delete user record from Firestore
      await userRepository.deleteUserRecord(uid);

      // Delete Firebase Auth user
      await AuthenticationRepository.instance.currentUser?.delete();

      SFullScreenLoader.stopLoading();

      // Redirect to login
      await AuthenticationRepository.instance.logout();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}