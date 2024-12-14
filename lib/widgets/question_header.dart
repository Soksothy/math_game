import 'package:flutter/material.dart';
import 'package:math_game/widgets/custom_back_button.dart';

class QuestionHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const QuestionHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 16),
          Text(
            'Question $currentQuestion of $totalQuestions',
            style: const TextStyle(
              fontSize:30,
            ),
          ),
        ],
      ),
    );
  }
}
