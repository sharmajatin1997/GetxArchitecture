import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/animations/animated_wrapper.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'package:getx_code_architecture/constants/style_helper.dart';
import 'package:getx_code_architecture/constants/utils.dart';
import 'package:getx_code_architecture/module/cotrollers/product_controller/products_controller.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductController controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    controller.argument = Get.arguments;
    controller.productsDetails.value = null;

    // Fetch details once
    controller.getProductDetails(
      context: context,
      productId: controller.argument?["id"],
    ).then((_) => controller.update());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: Utils.backIcon(),
        backgroundColor: theme.scaffoldBackgroundColor,
        title: StyleHelper.appBarTitle(
          title: StringHelper.proProducts.tr,
          context: context, // <- theme aware
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          var data = controller.productsDetails.value;

          if (data == null) {
            return SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              if (data.images?.isNotEmpty == true)
                SizedBox(
                  height: 300,
                  child: AnimatedWrapper(
                    animationType: CommonAnimationType.slideFade,
                    child: PageView(
                      children: data.images!.map((img) {
                        return CachedNetworkImage(
                          imageUrl: img,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.onBackground,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: Colors.red),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Product Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product title
                    Text(
                      data.title ?? "",
                      style: StyleHelper.heading2(context)
                          .copyWith(color: theme.textTheme.bodyLarge?.color),
                    ),

                    const SizedBox(height: 4),

                    // Price + rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${data.price}",
                          style: StyleHelper.bodyTextBold(context).copyWith(
                              color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description label
                    Text(
                      StringHelper.description.tr,
                      style: StyleHelper.bodyTextBold(context).copyWith(
                          color: theme.textTheme.bodyLarge?.color),
                    ),

                    const SizedBox(height: 6),

                    // Description content
                    Text(
                      data.description ?? "",
                      style: StyleHelper.bodyText(context).copyWith(
                          color: theme.textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}
