import 'package:dio/dio.dart';
import 'package:morphzing/core/constants/urls.dart';

class HomeRepositories {
  static Future<Response<dynamic>> getUserData(String token) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true),
      ]);

    var result = await dio.get(BASE_URL + USER_INFO,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));

    return result;
  }

    static Future<Response<dynamic>> expireFreeSubscription(String token) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true),
      ]);

    var result = await dio.post(BASE_URL + SUB_EXP,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));

    return result;
  }
}
