import 'package:flutter/material.dart';
import 'package:getx_code_architecture/constants/color_helpers.dart';


class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog(
      {super.key, this.child, this.height, this.width, this.duration, this.radius,  this.mainWidget});

  final Widget? child;
  final Widget? mainWidget;
  final double? height;
  final double? width;
  final double? radius;
  final Duration? duration;

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: widget.mainWidget??Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
                color: ColorHelper.whiteColor,
                borderRadius: BorderRadius.circular(widget.radius?? 16.0)),
            child: widget.child),
      ),
    );
  }
}
