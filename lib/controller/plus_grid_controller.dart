import 'dart:math' show max, pow;
import 'base_controller.dart';

class PlusGridController extends BaseGameController {
  List<int> digits1 = [];
  List<int> digits2 = [];
  List<int?> carryOvers = [];
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
    
    currentNumbers = [
      getRandomNumber(10, maxNumber),
      getRandomNumber(10, maxNumber),
    ];
    correctAnswer = currentNumbers[0] + currentNumbers[1];
    
   
    digits1 = currentNumbers[0].toString().split('').map(int.parse).toList();
    digits2 = currentNumbers[1].toString().split('').map(int.parse).toList();
    
    
    int maxLength = max(digits1.length, digits2.length);
    maxLength = max(maxLength, correctAnswer.toString().length);
    
    carryOvers = List.filled(maxLength + 1, null);
    userAnswers = List.filled(maxLength, null);
    
    logger.d('Generated new plus grid question: ${digits1.join()} + ${digits2.join()} = $correctAnswer');
  }

  bool validateColumn(int columnIndex) {
    if (columnIndex < 0 || columnIndex >= userAnswers.length) return false;
    
    int sum = 0;
   
    if (columnIndex < digits1.length) {
      sum += digits1[digits1.length - 1 - columnIndex];
    }
    if (columnIndex < digits2.length) {
      sum += digits2[digits2.length - 1 - columnIndex];
    }
    if (columnIndex < carryOvers.length && carryOvers[columnIndex] != null) {
      sum += carryOvers[columnIndex]!;
    }
    
    int expectedDigit = sum % 10;
    
    return userAnswers[columnIndex] == expectedDigit;
  }

  bool checkCarryOver(int columnIndex) {
    if (columnIndex < 0 || columnIndex >= userAnswers.length) return false;
    
    int sum = 0;
    
    if (columnIndex < digits1.length) {
      sum += digits1[digits1.length - 1 - columnIndex];
    }
    if (columnIndex < digits2.length) {
      sum += digits2[digits2.length - 1 - columnIndex];
    }
    if (columnIndex < carryOvers.length && carryOvers[columnIndex] != null) {
      sum += carryOvers[columnIndex]!;
    }
    
    return sum >= 10;
  }

  @override
  String getQuestionText() {
    return '${currentNumbers[0]} + ${currentNumbers[1]} =';
  }

  @override
  bool checkAnswer(dynamic userAnswer) {
    if (userAnswer is! int) return false;
    return userAnswer == correctAnswer;
  }

  @override
  String getOperationSymbol() {
    return '+';
  }

  int getMaxLength() {
    return max(
      digits1.length,
      max(digits2.length, correctAnswer.toString().length)
    );
  }
}
