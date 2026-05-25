import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';

class JournalRepositories {
  static getJournalStats(String token) async {
    debugPrint('token $token');
    debugPrint('url ${BASE_URL + JOURNAL_GET_STATS}');
    Dio dio = Dio()..interceptors.add(LogInterceptor());
    var result = await dio.get(BASE_URL + JOURNAL_GET_STATS,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));

    debugPrint(result.statusCode.toString());
    debugPrint(result.toString());

    return result;
  }

  static Future<Response<List>> getTodayJournals(String token) async {
    print("ggpw");
    Dio dio = Dio()
      ..interceptors.add(LogInterceptor(
          responseBody: true, request: true, requestBody: true, error: true));
    var result = await dio.get<List>(
      BASE_URL + JOURNAL_POST_JOURNEY,
      queryParameters: {
        "search_date": "${DateTime.now()}".substring(0, 10),
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(result.toString());

    return result;
  }

  static Future<Response<List>> getJournalsCalendar(
      String token, DateTime dateTime) async {
    print('sawqeqweqw');
    Dio dio = Dio()
      ..interceptors.add(LogInterceptor(
          responseBody: true, request: true, requestBody: true, error: true));
    var result = await dio.get<List>(
      BASE_URL + JOURNAL_POST_JOURNEY,
      queryParameters: {
        "search_date": "$dateTime".substring(0, 10),
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    print('sawqeqweqw');
    print(result.toString());

    return result;
  }
}
