import 'package:get/get.dart';

import '../utils/helper/network_manager.dart';

class SBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }


}