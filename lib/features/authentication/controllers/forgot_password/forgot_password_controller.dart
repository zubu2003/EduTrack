import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'package:edutrack/utils/helper/network_manager.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> sendPasswordResetEmail() async {
    if (isSubmitting.value || !(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting.value = true;
    var isLoadingDialogOpen = false;

    try {
      if (!await NetworkManager.instance.isConnected()) {
        SSnackBarHelpers.warningSnackBar(title: 'No internet connection');
        return;
      }

      SFullScreenLoader.openLoadingDialog('Sending reset link...');
      isLoadingDialogOpen = true;

      await AuthenticationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      SFullScreenLoader.stopLoading();
      isLoadingDialogOpen = false;
      SSnackBarHelpers.successSnackBar(
        title: 'Email sent',
        message: 'Check your inbox to reset your password',
      );
    } catch (e) {
      if (isLoadingDialogOpen) {
        SFullScreenLoader.stopLoading();
      }
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
