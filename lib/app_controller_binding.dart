import 'package:get/instance_manager.dart';
import 'package:morphzing/app_controller.dart';

class AppControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController(), permanent: true);
  }
}
