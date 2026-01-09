import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppExceptions extends Interceptor {
  String prettyPrint(Object object) {
    return const JsonEncoder.withIndent('  ').convert(json.decode(json.encode(object)));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print("--> ${options.method.toUpperCase()} ${options.uri}");
      print("Headers: ${options.headers}");
      print("Query: ${options.queryParameters}");
      print("Body: ${options.data}");
      print("--> END ${options.method.toUpperCase()}");
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print("<-- ${response.statusCode} ${response.requestOptions.uri}");
      print("Response: ${response.data}");
      print("<-- END HTTP");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("<-- ERROR ${err.message} ${err.requestOptions.uri}");
      print("Data: ${err.response?.data ?? 'Unknown Error'}");
      print("<-- END ERROR");
    }
    super.onError(err, handler);
  }
}
