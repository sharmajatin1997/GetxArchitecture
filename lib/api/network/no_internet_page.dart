import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_code_architecture/animations/animated_wrapper.dart';
import 'package:getx_code_architecture/common_helper/loader_helper.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'package:getx_code_architecture/constants/color_helpers.dart';
import 'api_request.dart';

class NoInternetPage extends StatefulWidget {
  final ApiRequest apiRequest;
  final Future<dynamic> Function(ApiRequest apiRequest) callBack;

  const NoInternetPage({
    super.key,
    required this.callBack,
    required this.apiRequest,
  });

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage>
    with SingleTickerProviderStateMixin {
  Timer? _retryTimer;
  bool _isRetrying = false;

  //==== Animation ====
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    LoaderHelper.hideLoader();
    _setupAnimation();
    _startAutoRetry();
  }

  void _setupAnimation() {
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _startAutoRetry() {
    _retryTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isRetrying) return; // Skip if manual retry in progress

      bool hasInternet = await _checkInternet();
      if (!hasInternet) return;

      try {
        _isRetrying = true;
        final data = await widget.callBack(widget.apiRequest);
        if (Navigator.canPop(context)) Get.back(result: data);
      } catch (_) {
        _isRetrying = false; // allow retry in next cycle
      }
    });
  }

  //==== Checks real internet connection ====
  Future<bool> _checkInternet() async {
    try {
      if (kIsWeb) {
        final uri = Uri.parse('https://google.com');
        final result = await HttpClient().getUrl(uri).then((req) => req.close());
        return result.statusCode == 200;
      } else {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      }
    } catch (_) {
      return false;
    }
  }

  //==== Manual retry triggered by button ====
  Future<void> _manualRetry() async {
    if (_isRetrying) return; // Already retrying
    _isRetrying = true;

    try {
      final hasInternet = await _checkInternet();
      if (!hasInternet) {
        _isRetrying = false;
        return;
      }

      final data = await widget.callBack(widget.apiRequest);
      if (Navigator.canPop(context)) Get.back(result: data);
    } catch (_) {
      _isRetrying = false; // allow automatic retry next cycle
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //==== Animated WiFi Icon (ScaleTransition) ====
                ScaleTransition(
                  scale: _animation,
                  child: AnimatedWrapper(
                    animationType: CommonAnimationType.bounce,
                    child: Icon(
                      Icons.wifi_off,
                      color: Colors.grey.shade400,
                      size: size.width * 0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                //==== Title ====
                AnimatedWrapper(
                  animationType: CommonAnimationType.fade,
                  delay: const Duration(milliseconds: 200),
                  child: const Text(
                    StringHelper.noInternet,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //==== Description ====
                AnimatedWrapper(
                  animationType: CommonAnimationType.slideFade,
                  delay: const Duration(milliseconds: 400),
                  child: const Text(
                    StringHelper.noInternetMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                //==== Retry Button ====
                AnimatedWrapper(
                  animationType: CommonAnimationType.pop,
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: size.width * 0.6,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _manualRetry,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        _isRetrying ? StringHelper.retrying : StringHelper.tryAgain,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHelper.blackColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //==== Auto retry info ====
                AnimatedWrapper(
                  animationType: CommonAnimationType.slide,
                  delay: const Duration(milliseconds: 800),
                  child: const Text(
                    StringHelper.automaticRetry,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
