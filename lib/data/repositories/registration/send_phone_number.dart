import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/user/user_phone_update_model.dart';
import 'package:morphzing/data/models/user/user_verify_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';

class SendPhoneNumberRepositories {
  static verifyPhoneNumber(String phone) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      ]);
    final result = await dio.post(BASE_URL + USER_AUTH,
        data: PhoneVerificationPost(phone: phone).toJson(),
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ));
    debugPrint("RESULT: $result");
    return result;
  }

  static Future<Response> forgotPassword(String phone) async {
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      ]);
    final result = await dio.post(BASE_URL + USER_FORGOT_PASSWORD,
        data: {"phone": phone},
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ));
    debugPrint("RESULT: $result");
    return result;
  }

  static verifySmsCode(String phone, String smsCode) async {
    debugPrint("PHONE NUMBER: $phone");

    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true),
      );
    final result = await dio.post(
      BASE_URL + USER_VERIFY,
      data: UserVerification(phone: phone, code: smsCode),
      options: Options(
        headers: {},
        contentType: Headers.jsonContentType,
      ),
    );
    debugPrint(result.toString());
    return result;
  }

  // ‘’

  static Future<Response> phoneNumberUpdate(String phone, String secret, String token) async {
    debugPrint("PHONE NUMBER: $phone");

    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true),
      );
    final result = await dio.post(
      BASE_URL + USER_PHONE_UPDATE,
      data: UserPhoneUpdateModel(phone: phone, secret: secret),
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        contentType: Headers.jsonContentType,
      ),
    );
    debugPrint(result.toString());
    return result;
  }

  static Future<Response> resetPassword(String password, String confirmPassword, String secret) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(request: true, requestBody: true, responseBody: true),
      );
    final result = await dio.post(
      BASE_URL + USER_RESET_PASSWORD,
      data: {
        "secret": secret,
        "password": password,
        "confirm_password": confirmPassword,
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
        contentType: Headers.jsonContentType,
      ),
    );
    debugPrint(result.toString());
    return result;
  }
}
