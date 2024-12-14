import 'package:flutter/material.dart';

class AnswerInputContainer extends StatelessWidget {
  final String input;
  final double width;
  final double height;
  final bool? isCorrect;
  final TextStyle? textStyle; // Add textStyle parameter

  const AnswerInputContainer({
    super.key,
    required this.input,
    this.width = 100,
    this.height = 60,
    this.isCorrect,
    this.textStyle, // Initialize textStyle parameter
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.blue;
    if (isCorrect != null) {
      borderColor = isCorrect! ? Colors.green : Colors.red;
    }

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4.0), // Adjust padding
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isCorrect != null
            ? (isCorrect! ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1))
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        input,
        style: textStyle ?? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Use textStyle if provided
      ),
    );
  }
}
