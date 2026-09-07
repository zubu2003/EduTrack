import 'package:get/get.dart';

import '../../screens/login/login_screen.dart';
class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    Get.offAll(() => const LoginScreen());
  }
}
