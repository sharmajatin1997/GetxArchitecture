import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/common_helper/color_helpers.dart';

class ImageView extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final double progressSize;
  final String placeholder;
  final BoxFit fit;
  final bool isCircle;

  const ImageView({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.progressSize = 32,
    this.placeholder = "assets/no_pic.png",
    this.fit = BoxFit.cover,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final double finalHeight = height ?? Get.height;
    final double finalWidth = width ?? Get.width;

    return SizedBox(
      height: finalHeight,
      width: finalWidth,
      child: _buildImage(finalHeight, finalWidth),
    );
  }

  Widget _buildImage(double h, double w) {
    if (image != null && image!.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: image!,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          );
        },
        placeholder: (_, __) => _loader(),
        errorWidget: (_, __, ___) => _errorWidget(),
      );
    }
    return _errorWidget();
  }

  Widget _loader() {
    return Center(
      child: SizedBox(
        width: progressSize,
        height: progressSize,
        child: const CircularProgressIndicator(
          strokeWidth: 3.5,
          valueColor:
          AlwaysStoppedAnimation<Color>(ColorHelper.primaryColor),
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage(placeholder),
          fit: fit,
        ),
      ),
    );
  }
}
