import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'package:getx_code_architecture/module/binding/product_binding.dart';
import 'package:getx_code_architecture/module/ui/product_details_screen.dart';
import 'package:getx_code_architecture/module/ui/product_list_screen.dart';
import 'package:getx_code_architecture/routes/routes.dart';


class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widgetScreen;
    final args = settings.arguments;
    late Bindings bindings = ProductBinding();
    switch (settings.name) {
      case Routes.productListScreen:
        widgetScreen = const ProductListScreen();
        bindings = ProductBinding();
        break;

      case Routes.productDetailsScreen:
        widgetScreen = ProductDetailPage();
        bindings = ProductBinding();
        break;

      default:
        widgetScreen = _errorRoute();
        break;
    }

    return GetPageRoute(
      routeName: settings.name,
      page: () => widgetScreen,
      binding: bindings,
      settings: settings,
    );
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(title: Text(StringHelper.error.tr)),
      body: Center(
        child: Text(StringHelper.noSuchScreenFoundInRouteGenerator.tr),
      ),
    );
  }
}
