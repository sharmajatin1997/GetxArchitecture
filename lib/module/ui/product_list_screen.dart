import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/animations/animated_list_view.dart';
import 'package:getx_code_architecture/common_helper/common_text_field.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'package:getx_code_architecture/constants/style_helper.dart';
import 'package:getx_code_architecture/module/cotrollers/product_controller/products_controller.dart';
import 'package:getx_code_architecture/routes/routes.dart';
import 'package:getx_code_architecture/widgets/product_tile.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final controller = Get.isRegistered<ProductController>()
      ? Get.find<ProductController>()
      : Get.put(ProductController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.skipData = 0;
    scrollListener(context: context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProduct(context: context);
    });
  }

  void scrollListener({required BuildContext context}) {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!controller.isLoading.value) {
          controller.isLoading.value = true;
          controller.skipData += 10;
          await controller.getProductPagination(context: context);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: const SizedBox(),
          backgroundColor: theme.scaffoldBackgroundColor,
          title: StyleHelper.appBarTitle(
            title: StringHelper.proProducts.tr,
            context: context, // <- theme aware
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  // Search box
                  CommonTextField(
                    fillColor: theme.cardColor, // use theme color
                    onChanged: (val) {
                      controller.skipData = 0;
                      controller.updateSearch(query: val, context: context);
                    },
                    hint: StringHelper.searchProducts.tr,
                    prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  ),
                  const SizedBox(height: 16),

                  // Product list
                  Expanded(
                    child: Obx(() {
                      final products = controller.products.value?.products ?? [];

                      if (controller.isLoading.value && products.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        );
                      }

                      if (products.isEmpty) {
                        return Column(
                          children: [
                            const Spacer(),
                            Text(
                              StringHelper.noProductFound.tr,
                              style: StyleHelper.bodyTextBold(context),
                            ),
                            const Spacer(),
                          ],
                        );
                      }

                      return AnimatedListView(
                        controller: scrollController,
                        animationType: ListAnimationType.slideFade,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductTile(
                            product: product,
                            onTap: () {
                              if (product.id != null) {
                                Get.toNamed(
                                  Routes.productDetailsScreen,
                                  arguments: {
                                    "id": "${product.id}",
                                    "title": product.title,
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),

              // Loading indicator at bottom
              Obx(
                    () => Visibility(
                  visible: controller.isLoading.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: theme.dividerColor,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
