import 'base_controller.dart';

class DivisionGameController extends BaseGameController {
  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    int maxNumber = (10 * difficulty).round();

    int num2 = getRandomNumber(1, maxNumber);
    int answer = getRandomNumber(1, maxNumber);
    int num1 = num2 * answer; // Ensure clean division

    currentNumbers = [num1, num2];
    correctAnswer = answer;
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
