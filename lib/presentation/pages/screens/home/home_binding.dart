import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/calendar/calendar_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<AgendaController>(AgendaController());
    Get.put<SubscriptionController>(SubscriptionController());
  }
}
