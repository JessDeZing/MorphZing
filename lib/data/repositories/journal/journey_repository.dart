import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journey_models.dart';

class JourneyRepositories {
  static Future<Response<dynamic>> sendJourneyPost({
    required String token,
    required String journeyTime,
    required String noteName,
    File? audio,
    required String description,
    File? draw,
    String? location,
    String? webLink,
    List<Photo>? photos,
    File? document,
    required int user,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    final data = JourneyModelPhotos(
      journeyTime: journeyTime,
      noteName: noteName,
      audio: audio,
      description: description,
      draw: draw,
      location: location,
      webLink: location,
      document: document,
      user: user,
      photos: photos,
    );

    final jsonData = data.toJson();

    if (document != null) {
      jsonData['document'] = await MultipartFile.fromFile(document.path, filename: document.path.split("/").last);
    }

    /*
    List<MultipartFile> convertedPhotos = [];

    for (File? item in photos) {
      String? fileName = item?.path.split("/").last;
      convertedPhotos.add(await MultipartFile.fromFile(
        item!.path,
        filename: fileName ?? "${DateTime.now()}",
      ));
    }

    FormData formData = FormData.fromMap({"photo": convertedPhotos});
    */

    if (photos != null && photos.isNotEmpty) {
      List<MultipartFile> result = [];
      debugPrint('START!!!: $result');

      for (Photo e in photos) {
        result.add(await MultipartFile.fromFile(e.file!.path, filename: e.file!.path.split("/").last));
      }
      debugPrint('FINISH!!!: $result');

      jsonData['photos'] = result;
    } else {
      jsonData['photos'] = [];
    }

    if (audio != null) {
      jsonData['audio'] = await MultipartFile.fromFile(audio.path, filename: audio.path.split("/").last);
    }
    if (draw != null) {
      jsonData['draw'] = await MultipartFile.fromFile(draw.path, filename: draw.path.split("/").last);
    }

    FormData formData = FormData.fromMap(
      jsonData,
    );

    debugPrint('AFTER JSON: ${formData.fields}}');

    var result = await dio.post(
      BASE_URL + JOURNAL_POST_JOURNEY,
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return result;
  }

  static Future<Response<dynamic>> sendJourneyPut({
    required int id,
    required String token,
    required String journeyTime,
    required String noteName,
    File? audio,
    required String description,
    File? draw,
    String? location,
    String? webLink,
    File? document,
    List<Photo>? photos,
    required int user,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    final data = JourneyModelPhotos(
      journeyTime: journeyTime,
      noteName: noteName,
      audio: audio,
      description: description,
      draw: draw,
      location: location,
      webLink: location,
      document: document,
      photos: photos,
      user: user,
    );

    final jsonData = data.toJson();
    debugPrint('JSON: $jsonData');

    if (photos != null && photos.isNotEmpty) {
      List<MultipartFile> result = [];
      debugPrint('START PATCH!!!: $result');

      for (Photo e in photos) {
        result.add(await MultipartFile.fromFile(e.file!.path, filename: e.file!.path.split("/").last));
      }
      debugPrint('FINISH PATCH!!!: $result');

      jsonData['photos'] = result;
    }
    if (document != null) {
      jsonData['document'] = await MultipartFile.fromFile(document.path, filename: document.path.split("/").last);
    } else {
      jsonData['document'] = "";
    }
    if (audio != null) {
      jsonData['audio'] = await MultipartFile.fromFile(audio.path, filename: audio.path.split("/").last);
    } else {
      jsonData['audio'] = "";
    }
    if (draw != null) {
      jsonData['draw'] = await MultipartFile.fromFile(draw.path, filename: draw.path.split("/").last);
    } else {
      jsonData['draw'] = "";
    }

    FormData formData = FormData.fromMap(
      jsonData,
    );

    debugPrint('AFTER JSON: ${formData.fields}}');

    var result = await dio.put(
      BASE_URL + JOURNAL_POST_JOURNEY + "$id/",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
      data: formData,
    );

    return result;
  }

  static Future<Response<dynamic>> journeyDelete({
    required int id,
    required String token,
  }) async {
    Dio dio = Dio()
      ..interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true, request: true),
      );

    var result = await dio.delete(
      BASE_URL + JOURNAL_DELETE_JOURNEY + "$id/",
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
