import 'package:flutter/material.dart';
import 'package:math_game/widgets/answer_input_container.dart';
import 'package:math_game/widgets/answer_feedback.dart';

class QuestionDisplay extends StatelessWidget {
  final String question;
  final String userInput;
  final bool? isCorrect;
  final TextStyle textStyle;
  final TextStyle inputTextStyle; // Add inputTextStyle parameter

  const QuestionDisplay({
    super.key,
    required this.question,
    required this.userInput,
    this.isCorrect,
    this.textStyle = const TextStyle(),
    this.inputTextStyle = const TextStyle(), // Initialize inputTextStyle parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: textStyle,
          ),
          const SizedBox(width: 10),
          AnswerInputContainer(
            input: userInput,
            isCorrect: isCorrect,
            textStyle: inputTextStyle, // Use inputTextStyle for input answer
          ),
          const SizedBox(width: 10),
          AnswerFeedback(isCorrect: isCorrect),
        ],
      ),
    );
  }
}
