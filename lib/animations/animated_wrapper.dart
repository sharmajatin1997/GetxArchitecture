import 'package:flutter/material.dart';
import 'dart:math';

enum CommonAnimationType {
  fade,
  slide,
  scale,
  slideFade,
  rotate,
  flip,
  zoomIn,
  zoomOut,
  bounce,
  pop,
}

class AnimatedWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offset;
  final CommonAnimationType animationType;

  const AnimatedWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.offset = 50,
    this.animationType = CommonAnimationType.fade,
  });

  @override
  State<AnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<AnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _scale = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: Offset(0, widget.offset / 100),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case CommonAnimationType.fade:
        return FadeTransition(opacity: _fade, child: widget.child);

      case CommonAnimationType.scale:
        return ScaleTransition(scale: _scale, child: widget.child);

      case CommonAnimationType.slide:
        return SlideTransition(position: _slide, child: widget.child);

      case CommonAnimationType.slideFade:
        return FadeTransition(
          opacity: _fade,
          child: SlideTransition(position: _slide, child: widget.child),
        );

      case CommonAnimationType.rotate:
        return RotationTransition(
          turns: _controller,
          child: widget.child,
        );

      case CommonAnimationType.flip:
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            final value = (1 - _controller.value) * pi;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(value),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: widget.child,
        );

      case CommonAnimationType.zoomIn:
        return ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(_controller),
          child: widget.child,
        );

      case CommonAnimationType.zoomOut:
        return ScaleTransition(
          scale: Tween(begin: 1.2, end: 1.0).animate(_controller),
          child: widget.child,
        );

      case CommonAnimationType.bounce:
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.elasticOut,
          ),
          child: widget.child,
        );

      case CommonAnimationType.pop:
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
          ),
          child: widget.child,
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
