import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Widgets Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  // Get Storage Initialization
  await GetStorage.init();

  // Firebase Initialization
  try {
    if (Firebase.apps.isEmpty) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          DefaultFirebaseOptions.android.apiKey.isEmpty) {
        // Fall back to native google-services.json on Android if dart-define was omitted
        await Firebase.initializeApp();
      } else {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    }
  } catch (e) {
    if (e is! FirebaseException || e.code != 'duplicate-app') {
      rethrow;
    }
  }

  // Initialize Authentication Repository
  Get.put(AuthenticationRepository());

  // Force Portrait Mode Only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}