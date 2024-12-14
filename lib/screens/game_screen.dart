import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:math_game/widgets/timer_widget.dart';
import 'package:math_game/controller/base_controller.dart';
import 'package:math_game/controller/game_factory.dart';
import 'package:math_game/widgets/number_pad.dart';
import 'package:math_game/widgets/answer_controls.dart';
import 'package:math_game/widgets/question_display.dart';
import 'package:math_game/widgets/question_header.dart';  // Add this import
import 'package:math_game/widgets/answer_options.dart'; // Add this import
import 'dart:async';
import 'package:logger/logger.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late BaseGameController gameController;
  int remainingSeconds = 10;  // 10 seconds per question
  int stars = 0;
  bool isAnswerSelected = false;
  String currentInput = '';
  bool? isCorrectAnswer;
  Timer? _timer; // Make timer nullable and remove late
  final logger = Logger();
  late String gameName; // Add this variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize timer with a dummy that does nothing
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _timer?.cancel(); // Safe cancel in dispose
    gameController.endGame();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel(); // Safe cancel
    } else if (state == AppLifecycleState.resumed) {
      if (gameController.isGameActive && !isAnswerSelected) {
        startTimer();
      }
    }
  }

  // Optimize timer management
  void startTimer() {
    _timer?.cancel(); // Safely cancel existing timer if any
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timeUp();
      }
    });
  }

  void timeUp() {
    _timer?.cancel();
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

  // Optimize state updates
  void moveToNextQuestion() {
    if (!mounted) return;
    
    if (gameController.nextQuestion()) {
      // Batch state updates
      setState(() {
        isAnswerSelected = false;
        isCorrectAnswer = null;
        remainingSeconds = 10;
        currentInput = '';
      });
      
      // Delay timer start slightly to ensure smooth transition
      Future.microtask(() {
        if (mounted) {
          startTimer();
        }
      });
    } else {
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }
      gameController.endGame();
      // Navigate to results screen
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String gameType = args['gameType'];
    gameName = args['gameName']; // Get the game name

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
    
    _timer?.cancel(); // Stop the current timer
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
    final String gameName = args['gameName'];

    // Determine if this is an options-based game
    final bool isOptionsGame = gameName == 'Sum Sprint' || gameName == 'Minus Mastery';

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
                    question: gameController.getQuestionText(),
                    userInput: isOptionsGame ? '?' : currentInput,
                    isCorrect: isCorrectAnswer,
                    textStyle: const TextStyle(
                      fontFamily: 'Swiss',
                      fontSize: 45,
                    ),
                    inputTextStyle: const TextStyle(
                      fontFamily: 'Swiss',
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isOptionsGame)
                    AnswerOptions(
                      options: gameController.getCurrentQuestion().options,
                      onOptionSelected: handleOptionSelected,
                      isEnabled: !isAnswerSelected,
                      optionSize: 80,
                      rows: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!isOptionsGame) ...[
              AnswerControls(
                onClear: clearInput,
                onSubmit: submitAnswer,
                isEnabled: !isAnswerSelected,
              ),
              NumberPad(
                onNumberSelected: handleAnswer,
                textStyle: const TextStyle(
                  fontFamily: 'Swiss',
                  fontSize: 32,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void handleOptionSelected(int selectedOption) {
    if (isAnswerSelected) return;

    _timer?.cancel(); // Stop the current timer
    bool isCorrect = gameController.checkAnswer(selectedOption);

    setState(() {
      isAnswerSelected = true;
      isCorrectAnswer = isCorrect;
      if (isCorrect) {
        stars++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      moveToNextQuestion();
    });
  }
}
