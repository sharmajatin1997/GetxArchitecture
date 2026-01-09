import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/api/network/api_constants.dart';
import 'package:getx_code_architecture/common_helper/loader_helper.dart';
import 'package:getx_code_architecture/constants/utils.dart';
import 'package:getx_code_architecture/model/product_model.dart';
import 'product_api_controller.dart';

class ProductController extends GetxController {
  final ProductsApiController _productsApiController = ProductsApiController();
  RxBool isLoading = false.obs;
  RxString searchQuery = "".obs;
  int skipData = 0;
  Timer? _debounce;
  Rxn<ProductModel> products = Rxn();
  Rxn<Products> productsDetails = Rxn();
   Map<String,dynamic>? argument;

  Future<void> getProduct({required BuildContext context}) async {
    final dio.CancelToken cancelToken = dio.CancelToken(); // NEW token per request
    final url = "${ApiConstants.products}?limit=10&skip=$skipData";
    _productsApiController.productApi(
      url: url,
      context: context,
      cancelToken: cancelToken,
      onSuccess: (data) {
        try {
          products.value = ProductModel.fromJson(data);
          products.refresh();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        update();
      },
      onError: (data) {
        Utils.error(data);
        return false;
      },
    );
  }

  Future<void> getProductDetails({
    required BuildContext context,
    required String productId,
  }) async {
    final dio.CancelToken cancelToken = dio.CancelToken(); // NEW token per request
    LoaderHelper.showLoader(
      context: context,
      onCancel: () {
        cancelToken.cancel();
        LoaderHelper.hideLoader();
      },
    );
    _productsApiController.productApi(
      url: "${ApiConstants.products}/$productId",
      context: context,
      cancelToken: cancelToken,
      onSuccess: (data) {
        try {
          productsDetails.value = Products.fromJson(data);
          productsDetails.refresh();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        update();
        LoaderHelper.hideLoader();
      },
      onError: (data) {
        Utils.error(data);
        LoaderHelper.hideLoader();
        return false;
      },
    );
  }

  Future<void> searchProduct({
    required BuildContext context,
    required String query,
  }) async {
    _productsApiController.productApi(
      url: "${ApiConstants.products}/search?q=$query",
      context: context,
      onSuccess: (data) {
        try {
          products.value = ProductModel.fromJson(data);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        update();

      },
      onError: (data) {
        Utils.error(data);
        return false;
      },
    );
  }

  Future<void> getProductPagination({required BuildContext context}) async {
    final url = "${ApiConstants.products}?limit=10&skip=$skipData";
    _productsApiController.productApi(
      url: url,
      context: context,
      onSuccess: (data) {
        try {
          final productData = ProductModel.fromJson(data);
          products.value?.products?.addAll(productData.products ?? []);
          update();
          isLoading.value = false;
        } catch (e) {
          isLoading.value = false;
        }
      },
      onError: (error) {
        Utils.error(error);
        isLoading.value = false;
        return false;
      },
    );
  }

  void updateSearch({required String query, required BuildContext context}) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if(query !="") {
        searchProduct(context: context, query: query);
      }else{
        getProduct(context: context);
      }
    });
  }



  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
