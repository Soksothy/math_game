import 'package:flutter/material.dart';

class AnimatedValue extends StatelessWidget {
  final int value;
  final TextStyle textStyle;
  final Duration duration;
  final Curve curve;

  const AnimatedValue({
    super.key,
    required this.value,
    required this.textStyle,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value - 1.0, end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Text(
          '${value.toInt()}',
          style: textStyle,
        );
      },
    );
  }
}
