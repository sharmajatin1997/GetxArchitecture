import 'package:flutter/material.dart';
import 'package:getx_code_architecture/constants/string_helper.dart';

import '../constants/color_helpers.dart';

class CustomLoader extends StatelessWidget {
  final VoidCallback? onCancel;
  final String? message;

  const CustomLoader({super.key, this.onCancel, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              message ?? StringHelper.pleaseWait,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (onCancel != null)
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHelper.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    StringHelper.cancel,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
