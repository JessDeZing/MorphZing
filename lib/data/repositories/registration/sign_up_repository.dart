import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/user/sign_up_provider.dart';
import 'package:morphzing/data/models/user/withsocials/signup_afeter_socials_provider.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../core/constants/urls.dart';

class SignUpRepository {
  static verifyPhoneNumber(
    String secret,
    String fullName,
    String bio,
    DateTime birthDate,
    String sex,
    String email,
    String password,
    File? profileImage,
  ) async {
    final _requiredFormatBirthDate = DateFormat("yyyy-MM-dd").format(birthDate);
    Dio dio = Dio()
      ..interceptors.addAll([
        LogInterceptor(responseBody: true, request: true),
      ]);

    // final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    final timeZone = await FlutterTimezone.getLocalTimezone();


    final data = FullSignUpProvider(
      secret: secret,
      fullName: fullName,
      bio: bio,
      birthDate: _requiredFormatBirthDate,
      sex: sex,
      timeZone: timeZone,
      email: email,
      password: password,
      phone: '',
    );

    final jsonData = data.toJson();

    if (profileImage != null) {
      jsonData["profile_image"] =
          await MultipartFile.fromFile(profileImage.path, filename: profileImage.path.split("/").last);
    }

    FormData formData = FormData.fromMap(
      jsonData,
    );

    var result = await dio.post(BASE_URL + USER_SIGNUP,
        data: formData,
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ));
    debugPrint(result.toString());

    return result;
  }

  static afterSocialSignUp(String secret, String fullName, String bio, String birthDate, String sex, String phone,
      File? profileImage) async {
    Dio dio = Dio()..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    final timeZone = await await FlutterTimezone.getLocalTimezone();

    final data = SignUpAfterSocialsProvider(
      secret: secret,
      fullName: fullName,
      bio: bio,
      birthDate: birthDate,
      sex: sex,
      timeZone: timeZone,
      phone: phone,
      profileImage: profileImage,
    );

    final jsonData = data.toJson();

    if (profileImage != null) {
      jsonData["profile_image"] =
          await MultipartFile.fromFile(profileImage.path, filename: profileImage.path.split("/").last);
    }

    FormData formData = FormData.fromMap(
      jsonData,
    );

    var result = await dio.post(BASE_URL + USER_SIGNUP_SOCIALS,
        data: formData,
        options: Options(
          headers: {},
          contentType: Headers.jsonContentType,
        ));
    debugPrint("$result");

    return result;
  }
}
