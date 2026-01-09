import 'package:flutter/material.dart';

enum GridAnimationType {
  fade,
  slide,
  scale,
  slideFade,
  rotate,
  flipX,
  flipY,
  bounce,
  shake,
}

// ===== A reusable animated GridView ====
class AnimatedGridView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollController? controller;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final Duration duration;
  final double offset;
  final GridAnimationType animationType;
  final EdgeInsetsGeometry? padding;

  const AnimatedGridView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.controller,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 50.0,
    this.animationType = GridAnimationType.fade,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final widget = itemBuilder(context, index);
        final delay = Duration(milliseconds: index * 90);

        switch (animationType) {
          case GridAnimationType.fade:
            return _FadeAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.slide:
            return _SlideAnimation(duration: duration, delay: delay, offset: offset, child: widget);

          case GridAnimationType.scale:
            return _ScaleAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.slideFade:
            return _SlideFadeAnimation(duration: duration, delay: delay, offset: offset, child: widget);

          case GridAnimationType.rotate:
            return _RotateAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.flipX:
            return _FlipXAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.flipY:
            return _FlipYAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.bounce:
            return _BounceAnimation(duration: duration, delay: delay, child: widget);

          case GridAnimationType.shake:
            return _ShakeAnimation(duration: duration, delay: delay, child: widget);
        }
      },
    );
  }
}

// ===== Fade =====
class _FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _FadeAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<_FadeAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = Tween(begin: 0.0, end: 1.0).animate(_c);
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _a, child: widget.child);

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Slide =====
class _SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offset;

  const _SlideAnimation({
    required this.child,
    required this.duration,
    required this.delay,
    this.offset = 50,
  });

  @override
  State<_SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<_SlideAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Offset> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = Tween(begin: Offset(0, widget.offset / 100), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => SlideTransition(position: _a, child: widget.child);

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Scale =====
class _ScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _ScaleAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<_ScaleAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = Tween(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _a, child: widget.child);

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Slide + Fade =====
class _SlideFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offset;

  const _SlideFadeAnimation({
    required this.child,
    required this.duration,
    required this.delay,
    this.offset = 50,
  });

  @override
  State<_SlideFadeAnimation> createState() => _SlideFadeAnimationState();
}

class _SlideFadeAnimationState extends State<_SlideFadeAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _fade = Tween(begin: 0.0, end: 1.0).animate(_c);
    _slide = Tween(begin: Offset(0, widget.offset / 100), end: Offset.zero)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Rotate =====
class _RotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _RotateAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<_RotateAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) =>
      RotationTransition(turns: CurvedAnimation(parent: _c, curve: Curves.easeOut), child: widget.child);

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Flip X =====
class _FlipXAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _FlipXAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_FlipXAnimation> createState() => _FlipXAnimationState();
}

class _FlipXAnimationState extends State<_FlipXAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final angle = (_c.value * 3.14);
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Flip Y =====
class _FlipYAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _FlipYAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_FlipYAnimation> createState() => _FlipYAnimationState();
}

class _FlipYAnimationState extends State<_FlipYAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final angle = (_c.value * 3.14);
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Bounce =====
class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _BounceAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = CurvedAnimation(parent: _c, curve: Curves.bounceOut);
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _a, child: widget.child);

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}

// ===== Shake =====
class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _ShakeAnimation({required this.child, required this.duration, required this.delay});

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _a = Tween(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _c, curve: Curves.elasticIn),
    );
    Future.delayed(widget.delay, () => mounted ? _c.forward() : null);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _a,
    builder: (_, child) => Transform.translate(offset: Offset(_a.value, 0), child: child),
    child: widget.child,
  );

  @override
  void dispose() {
    super.dispose();
    return _c.dispose();
  }
}
