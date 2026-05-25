import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/user/user_info.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class ProfileRepository {
  static edit({
    required String token,
    required int id,
    File? image,
    required String fullName,
    required String bio,
    required DateTime birthDate,
    required String sex,
    required String phone,
    required String email,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    // final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    final timeZone = await FlutterTimezone.getLocalTimezone();

    final data = UserInfoSaveModel(
      id: id,
      fullName: fullName,
      bio: bio,
      timeZone: timeZone,
      birthDate: birthDate,
      sex: sex,
      phone: phone,
      email: email,
    );

    final jsonData = data.toJson();

    if (image != null) {
      jsonData['profile_image'] = await MultipartFile.fromFile(image.path,
          filename: image.path.split("/").last);
    }
    debugPrint('AFTER JSON: $jsonData');

    FormData formData = FormData.fromMap(
      jsonData,
    );

    var result = await dio.patch(
      BASE_URL + USER_UPDATE + "$id/",
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
      data: formData,
    );

    return result;
  }

  static savePassword({
    required String token,
    required int id,
    required String password,
    required String confirmPassword,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    var result = await dio.post(
      BASE_URL + USER_UPDATE_PASSWORD,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
      data: {
        "user_id": id,
        "password": password,
        "confirm_password": confirmPassword,
      },
    );

    return result;
  }

  static Future<Response> checkPassword({
    required String token,
    required int id,
    required String password,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    var result = await dio.post(
      BASE_URL + USER_CHECK_PASSWORD,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
      data: {
        "user_id": id,
        "check_password": password,
      },
    );

    return result;
  }

  static deleteAccount(String token) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    var result = await dio.delete(
      BASE_URL + USER_DELETE,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    return result;
  }
}
