import 'package:get/get.dart';
import 'package:pro_product_explorer/module/cotrollers/product_controller/products_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController(),);
  }
}
