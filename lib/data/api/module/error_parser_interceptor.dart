import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as helper;
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/error_model.dart';
import 'package:morphzing/data/models/user/withsocials/get_token_provider.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/show_error.dart';

const Map<String, String> _headers = {
  'Content-Type': 'application/json',
  'charset': 'utf-8'
};

class CommonRequestInterceptor extends QueuedInterceptor {
  CommonRequestInterceptor(this._dio);

  // ignore: unused_field
  final Dio _dio;

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(_headers);
    options.headers.addAll({
      'Accept-Language':
          helper.Get.locale == LocaleEnum.es.getLocale() ? 'es-es' : 'en-us'
    });
    myPrint('${options.method} >>> ${options.uri}');
    myPrint('Headers: ${options.headers}');
    myPrint('Query parameters: ${options.queryParameters}');
    myPrint('Request data: ${options.data}');
    log('Request data: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    myPrint(
        '${response.requestOptions.method} <<< ${response.requestOptions.uri}');
    myPrint('Response data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    myPrint('${err.requestOptions.method} <<< ${err.requestOptions.uri}');
    myPrint('Error data: ${err.response?.data}');
    myPrint('Error status: ${err.response?.statusCode}');
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.unknown:
        showErrorSnackBar(message: 'Please, check your internet connection');
        break;
      default:
        break;
    }
    try {
      if (err.response != null && err.response!.data['errors'] != null) {
        ErrorModel errorModel = ErrorModel.fromJson(err.response!.data);
        StringBuffer buffer = StringBuffer();
        for (var element in errorModel.errors) {
          buffer.write('${element.field}: ${element.message}\n');
        }
        showErrorSnackBar(message: buffer.toString());
      }
    } on Object catch (e) {
      myPrint('catch in interceptor ${e.toString()}');
      showErrorSnackBar(message: 'Unexpected error, please contact support');
    }

    handler.next(err);
  }
}

class AuthorizedRequestInterceptor extends CommonRequestInterceptor {
  AuthorizedRequestInterceptor(
    this._localDio,
    this._tokenRepository,
  ) : super(_localDio);

  final TokenRepository _tokenRepository;
  final Dio _localDio;

  String? _getAccessToken() => _tokenRepository.getAccessToken();

  String? _getRefreshToken() => _tokenRepository.getRefreshToken();

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final accessToken = _getAccessToken();
      options.headers['Authorization'] = "Bearer $accessToken";
      return super.onRequest(options, handler);
    } on DioError catch (e) {
      handler.reject(e, true);
    } on Object catch (e) {
      myPrint(e);
    }
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_getRefreshToken() != null &&
          err.response?.data['code'] == 'token_not_valid') {
        final isTokenRefreshed = await _refreshToken();
        if (isTokenRefreshed) {
          return handler.resolve(await _retry(err.requestOptions));
        } else {
          _tokenRepository.deleteTokens();
          helper.Get.offAllNamed(firstIntroRoute);
          showErrorSnackBar(
              message: '"You session has expired, please login again"');
        }
      }
    }
    return super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    try {
      myPrint("REFRESH_TOKEN START ----");
      final response = await Dio(BaseOptions(
        baseUrl: BASE_URL,
        headers: {"Authorization": "Bearer ${_getAccessToken()}"},
      )).post("/user/token/refresh/",
          data: jsonEncode({"refresh": _getRefreshToken()}));

      if (response.statusCode == 200) {
        final _updatedTokens =
            GetTokenProvider.fromJson(jsonDecode(response.toString()));
        myPrint("access token" + _updatedTokens.access);
        myPrint("refresh token ${_updatedTokens.refresh}");
        await _tokenRepository.updateTokens(_updatedTokens.access);

        return true;
      }
      return false;
    } on Object catch (e) {
      myPrint("Could not refresh token -> ${e.toString()}");
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    Map<String, dynamic> newHeader = {};
    requestOptions.headers.forEach((key, value) {
      if (key.contains("Authorization")) {
        newHeader.addAll({key: "Bearer ${_getAccessToken()}"});
      } else {
        newHeader.addAll({key: value});
      }
    });
    final Options options = Options(
      method: requestOptions.method,
      headers: newHeader,
    );

    return _localDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

void myPrint(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}
