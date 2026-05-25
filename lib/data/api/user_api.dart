import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/user/change_phone_provider.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@singleton
@RestApi()
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @GET("/user/user_info")
  Future<User> getUserInfo();

  @POST(USER_PHONE_UPDATE)
  Future<void> changePhone({@Body() required ChangePhoneProvider changePhoneProvider});
}
