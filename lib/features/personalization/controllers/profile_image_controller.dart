import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/data/services/cloudinary/cloudinary_services.dart';
import 'package:edutrack/features/authentication/models/user_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/constant/keys.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/size.dart';

class ProfileImageController extends GetxController {
  static ProfileImageController get instance => Get.find();

  // Observables
  Rx<UserModel> user = UserModel.empty().obs;
  RxBool isUploading = false.obs;

  // Image picker
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fetch current user data
  Future<void> fetchUserData() async {
    try {
      final u = await UserRepository.instance.getCurrentUserData();
      if (u != null) user.value = u;
    } catch (e) {
      // silent
    }
  }

  /// Pick image from gallery/camera and upload
  Future<void> pickAndUploadImage({bool fromCamera = false}) async {
    try {
      // Pick image
      final XFile? picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (picked == null) return;

      final File imageFile = File(picked.path);

      // Upload
      await _uploadImage(imageFile);
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Upload image to Cloudinary + save URL to Firestore
  Future<void> _uploadImage(File imageFile) async {
    try {
      print('🔵 [Profile] _uploadImage called');
      print('🔵 [Profile] File path: ${imageFile.path}');
      print('🔵 [Profile] File exists: ${await imageFile.exists()}');
      print('🔵 [Profile] File size: ${await imageFile.length()} bytes');
      print('🔵 [Profile] User role: ${user.value.role}');
      print('🔵 [Profile] Cloud name: ${SKeys.cloudname}');
      print('🔵 [Profile] Upload preset: ${SKeys.uploadPreset}');

      isUploading.value = true;
      SFullScreenLoader.openLoadingDialog('Uploading image...');

      final folder = user.value.role == SRoles.teacher
          ? SKeys.teacherProfileFolder
          : SKeys.studentProfileFolder;

      print('🔵 [Profile] Folder: $folder');
      print('🔵 [Profile] Calling Cloudinary upload...');

      final response = await CloudinaryServices.instance
          .uploadImage(imageFile, folder);

      print('✅ [Profile] Cloudinary response status: ${response.statusCode}');
      print('✅ [Profile] Cloudinary response data: ${response.data}');

      final imageUrl = response.data['secure_url'] as String?;
      final publicId = response.data['public_id'] as String?;

      print('🔵 [Profile] imageUrl: $imageUrl');
      print('🔵 [Profile] publicId: $publicId');

      if (imageUrl == null || publicId == null) {
        throw 'Upload failed — no URL returned';
      }

      // Delete old image
      if (user.value.profileImagePublicId.isNotEmpty) {
        print('🔵 [Profile] Deleting old image...');
        try {
          await CloudinaryServices.instance
              .deleteImage(user.value.profileImagePublicId);
          print('✅ [Profile] Old image deleted');
        } catch (e) {
          print('⚠️ [Profile] Old image delete failed: $e');
        }
      }

      final updatedUser = user.value.copyWith(
        profileImage: imageUrl,
        profileImagePublicId: publicId,
        updatedAt: DateTime.now(),
      );

      print('🔵 [Profile] Saving to Firestore...');
      await UserRepository.instance.updateUserRecord(updatedUser);
      print('✅ [Profile] Firestore updated');

      user.value = updatedUser;

      SFullScreenLoader.stopLoading();
      isUploading.value = false;

      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Profile picture updated',
      );
    } catch (e, stack) {
      SFullScreenLoader.stopLoading();
      isUploading.value = false;
      print('❌ [Profile] Upload error: $e');
      print('❌ [Profile] Stack: $stack');
      SSnackBarHelpers.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Remove profile image
  Future<void> removeProfileImage() async {
    try {
      if (user.value.profileImagePublicId.isEmpty) return;

      // Show confirmation
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Remove Photo'),
          content: const Text(
            'Are you sure you want to remove your profile picture?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Get.back();
                await _performDelete();
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _performDelete() async {
    try {
      SFullScreenLoader.openLoadingDialog('Removing image...');

      // Delete from Cloudinary
      await CloudinaryServices.instance
          .deleteImage(user.value.profileImagePublicId);

      // Update user model
      final updatedUser = user.value.copyWith(
        profileImage: '',
        profileImagePublicId: '',
        updatedAt: DateTime.now(),
      );

      await UserRepository.instance.updateUserRecord(updatedUser);

      user.value = updatedUser;

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Removed',
        message: 'Profile picture removed',
      );
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Show bottom sheet with options
  void showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(SSize.defaultSpace),
        decoration: const BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SSize.cardRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),

            Text(
              'Profile Picture',
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),

            // Camera
            ListTile(
              leading: Icon(Iconsax.camera, color: SColors.primary),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                pickAndUploadImage(fromCamera: true);
              },
            ),

            // Gallery
            ListTile(
              leading: Icon(Iconsax.gallery, color: SColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickAndUploadImage(fromCamera: false);
              },
            ),

            // Remove (if image exists)
            if (user.value.profileImagePublicId.isNotEmpty)
              ListTile(
                leading: Icon(Iconsax.trash, color: SColors.error),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: SColors.error),
                ),
                onTap: () {
                  Get.back();
                  removeProfileImage();
                },
              ),

            const SizedBox(height: SSize.sm),
          ],
        ),
      ),
    );
  }
}