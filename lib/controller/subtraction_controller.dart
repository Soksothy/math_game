import 'base_controller.dart';

class SubtractionGameController extends BaseGameController {
  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    int maxNumber = (20 * difficulty).round();

    int num1 = getRandomNumber(1, maxNumber);
    int num2 = getRandomNumber(1, num1); // Ensure positive result

    currentNumbers = [num1, num2];
    correctAnswer = num1 - num2;
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} - ${currentNumbers[1]} = ?';
  }

  @override
  String getOperationSymbol() {
    return '-';
  }
}
