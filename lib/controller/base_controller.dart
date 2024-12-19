import 'dart:math';
import 'package:logger/logger.dart';

abstract class BaseGameController {
  final logger = Logger();
  bool isGameActive = false;
  int currentQuestionNumber = 0;
  final int totalQuestions = 10;
  List<int> currentNumbers = [];
  int correctAnswer = 0;
  late List<int> options;

  void startGame() {
    isGameActive = true;
    currentQuestionNumber = 0;
    logger.i('Game started with $totalQuestions questions.');
    nextQuestion();
  }

  bool nextQuestion() {
    if (!isGameActive) return false;
    
    if (currentQuestionNumber < totalQuestions) {
      currentQuestionNumber++;
      generateNewQuestion();
      generateOptions();
      return true;
    }
    return false;
  }

  void generateNewQuestion();

  void generateOptions() {
    final random = Random();
    options = [correctAnswer];
    
    while (options.length < 4) {
      // Generate options within a reasonable range of the correct answer
      int offset = random.nextInt(10) + 1;
      int newOption = correctAnswer + (random.nextBool() ? offset : -offset);
      
      // Ensure all options are positive and unique
      if (newOption > 0 && !options.contains(newOption)) {
        options.add(newOption);
      }
    }
    // Shuffle the options
    options.shuffle();
  }

  bool checkAnswer(int userAnswer) {
    return userAnswer == correctAnswer;
  }

  void endGame() {
    isGameActive = false;
    logger.i('Game ended. Final score: $currentQuestionNumber');
  }

  double getDifficultyMultiplier() {
    return 1.0 + (currentQuestionNumber * 0.1);
  }

  int getRandomNumber(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  String getQuestionText();
  
  String getOperationSymbol();

  Question getCurrentQuestion() {
    return Question(
      questionText: getQuestionText(),
      options: options, // Ensure options are included
      correctAnswer: correctAnswer
    );
  }
}

class Question {
  final String questionText;
  final List<int> options;
  final int correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}
