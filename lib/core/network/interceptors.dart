import 'dart:developer';
import 'package:dio/dio.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    
    log(
      '${options.method} request ==> $requestPath\n'
      'Error type: ${err.type}\n'
      'Error message: ${err.message}',
      name: 'DioError',
      error: err.error,
    );
    handler.next(err); 
  }

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    final requestPath = '${options.baseUrl}${options.path}';
    log('${options.method} request ==> $requestPath', name: 'DioRequest');
    handler.next(options);
  }

  @override
  void onResponse(
    final Response response,
    final ResponseInterceptorHandler handler,
  ) {
    log(
      'STATUSCODE: ${response.statusCode}\n'
      'STATUSMESSAGE: ${response.statusMessage}\n'
      'HEADERS: ${response.headers}\n'
      'Data: ${response.data}',
      name: 'DioResponse',
    );
    handler.next(response);
  }
}
