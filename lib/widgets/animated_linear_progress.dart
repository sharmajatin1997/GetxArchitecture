import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_product_explorer/constants/color_helpers.dart';

class AnimatedLinearProgress extends StatefulWidget {
  const AnimatedLinearProgress({super.key});

  @override
  _AnimatedLinearProgressState createState() => _AnimatedLinearProgressState();
}

class _AnimatedLinearProgressState extends State<AnimatedLinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _controller.value,
          backgroundColor: ColorHelper.blackColor,
        );
      },
    );
  }
}
