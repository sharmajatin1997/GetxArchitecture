import 'package:flutter/material.dart';
import 'package:pro_product_explorer/api/network/api_request.dart';
import 'package:pro_product_explorer/api/network/base_client.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pro_product_explorer/common_helper/utils.dart';

class ProductsApiController {

  final Map<String, dio.CancelToken> _cancelTokens = {};

  Future<void> productApi({
    required String url,
    required BuildContext context,
    required Function(dynamic) onSuccess,
    required Function(dynamic) onError,
    String? requestKey,
    dio.CancelToken? cancelToken, // external token
  }) async {
    final key = requestKey ?? url;

    cancelToken ??= dio.CancelToken();
    _cancelTokens[key] = cancelToken;

    try {
      final apiRequest = ApiRequest(
        url: url,
        requestType: RequestType.get,
        isTokenRequired: false,
        cancelToken: cancelToken, // use external token
      );
      final data = await BaseClient.handleRequest(apiRequest);

      if (data != null) {
        onSuccess(data);
      } else {
        onError("No data returned");
      }
    } on dio.DioException catch (e) {
      if (e.type == dio.DioExceptionType.cancel) {
        Utils.error("Request cancelled");
        onError("Request cancelled");
      } else {
        onError(e.response?.data?["message"] ?? e.message);
      }
    } catch (error) {
      onError("An unknown error occurred");
    } finally {
      _cancelTokens.remove(key);
    }
  }


  /// Cancel a specific API request
  void cancelRequest(String key) {
    if (_cancelTokens.containsKey(key)) {
      _cancelTokens[key]?.cancel();
      _cancelTokens.remove(key);
    }
  }

  /// Cancel all ongoing API requests
  void cancelAllRequests() {
    for (var token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
  }
}

