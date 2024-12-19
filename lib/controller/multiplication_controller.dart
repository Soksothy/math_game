import 'dart:math';
import 'base_controller.dart';

class MultiplicationGameController extends BaseGameController {
  final _random = Random();

  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    int maxNumber = (5 * difficulty).round(); // Reduced maxNumber for multiplication

    currentNumbers = [
      getRandomNumber(1, maxNumber),
      getRandomNumber(1, maxNumber),
    ];
    correctAnswer = currentNumbers[0] * currentNumbers[1];
    generateOptions(); // Ensure options are generated for multiple choice
  }

  @override
  void generateOptions() {
    options = [correctAnswer];
    while (options.length < 4) {
      // Generate wrong answers that look plausible for multiplication
      int wrongAnswer;
      if (_random.nextBool()) {
        // Sometimes add or subtract a small number from correct answer
        wrongAnswer = correctAnswer + (_random.nextInt(5) - 2);
      } else {
        // Sometimes use wrong but plausible multiplication results
        int a = currentNumbers[0] + (_random.nextInt(3) - 1);
        int b = currentNumbers[1] + (_random.nextInt(3) - 1);
        wrongAnswer = a * b;
      }
      
      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} × ${currentNumbers[1]} =';
  }

  @override
  String getOperationSymbol() {
    return '×';
  }
}
