import 'package:edutrack/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/theme/theme.dart';
import 'features/authentication/screens/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: SAppTheme.lightTheme,
      darkTheme: SAppTheme.darkTheme,
      initialRoute: AppRoutes.splash, // Set initial route
      getPages: AppRoutes.pages,
      home: const SplashScreen(),
    );
  }
}
