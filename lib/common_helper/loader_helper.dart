import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoaderHelper {
  static OverlayEntry? _overlayEntry;

  /// Show Lottie loader with optional cancel
  static void showLoader({VoidCallback? onCancel, BuildContext? context}) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Semi-transparent background
          Positioned.fill(
            child: Container(
              color: Colors.black87,
            ),
          ),
          // Centered Lottie animation
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                'assets/lottie/loading.json',
                repeat: true,
              ),
            ),
          ),
          // Cancel button (cross icon) at top-right
          Positioned(
            top: 50,
            right: 10,
            child: GestureDetector(
              onTap: () {
                onCancel?.call();
                hideLoader();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Insert overlay after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayContext = context ?? Get.context;
      if (overlayContext != null) {
        Overlay.of(overlayContext)?.insert(_overlayEntry!);
      }
    });
  }

  /// Hide loader
  static void hideLoader() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
