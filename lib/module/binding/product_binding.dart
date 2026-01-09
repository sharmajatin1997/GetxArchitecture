import 'package:get/get.dart';
import 'package:getx_code_architecture/module/cotrollers/product_controller/products_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController(),);
  }
}
