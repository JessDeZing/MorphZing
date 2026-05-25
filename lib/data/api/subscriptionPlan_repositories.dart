import 'package:dio/dio.dart';
import 'package:morphzing/core/constants/urls.dart';

class SubscriptionRepositories {
  static Future<Response<dynamic>> makePostRequest({
    required String token, // Token parameter
  }) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true),
      ]);

    try {
      // Making the POST request

      final result = await dio.post(
        BASE_URL + USER_FREE_TRIAL,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      return result; // Returning the response
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to make POST request');
    }
  }

  static Future<Response<dynamic>> freePackageRequest({
    required String token,
  }) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true),
      ]);

    try {
      final result = await dio.post(
        BASE_URL + FREE_PACKAGE,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      return result; // Returning the response
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to make POST request');
    }
  }
}
