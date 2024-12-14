import 'dart:math';
import '../models/question_model.dart';

abstract class BaseGameController {
  final int totalQuestions = 5;
  List<QuestionModel> questions = [];
  int currentQuestionIndex = 0;
  bool isGameActive = false;
  List<int> currentNumbers = [];
  int correctAnswer = 0;
  int score = 0;

  // Initialize and start the game
  void startGame() {
    isGameActive = true;
    questions.clear();
    currentQuestionIndex = 0;
    score = 0;
    
    // Generate all questions at start
    for (int i = 0; i < totalQuestions; i++) {
      generateNewQuestion();
      questions.add(QuestionModel(
        numbers: List.from(currentNumbers),
        correctAnswer: correctAnswer,
        operation: getOperationSymbol(),
        options: generateOptions(),
      ));
    }
  }

  // Generate 4 options including the correct answer
  List<int> generateOptions() {
    final Set<int> options = {correctAnswer};
    final Random random = Random();
    
    while (options.length < 4) {
      int offset = random.nextInt(10) - 5; // Generate offset between -5 and 5
      options.add(correctAnswer + offset);
    }
    
    return options.toList()..shuffle();
  }

  // Check answer and update score
  bool checkAnswer(int answer) {
    if (!isGameActive) return false;
    
    bool isCorrect = answer == correctAnswer;
    questions[currentQuestionIndex].isAnswered = true;
    questions[currentQuestionIndex].isCorrect = isCorrect;
    
    if (isCorrect) score++;
    
    return isCorrect;
  }

  // Move to next question
  bool nextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      currentQuestionIndex++;
      return true;
    }
    return false;
  }

  void endGame() {
    isGameActive = false;
  }

  // Abstract methods to be implemented by specific game controllers
  void generateNewQuestion();
  String getQuestionText();
  
  // Helper methods
  String getOperationSymbol();
  
  double getDifficultyMultiplier() {
    return 1.0 + (currentQuestionIndex * 0.5);
  }

  int getRandomNumber(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }
}
