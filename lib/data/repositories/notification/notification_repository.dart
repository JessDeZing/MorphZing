import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/notification_api.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/notification/notification_response.dart';

@singleton
class NotificationRepository {
  final NotificationApi _notificationApi;

  const NotificationRepository(this._notificationApi);

  Future<List<NotificationResponse>> getNotifications() async {
    return await _notificationApi.getNotifications();
  }

  Future<void> setNotification(NotificationResponse notificationResponse) async {
    await _notificationApi.setNotification(notificationResponse, notificationResponse.id);
  }
}