import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/user_api.dart';
import 'package:morphzing/data/models/user/change_phone_provider.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';

@singleton
class UserRepository {
  final UserApi _userApi;

  UserRepository(this._userApi);

  Future<User> getUserInfo() async {
    print("getUserInfogetUserInfogetUserInfogetUserInfoNORR");
    return await _userApi.getUserInfo();
  }

  Future<void> changePhone(ChangePhoneProvider changePhoneProvider) async {
    return await _userApi.changePhone(changePhoneProvider: changePhoneProvider);
  }
}
