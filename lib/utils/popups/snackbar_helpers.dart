import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class SSnackBarHelpers {
  static void successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: SColors.success,
      icon: Iconsax.tick_circle,
      duration: duration,
    );
  }

  static void errorSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    _show(
      title: title,
      message: message,
      backgroundColor: SColors.error,
      icon: Iconsax.close_circle,
      duration: duration,
    );
  }

  static void warningSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {

    String friendlyMessage = _parseErrorMessage(message);


    _show(
      title: title,
      message: friendlyMessage,
      backgroundColor: SColors.warning,
      icon: Iconsax.warning_2,
      duration: duration,
    );
  }

  // New helper to translate technical errors
  static String _parseErrorMessage(String message) {
    final lowerCaseMsg = message.toLowerCase();

    // 1. Check for SocketException (No internet)
    if (lowerCaseMsg.contains('socketexception') ||
        lowerCaseMsg.contains('failed host lookup')) {
      return 'No internet connection. Please check your Wi-Fi or mobile data.';
    }

    // 2. Check for Firebase Network Errors
    if (lowerCaseMsg.contains('network-request-failed') ||
        lowerCaseMsg.contains('unavailable')) {
      return 'Network problem. Unable to connect to the server.';
    }

    // 3. Return original if it's already a clean message
    return message;
  }

  /// ScaffoldMessenger avoids GetX snackbar overlay LateInitializationError.
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required int duration,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.context;
      if (context == null || !context.mounted) return;

      final text = message.isEmpty ? title : '$title\n$message';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(icon, color: SColors.white),
                const SizedBox(width: SSize.sm),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: SColors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(SSize.md),
            duration: Duration(seconds: duration),
          ),
        );
    });
  }
}
