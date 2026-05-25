import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/api/module/error_parser_interceptor.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';

const _requestTimeoutInMilliseconds = 20000;

@module
abstract class RegisterModule {
  // You can register named preemptive types like follows
  @Named("BaseUrl")
  String get url => BASE_URL;

  @singleton
  GetStorage get getStorage => GetStorage();

  @singleton
  Future<Dio> getAuthorizedDioClient({
    @Named("BaseUrl") required String baseUrl,
    required TokenRepository tokenRepository,
  }) async {
    final authorizedDioClient = _createDioClient(baseUrl: baseUrl);
    authorizedDioClient.interceptors.addAll([
      AuthorizedRequestInterceptor(
        authorizedDioClient,
        tokenRepository,
      ),
    ]);
    return authorizedDioClient;
  }

  @Named("UnauthorizedClient")
  @singleton
  Future<Dio> getUnauthorizedDioClient(
      {@Named("BaseUrl") required String baseUrl}) async {
    final unauthorizedDioClient = _createDioClient(baseUrl: baseUrl);
    unauthorizedDioClient.interceptors.addAll([
      CommonRequestInterceptor(unauthorizedDioClient),
    ]);
    return unauthorizedDioClient;
  }

  Dio _createDioClient({String? baseUrl}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      receiveDataWhenStatusError: true,
    ));
    dio.options.connectTimeout =
        Duration(milliseconds: _requestTimeoutInMilliseconds);
    dio.options.receiveTimeout =
        Duration(milliseconds: _requestTimeoutInMilliseconds);

    return dio;
  }
}
