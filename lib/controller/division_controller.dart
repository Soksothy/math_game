import 'dart:math';
import 'base_controller.dart';

class DivisionGameController extends BaseGameController {
  final _random = Random();

  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    // Limit divisor to single digit (1-9)
    int num2 = getRandomNumber(1, min(9, (5 * difficulty).round()));
    // Limit quotient to ensure product stays within two digits
    int answer = getRandomNumber(1, min(9, (7 * difficulty).round()));
    int num1 = num2 * answer; // Will result in max 2-digit number

    currentNumbers = [num1, num2];
    correctAnswer = answer;

    generateOptions(); // Generate options for multiple-choice
  }

  @override
  void generateOptions() {
    options = [correctAnswer];
    while (options.length < 4) {
      int wrongAnswer = correctAnswer + (_random.nextInt(5) - 2);
      if (wrongAnswer <= 0 || options.contains(wrongAnswer)) {
        wrongAnswer = correctAnswer + (_random.nextInt(10) + 1);
      }
      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} ÷ ${currentNumbers[1]} =';
  }

  @override
  String getOperationSymbol() {
    return '÷';
  }
}
