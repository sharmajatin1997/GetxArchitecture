import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:getx_code_architecture/common_helper/loader_helper.dart';
import 'package:getx_code_architecture/common_helper/shared_prefence_helper.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'package:getx_code_architecture/constants/utils.dart';
import 'api_request.dart';
import 'app_exceptions.dart';
import 'error_page.dart';
import 'no_internet_page.dart';

class BaseClient {

  static final dio.Dio _dio = dio.Dio()..interceptors.add(AppExceptions());

  //==== Handle API request with optional CancelToken ====
  static Future<dynamic> handleRequest(ApiRequest apiRequest) async {
    _dio.options
      ..followRedirects = false
      ..connectTimeout = const Duration(seconds: 40)
      ..receiveTimeout = const Duration(seconds: 40);

    //==== Check network ====
    if (!await hasNetwork()) {
      return Get.to(() => NoInternetPage(
        apiRequest: apiRequest,
        callBack: handleRequest, // Pass the async function
      ));
    }

    //==== Headers ====
    Map<String, dynamic> headers = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };
    if (apiRequest.headers != null) headers.addAll(apiRequest.headers!);

    if (apiRequest.isTokenRequired &&
        SharedPreferenceHelper().getUserToken() != null) {
      headers['Authorization'] =
      'Bearer ${SharedPreferenceHelper().getUserToken()}';
    }

    try {
      dio.Response<dynamic> response;
      //==== Perform API request with optional cancelToken ====
      switch (apiRequest.requestType) {
        case RequestType.get:
          response = await _dio.get(
            apiRequest.url,
            queryParameters: apiRequest.queryParameters,
            options: dio.Options(headers: headers),
            cancelToken: apiRequest.cancelToken,
          );
          break;

        case RequestType.post:
          response = await _dio.post(
            apiRequest.url,
            data: apiRequest.body,
            options: dio.Options(headers: headers),
            cancelToken: apiRequest.cancelToken,
          );
          break;

        case RequestType.put:
          response = await _dio.put(
            apiRequest.url,
            data: apiRequest.body,
            options: dio.Options(headers: headers),
            cancelToken: apiRequest.cancelToken,
          );
          break;

        case RequestType.delete:
          response = await _dio.delete(
            apiRequest.url,
            data: apiRequest.body,
            options: dio.Options(headers: headers),
            cancelToken: apiRequest.cancelToken,
          );
          break;
      }

      //==== Handle 4xx/5xx errors ====
      if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 600) {
        LoaderHelper.hideLoader();
        return Get.to(() => ErrorPage(
          message: response.data['message'] ?? StringHelper.somethingWentWrong,
          code: response.statusCode!,
          apiRequest: apiRequest,
        ));
      }

      return response.data;
    } on dio.DioException catch (e) {
      LoaderHelper.hideLoader();
      if (e.type == dio.DioExceptionType.cancel) {
        Utils.error(StringHelper.requestCancelledByUser);
        return null;
      }
      return Get.to(() => ErrorPage(
        message: e.response?.data['message'] ?? e.message,
        code: e.response?.statusCode ?? 500,
        apiRequest: apiRequest,
      ));
    } catch (e) {
      Utils.error('${StringHelper.unexpectedError}: $e');
      return null;
    }
  }

  static Future<bool> hasNetwork() async {
    try {
      final dioCheck = dio.Dio();
      final response = await dioCheck.get(
        'https://clients3.google.com/generate_204',
        options: dio.Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
          followRedirects: false, // important to avoid redirect issues
        ),
      );

      //==== 204 means no content, so network is connected ====
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }


  //==== Cancel a running API ====
  static void cancelRequest(ApiRequest apiRequest) {
    apiRequest.cancelToken?.cancel();
  }
}
