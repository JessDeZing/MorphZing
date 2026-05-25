import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/notification/notification_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api.g.dart';

@singleton
@RestApi()
abstract class NotificationApi {
  @factoryMethod
  factory NotificationApi(Dio dio) = _NotificationApi;

  @GET(GET_NOTIFICATION)
  Future<List<NotificationResponse>> getNotifications();

  @PATCH(SET_NOTIFICATION)
  Future<void> setNotification(
    @Body() NotificationResponse notificationResponse,
    @Path() int id,
  );
}
