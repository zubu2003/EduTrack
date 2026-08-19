import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            const Image(
              image: AssetImage("assets/logo/app_logo.png"),
              width: 200,
            ),
            const SizedBox(height: 20),
            // App Name or Tagline (optional)
            Text(
              "EduTrack",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
