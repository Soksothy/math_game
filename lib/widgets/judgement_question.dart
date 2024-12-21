import 'package:flutter/material.dart';

class JudgementQuestion extends StatelessWidget {
  final String questionText;
  final Function(bool) onAnswerSelected;
  final bool isEnabled;
  final int correctCount;
  final int wrongCount;

  const JudgementQuestion({
    super.key,
    required this.questionText,
    required this.onAnswerSelected,
    required this.isEnabled,
    required this.correctCount,
    required this.wrongCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScoreContainer(
                Icons.check_circle,
                correctCount,
                Colors.green,
              ),
              const SizedBox(width: 30),
              _buildScoreContainer(
                Icons.cancel,
                wrongCount,
                Colors.red,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            questionText,
            style: const TextStyle(
              fontSize: 48,
              fontFamily: 'Swiss',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: isEnabled ? () => onAnswerSelected(true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 65, 211, 96).withOpacity(isEnabled ? 0.9 : 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "True",
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Swiss',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                onPressed: isEnabled ? () => onAnswerSelected(false) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 82, 116).withOpacity(isEnabled ? 0.9 : 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "False",
                  style: TextStyle(
                    fontSize:35,
                    fontFamily: 'Swiss',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreContainer(IconData icon, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(width: 15),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(bool answer, Color color, IconData icon) {
    return GestureDetector(
      onTap: isEnabled ? () => onAnswerSelected(answer) : null,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(isEnabled ? 0.9 : 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
