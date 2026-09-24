import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class SErrorFormatter {
  static String format(dynamic error) {
    // 1. Check for specific Network Exceptions
    if (error is SocketException || error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }

    // 2. Check for Firebase Network Errors
    if (error is FirebaseException) {
      if (error.code == 'network-request-failed' || error.code == 'unavailable') {
        return 'Network problem. The server is unreachable.';
      }
      return error.message ?? 'A database error occurred.';
    }

    // 3. Handle raw strings or other exceptions
    final errStr = error.toString().toLowerCase();
    if (errStr.contains('network') || errStr.contains('http')) {
      return 'Connection failed. Please try again.';
    }

    return error.toString();
  }
}