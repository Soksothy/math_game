import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:math_game/widgets/timer_widget.dart';
import 'package:math_game/controller/base_controller.dart';
import 'package:math_game/controller/game_factory.dart';
import 'package:math_game/widgets/number_pad.dart';
import 'package:math_game/widgets/answer_controls.dart';
import 'package:math_game/widgets/question_display.dart';
import 'package:math_game/widgets/question_header.dart';  // Add this import
import 'dart:async';
import 'package:logger/logger.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BaseGameController gameController;
  int remainingSeconds = 10;  // 10 seconds per question
  int stars = 0;
  bool isAnswerSelected = false;
  String currentInput = '';
  bool? isCorrectAnswer;
  late Timer _timer;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    // Timer will be initialized in didChangeDependencies
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timeUp();
        }
      });
    });
  }

  void timeUp() {
    _timer.cancel();
    if (!mounted) return;
    if (!isAnswerSelected) {
      setState(() {
        isAnswerSelected = true;
        isCorrectAnswer = false; // Mark as incorrect if time runs out
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        moveToNextQuestion();
      });
    }
  }

  void moveToNextQuestion() {
    if (!mounted) return;
    if (gameController.nextQuestion()) {
      setState(() {
        isAnswerSelected = false;
        isCorrectAnswer = null;
        remainingSeconds = 10;
        currentInput = '';
      });
      logger.d('Moving to next question: ${gameController.getQuestionText()}'); // Debug log
      startTimer();
    } else {
      _timer.cancel();
      gameController.endGame();
      // Navigate to results screen
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String gameType = args['gameType'];
    
    gameController = GameControllerFactory.createController(gameType);
    gameController.startGame();
    startTimer(); // Start timer when game starts
  }

  void handleAnswer(int number) {
    if (isAnswerSelected) return;
    
    setState(() {
      currentInput += number.toString();
    });
  }

  void submitAnswer() {
    if (isAnswerSelected || currentInput.isEmpty) return;
    
    _timer.cancel(); // Stop the current timer
    try {
      int answer = int.parse(currentInput);
      logger.d('Question: ${gameController.getQuestionText()}'); // Debug log
      logger.d('User answer: $answer'); // Debug log
      logger.d('Correct answer: ${gameController.correctAnswer}'); // Debug log
      
      if (!mounted) return;
      
      setState(() {
        isAnswerSelected = true;
        isCorrectAnswer = gameController.checkAnswer(answer);
        if (isCorrectAnswer!) {
          stars++;
          logger.i('Correct answer!');
        } else {
          logger.w('Wrong answer. User input: $answer, Expected: ${gameController.correctAnswer}');
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        moveToNextQuestion();
      });
    } catch (e) {
      logger.e('Error parsing answer: $e'); // Debug log
      // Handle invalid input
      if (!mounted) return;
      setState(() {
        currentInput = '';
      });
      startTimer(); // Restart timer if there was an error
    }
  }

  void clearInput() {
    if (!isAnswerSelected) {
      setState(() {
        currentInput = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UserModel user = args['userModel'];

    return Scaffold(
      appBar: GameTimerBar(
        user: user,
        stars: stars,
        remainingSeconds: remainingSeconds,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            QuestionHeader(
              currentQuestion: gameController.currentQuestionNumber,
              totalQuestions: gameController.totalQuestions,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuestionDisplay(
                    question: gameController.getQuestionText(), // Use controller method directly
                    userInput: currentInput,
                    isCorrect: isCorrectAnswer,
                    textStyle: const TextStyle(
                      fontFamily: 'Swiss',
                      fontSize: 45, // Increased font size for question
                    ),
                    inputTextStyle: const TextStyle(
                      fontFamily: 'Swiss',
                      fontSize: 32, // Smaller font size for input answer
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AnswerControls(
              onClear: clearInput,
              onSubmit: submitAnswer,
              isEnabled: !isAnswerSelected,
            ),
            NumberPad(
              onNumberSelected: handleAnswer,
              textStyle: const TextStyle(
                fontFamily: 'Swiss',
                fontSize: 32, // Increased font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    gameController.endGame();
    super.dispose();
  }
}
