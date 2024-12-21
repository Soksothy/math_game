import 'dart:math';
import 'base_controller.dart';

class JudgementController extends BaseGameController {
  bool isQuestionCorrect = true;
  int correctCount = 0;
  int wrongCount = 0;
  final String gameType;

  JudgementController({this.gameType = 'addition'});

  @override
  void generateNewQuestion() {
    if (!isGameActive) return;

    double difficulty = getDifficultyMultiplier();
    int maxNumber = (20 * difficulty).round();

    if (gameType == 'addition') {
      // Generate two random numbers for addition
      currentNumbers = [
        getRandomNumber(1, maxNumber),
        getRandomNumber(1, maxNumber),
      ];
      
      // Calculate the real answer for addition
      int realAnswer = currentNumbers[0] + currentNumbers[1];
      
      // Randomly decide if this question should show correct or wrong answer
      isQuestionCorrect = Random().nextBool();
      
      // If we want to show a wrong answer, modify it slightly
      if (!isQuestionCorrect) {
        correctAnswer = realAnswer + (Random().nextBool() ? 1 : -1);
      } else {
        correctAnswer = realAnswer;
      }
    } else if (gameType == 'subtraction') {
      // Generate numbers for subtraction where first number is larger
      int num1 = getRandomNumber(maxNumber ~/ 2, maxNumber);
      int num2 = getRandomNumber(1, num1);
      currentNumbers = [num1, num2];
      
      // Calculate the real answer for subtraction
      int realAnswer = currentNumbers[0] - currentNumbers[1];
      
      // Randomly decide if this question should show correct or wrong answer
      isQuestionCorrect = Random().nextBool();
      
      // If we want to show a wrong answer, modify it slightly
      if (!isQuestionCorrect) {
        correctAnswer = realAnswer + (Random().nextBool() ? 1 : -1);
      } else {
        correctAnswer = realAnswer;
      }
    } else if (gameType == 'multiplication') {
      // Generate two random numbers for multiplication
      currentNumbers = [
        getRandomNumber(1, maxNumber ~/ 2),
        getRandomNumber(1, maxNumber ~/ 2),
      ];
      
      // Calculate the real answer for multiplication
      int realAnswer = currentNumbers[0] * currentNumbers[1];
      
      // Randomly decide if this question should show correct or wrong answer
      isQuestionCorrect = Random().nextBool();
      
      // If we want to show a wrong answer, modify it slightly
      if (!isQuestionCorrect) {
        correctAnswer = realAnswer + (Random().nextBool() ? 1 : -1);
      } else {
        correctAnswer = realAnswer;
      }
    } else if (gameType == 'division') {
      // Generate numbers for division that result in whole numbers
      int divisor = getRandomNumber(1, maxNumber ~/ 2);
      int quotient = getRandomNumber(1, maxNumber ~/ 2);
      int dividend = divisor * quotient;
      currentNumbers = [dividend, divisor];
      
      // Calculate the real answer for division
      int realAnswer = quotient;
      
      // Randomly decide if this question should show correct or wrong answer
      isQuestionCorrect = Random().nextBool();
      
      // If we want to show a wrong answer, modify it slightly
      if (!isQuestionCorrect) {
        correctAnswer = realAnswer + (Random().nextBool() ? 1 : -1);
      } else {
        correctAnswer = realAnswer;
      }
    }

    logger.d('Generated judgement question: ${currentNumbers[0]} ${getOperationSymbol()} ${currentNumbers[1]} = $correctAnswer (${isQuestionCorrect ? 'Correct' : 'Wrong'})');
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is! bool) return false;
    
    bool isCorrect = userAnswer == isQuestionCorrect;
    if (isCorrect) {
      correctCount++;
    } else {
      wrongCount++;
    }
    return isCorrect;
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} ${getOperationSymbol()} ${currentNumbers[1]} = $correctAnswer';
  }

  @override
  String getOperationSymbol() {
    switch (gameType) {
      case 'addition':
        return '+';
      case 'subtraction':
        return '-';
      case 'multiplication':
        return '×';
      case 'division':
        return '÷';
      default:
        return '+';
    }
  }

  void resetCounts() {
    correctCount = 0;
    wrongCount = 0;
  }
}
