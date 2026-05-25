import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/data/models/user/login_provider.dart';

import '../../../core/constants/urls.dart';

class SignInRepositories {
  static signIn(String phone, String password) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      ]);

    var result = await dio.post(BASE_URL + USER_LOGIN,
        data: LoginProvider(
          phone: phone,
          password: password,
        ),
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ));
    debugPrint("$result");

    return result;
  }
}
