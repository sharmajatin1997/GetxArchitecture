import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/constants/color_helpers.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';

class Utils {
  String text = "";

  static void showLog(String? log) {
    if (kDebugMode) {
      print(" $log");
    }
  }

  static void error(String? message) {
    if (message == null) {
      return;
    }
    Get.closeAllSnackbars();
    Get.snackbar(
      StringHelper.proProductExplorer.tr,
      message,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      backgroundColor: ColorHelper.primaryColor,
      borderRadius: 10,
      snackPosition: SnackPosition.TOP,
      colorText: ColorHelper.primaryColor,
      duration: const Duration(seconds: 2),
      titleText: Text(
        StringHelper.proProductExplorer.tr,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.4,
        ),
      ),
    );
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      Utils.error(StringHelper.checkInternetConnection);
      return false;
    }
  }

  static Widget backIcon({void Function()? onTap}) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Get.back();
          },
      child: Icon(Icons.arrow_back_ios_new),
    );
  }

  static Widget appBarTitle({String? title}) {
    return Text(
      title?.tr ?? "",
      maxLines: 2,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ColorHelper.blackColor,
      ),
    );
  }
}
