import 'package:flutter/material.dart';

class AnimatedSlideIn extends StatelessWidget {
  const AnimatedSlideIn({
    required this.opacity,
    required this.slide,
    required this.child,
    super.key,
  });

  final Animation<double> opacity;
  final Animation<Offset> slide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([opacity, slide]),
      builder: (context, child) {
        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
