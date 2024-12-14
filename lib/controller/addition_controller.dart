import 'base_controller.dart';

class AdditionGameController extends BaseGameController {
  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    int maxNumber = (20 * difficulty).round();

    currentNumbers = [
      getRandomNumber(1, maxNumber),
      getRandomNumber(1, maxNumber),
    ];
    correctAnswer = currentNumbers[0] + currentNumbers[1];
    
    // Validate question generation
    assert(correctAnswer == (currentNumbers[0] + currentNumbers[1]), 'Answer generation mismatch');
    logger.d('Generated new addition question: ${currentNumbers[0]} + ${currentNumbers[1]} = $correctAnswer');
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} + ${currentNumbers[1]} =';
  }

  @override
  String getOperationSymbol() {
    return '+';
  }
}
