import 'package:get/get.dart';
import 'package:morphzing/data/models/notification/notification_response.dart';
import 'package:morphzing/data/repositories/notification/notification_repository.dart';
import 'package:morphzing/di/di_config.dart';

class NotificationSettingsController extends GetxController {
  RxBool pageLoading = true.obs;
  RxBool smsMessageValue = RxBool(true);
  RxList<NotificationResponse> notifications = RxList([]);
  final _notificationRepository = getIt<NotificationRepository>();

  @override
  void onInit() async {
    super.onInit();
    await getNotificationSettings();
    pageLoading.value = false;
  }

  void switchSmsMessageValue(
      bool? value, NotificationResponse notificationResponse) {
    smsMessageValue.value = value ?? false;
    _notificationRepository.setNotification(notificationResponse);
  }

  Future<void> getNotificationSettings() async {
    try {
      final response = await _notificationRepository.getNotifications();
      notifications.value = response;
      if (notifications.isNotEmpty) {
        smsMessageValue.value = notifications.first.smsMessage;
      }
    } on Object catch (e) {}
  }
}
