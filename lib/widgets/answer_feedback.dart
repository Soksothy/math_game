import 'package:flutter/material.dart';

class AnswerFeedback extends StatelessWidget {
  final bool? isCorrect;
  final double size;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (isCorrect == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Icon(
        isCorrect! ? Icons.check_circle : Icons.cancel,
        color: isCorrect! ? Colors.green : Colors.red,
        size: size,
      ),
    );
  }
}
