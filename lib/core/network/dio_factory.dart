import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/api/end_ponits.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio() {
    if (_dio != null) {
      return _dio!;
    }

    const duration = Duration(seconds: 30);
    final dio = Dio(
      BaseOptions(
        baseUrl: EndPoint.baseUrl,
        receiveTimeout: duration,
        connectTimeout: duration,
        sendTimeout: duration,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Notion-Version': '2022-06-28', // Required for Notion API
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.readData(
            key: AppConstants.tokenKey,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio = dio;
    return _dio!;
  }
}
