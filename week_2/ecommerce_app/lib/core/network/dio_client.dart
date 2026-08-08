import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/app_constants.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';

/// Creates and configures the app-wide Dio instance.
Dio createDioClient({String? authToken}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (authToken != null) HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => _log(obj.toString()),
  ));

  dio.interceptors.add(_ErrorInterceptor());

  return dio;
}

void _log(String msg) {
  // ignore: avoid_print
  assert(() {
    // ignore: avoid_print
    print('[Dio] $msg');
    return true;
  }());
}

/// Maps DioException -> app-level exceptions.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const NetworkException(),
            type: err.type,
          ),
        );
      default:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: const UnauthorizedException(),
              type: err.type,
              response: err.response,
            ),
          );
        } else if (statusCode == 404) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: const NotFoundException(),
              type: err.type,
              response: err.response,
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(
                message: err.message ?? 'Server error',
                statusCode: statusCode,
              ),
              type: err.type,
              response: err.response,
            ),
          );
        }
    }
  }
}
