import 'dart:math';
import '../models/question_model.dart';
import 'package:logger/logger.dart';

abstract class BaseGameController {
  final int totalQuestions = 10;
  List<QuestionModel> questions = [];
  int currentQuestionIndex = 0;
  bool isGameActive = false;
  List<int> currentNumbers = [];
  int correctAnswer = 0;
  int score = 0;
  final logger = Logger();
  int currentQuestionNumber = 1;

  // Add this field at the top with other fields
  List<int> _options = [];
  List<int> get options => _options;

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
        options: generateOptions(correctAnswer),
      ));
    }
    logger.i('Game started with $totalQuestions questions.');
  }

  // Optimize question generation
  List<int> generateOptions(int correctAnswer) {
    final Set<int> optionSet = {correctAnswer};
    final int range = (correctAnswer * 0.5).round();
    final Random random = Random();
    
    while (optionSet.length < 4) {
      int offset = random.nextInt(range * 2 + 1) - range;
      int option = correctAnswer + offset;
      if (option > 0 && option != correctAnswer) {
        optionSet.add(option);
      }
    }
    
    _options = optionSet.toList()..shuffle(random);
    return _options;
  }

  // Check answer and update score
  bool checkAnswer(int userAnswer) {
    logger.d('Checking answer - User input: $userAnswer, Correct answer: $correctAnswer');
    if (!isGameActive) return false;
    
    bool isCorrect = userAnswer == correctAnswer;
    questions[currentQuestionIndex].isAnswered = true;
    questions[currentQuestionIndex].isCorrect = isCorrect;
    
    if (isCorrect) score++;
    
    return isCorrect;
  }

  // Move to next question
  bool nextQuestion() {
    if (currentQuestionNumber < totalQuestions) {
      currentQuestionNumber++;
      if (currentQuestionIndex < totalQuestions - 1) {
        currentQuestionIndex++;
        // Update current numbers and correct answer for the new question
        currentNumbers = questions[currentQuestionIndex].numbers;
        correctAnswer = questions[currentQuestionIndex].correctAnswer;
        logger.d('Next question loaded: ${getQuestionText()} = $correctAnswer');
      }
      return true;
    }
    return false;
  }

  void endGame() {
    isGameActive = false;
    logger.i('Game ended. Final score: $score');
  }

  // Abstract methods to be implemented by specific game controllers
  void generateNewQuestion();
  String getQuestionText() {
    QuestionModel question = getCurrentQuestion();
    return '${question.numbers[0]} ${question.operation} ${question.numbers[1]} =';
  }
  
  // Helper methods
  String getOperationSymbol();
  
  double getDifficultyMultiplier() {
    return 1.0 + (currentQuestionIndex * 0.5);
  }

  int getRandomNumber(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  QuestionModel getCurrentQuestion() {
    return questions[currentQuestionIndex];
  }
}

// Add this class to represent a question
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
