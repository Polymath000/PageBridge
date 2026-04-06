import 'package:dio/dio.dart';
import 'package:pagebridge/core/database/api/api_consumer.dart'
    show ApiConsumer;
import 'package:pagebridge/core/database/api/api_consumer.dart';
import 'package:pagebridge/core/database/api/end_ponits.dart';
import 'package:pagebridge/core/errors/expentions.dart';
import 'package:pagebridge/core/network/interceptors.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.interceptors.addAll([LoggerInterceptor()]);
    dio.options.baseUrl = EndPoint.baseUrl;
  }

  //! POST
  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool isFormData = false,
    CancelToken? cancelToken, // Added
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken, // Passed to Dio
      );
      return response;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  //! GET
  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken, // Added
  }) async {
    try {
      final res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken, // Passed to Dio
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  //! DELETE
  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken, // Added
  }) async {
    try {
      final res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken, // Passed to Dio
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  //! PATCH
  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    CancelToken? cancelToken, // Added
  }) async {
    try {
      final res = await dio.patch(
        path,
        data: isFormData
            ? FormData.fromMap(data as Map<String, dynamic>)
            : data,
        queryParameters: queryParameters,
        cancelToken: cancelToken, // Passed to Dio
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }
}
