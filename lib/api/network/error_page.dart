import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:getx_code_architecture/common_helper/loader_helper.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';
import 'api_request.dart';
import 'base_client.dart';
import 'package:getx_code_architecture/constants/color_helpers.dart';

class ErrorPage extends StatefulWidget {
  final String message;
  final int code;
  final ApiRequest apiRequest;

  const ErrorPage({
    super.key,
    required this.message,
    required this.code,
    required this.apiRequest,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool _isRetrying = false;
  bool _lottieLoaded = false;

  @override
  void initState() {
    super.initState();
    LoaderHelper.hideLoader();
    _preloadLottie();
  }

  //==== Preload the Lottie animation to prevent blink ====
  void _preloadLottie() async {
    Lottie.asset(
      'assets/lottie/error404.json',
      onLoaded: (composition) {
        if (mounted) {
          setState(() {
            _lottieLoaded = true;
          });
        }
      },
    );
  }

  //==== Retry API call properly ====
  Future<void> _retryRequest() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);

    try {
      final result = await BaseClient.handleRequest(widget.apiRequest);

      if (result != null) {
        //==== Success: close the error page and return the result ====
        if (Navigator.canPop(context)) Get.back(result: result);
      } else {
        //==== API still returned error, show updated error page ====
        if (mounted) {
          setState(() => _isRetrying = false);
          Get.snackbar(
            StringHelper.error,
            StringHelper.errorPageMessage,
            backgroundColor: Colors.red.shade300,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      //==== Unexpected error ====
      if (mounted) {
        setState(() => _isRetrying = false);
        Get.snackbar(
          StringHelper.error,
          "${StringHelper.retryFailed}. ${e.toString()}",
          backgroundColor: Colors.red.shade300,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false, // Block back navigation
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //==== Lottie with fade-in when loaded ====
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _lottieLoaded
                      ? Lottie.asset(
                    'assets/lottie/error404.json',
                    key: const ValueKey('lottie'),
                    repeat: true,
                  )
                      : SizedBox(
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Retry button
                SizedBox(
                  width: size.width * 0.6,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isRetrying ? null : _retryRequest,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      _isRetrying ? StringHelper.retrying : StringHelper.retry,
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
                const SizedBox(height: 20),
                 Text(
                  StringHelper.connectionError,
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
