import 'package:get/get.dart';
import 'package:edutrack/data/repositories/authentication_repository.dart';

class SplashController extends GetxController {
  static SplashController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  Future<void> startTimer() async {
    // Show splash for 4 seconds
    await Future.delayed(const Duration(seconds: 4));

    // Then let repository decide where to go
    await AuthenticationRepository.instance.screenRedirect();
  }
}