import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pro_product_explorer/constants/color_helpers.dart';
import 'package:pro_product_explorer/model/product_model.dart';

class ProductTile extends StatelessWidget {
  final Products? product;
  final VoidCallback? onTap;
  const ProductTile({super.key, this.product, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorHelper.borderColor),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product?.thumbnail ?? "",
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Column(
                        children: [
                          CircularProgressIndicator(
                            color: ColorHelper.borderColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.title ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product?.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorHelper.textGreyColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${product?.price}",
                      style: TextStyle(
                        color: ColorHelper.blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: ColorHelper.warningColor,
                        ),
                        Text(
                          "${product?.rating}",
                          style: TextStyle(
                            color: ColorHelper.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: ColorHelper.borderColor),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
