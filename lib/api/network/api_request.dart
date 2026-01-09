import 'package:dio/dio.dart' as dio;

/// API request model with CancelToken
class ApiRequest {
  final String url;
  final RequestType requestType;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final dynamic body;
  final bool isTokenRequired;
  final dio.CancelToken? cancelToken; // Add cancel token

  ApiRequest({
    required this.url,
    required this.requestType,
    this.headers,
    this.queryParameters,
    this.body,
    this.isTokenRequired = true,
    this.cancelToken,
  });
}

enum RequestType { post, get, delete, put }