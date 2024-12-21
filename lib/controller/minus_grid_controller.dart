import 'dart:math' show max, pow;
import 'base_controller.dart';

class MinusGridController extends BaseGameController {
  List<int> digits1 = [];
  List<int> digits2 = [];
  List<int?> borrowedNumbers = [];
  List<int?> userAnswers = [];
  
  bool validateFullAnswer() {
    if (userAnswers.contains(null)) return false;
    
    int userResult = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      userResult += (userAnswers[i] ?? 0) * pow(10, i).toInt();
    }
    
    return userResult == correctAnswer;
  }

  @override
  void generateNewQuestion() {
    if (!isGameActive) return;
    
    double difficulty = getDifficultyMultiplier();
    int maxNumber = (999 * difficulty).round();
    
    // Ensure first number is larger than second number
    int num1 = getRandomNumber(100, maxNumber);
    int num2 = getRandomNumber(10, num1);
    
    currentNumbers = [num1, num2];
    correctAnswer = num1 - num2;
    
    digits1 = num1.toString().split('').map(int.parse).toList();
    digits2 = num2.toString().split('').map(int.parse).toList();
    
    int maxLength = max(digits1.length, digits2.length);
    
    borrowedNumbers = List.filled(maxLength + 1, null);
    userAnswers = List.filled(maxLength, null);
    
    logger.d('Generated new minus grid question: ${digits1.join()} - ${digits2.join()} = $correctAnswer');
  }

  bool validateColumn(int columnIndex) {
    if (columnIndex < 0 || columnIndex >= userAnswers.length) return false;
    
    int top = 0;
    if (columnIndex < digits1.length) {
      top = digits1[digits1.length - 1 - columnIndex];
      if (borrowedNumbers[columnIndex] != null) {
        top -= 1;
      }
    }
    
    int bottom = 0;
    if (columnIndex < digits2.length) {
      bottom = digits2[digits2.length - 1 - columnIndex];
    }
    
    if (borrowedNumbers[columnIndex + 1] != null) {
      top += 10;
    }
    
    int expectedDigit = (top - bottom) % 10;
    return userAnswers[columnIndex] == expectedDigit;
  }

  bool checkBorrow(int columnIndex) {
    if (columnIndex < 0 || columnIndex >= userAnswers.length) return false;
    
    int top = 0;
    if (columnIndex < digits1.length) {
      top = digits1[digits1.length - 1 - columnIndex];
      if (borrowedNumbers[columnIndex] != null) {
        top -= 1;
      }
    }
    
    int bottom = 0;
    if (columnIndex < digits2.length) {
      bottom = digits2[digits2.length - 1 - columnIndex];
    }
    
    return top < bottom;
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} - ${currentNumbers[1]} =';
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is! int) return false;
    return userAnswer == correctAnswer;
  }

  @override
  String getOperationSymbol() {
    return '-';
  }

  int getMaxLength() {
    return max(
      digits1.length,
      max(digits2.length, correctAnswer.toString().length)
    );
  }
}
