import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';
import 'App.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Widgets Flutter Binding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Get Storage Initialization
  await GetStorage.init();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Authentication Repository
  Get.put(AuthenticationRepository());

  // Force Portrait Mode Only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}