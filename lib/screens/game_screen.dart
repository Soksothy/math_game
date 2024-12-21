import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:math_game/widgets/timer_widget.dart';
import 'package:math_game/controller/base_controller.dart';
import 'package:math_game/controller/game_factory.dart';
import 'package:math_game/widgets/number_pad.dart';
import 'package:math_game/widgets/answer_controls.dart';
import 'package:math_game/widgets/question_display.dart';
import 'package:math_game/widgets/question_header.dart';
import 'package:math_game/widgets/answer_options.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:math_game/services/user_storage.dart';
import 'package:math_game/widgets/plus_grid.dart';
import 'package:math_game/controller/plus_grid_controller.dart';
import 'package:math_game/widgets/minus_grid.dart';
import 'package:math_game/controller/minus_grid_controller.dart';
import 'package:math_game/widgets/judgement_question.dart';
import 'package:math_game/controller/judgement_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late BaseGameController gameController;
  late int initialDuration;
  int remainingSeconds = 10;
  int stars = 0;
  bool isAnswerSelected = false;
  String currentInput = '';
  bool? isCorrectAnswer;
  final logger = Logger();
  late String gameName;
  int questionIndex = 0;
  late UserModel userModel;
  DateTime? startTime;
  Duration totalTime = Duration.zero;
  late Map<String, dynamic> args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    gameController.endGame();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void moveToNextQuestion() {
    if (!mounted) return;
    
    if (gameController.nextQuestion()) {
      setState(() {
        isAnswerSelected = false;
        isCorrectAnswer = null;
        currentInput = '';
        remainingSeconds = initialDuration;
        questionIndex += 1;
      });
    } else {
      gameController.endGame();
      totalTime = DateTime.now().difference(startTime!);
      UserStorage.saveUser(userModel);
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {
          'userModel': userModel,
          'stars': stars,
          'gameName': gameName,
          'gameType': args['gameType'],
          'totalQuestions': gameController.totalQuestions,
          'totalTime': totalTime,
          'coinsEarned': stars * 10,
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String gameType = args['gameType'];
    gameName = args['gameName'];
    userModel = args['userModel'];
    initialDuration = gameName == 'Plus Grid' ? 30 : gameName == 'Minus Grid' ? 20 : 10;
    remainingSeconds = initialDuration;
    gameController = GameControllerFactory.createController(
      gameType,
      gameName: gameName,
    );
    gameController.startGame();
  }

  void handleAnswer(int number) {
    if (isAnswerSelected) return;
    
    setState(() {
      currentInput += number.toString();
    });
  }

  void submitAnswer() {
    if (isAnswerSelected || currentInput.isEmpty) return;
    
    try {
      int answer = int.parse(currentInput);
      
      setState(() {
        isAnswerSelected = true;
        isCorrectAnswer = gameController.checkAnswer(answer);
        if (isCorrectAnswer!) {
          stars++;
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        moveToNextQuestion();
      });
    } catch (e) {
      logger.e('Error parsing answer: $e');
      setState(() {
        currentInput = '';
      });
    }
  }

  void clearInput() {
    if (!isAnswerSelected) {
      setState(() {
        currentInput = '';
      });
    }
  }

  void timeUp() {
    if (!mounted) return;
    if (!isAnswerSelected) {
      setState(() {
        isAnswerSelected = true;
        isCorrectAnswer = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        moveToNextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = userModel;
    final bool isOptionsGame = gameName == 'Sum Sprint' || 
                             gameName == 'Minus Mastery' || 
                             gameName == 'Mul Hero' ||
                             gameName == 'Div Genius';
    final bool isPlusGridGame = gameName == 'Plus Grid';
    final bool isMinusGridGame = gameName == 'Minus Grid';
    final bool isGridGame = isPlusGridGame || isMinusGridGame;
    final bool isJudgementGame = gameName == 'Judgement' || 
                                gameName == 'Judge It' || 
                                gameName == 'Perfect Mul' ||
                                gameName == 'Side Quest';

    return Scaffold(
      appBar: GameTimerBar(
        key: ValueKey(questionIndex),
        user: user,
        stars: stars,
        duration: initialDuration,
        onTimerComplete: timeUp,
        onTimeChange: (time) {
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                remainingSeconds = int.parse(time);
              });
            }
          });
        },
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
                  if (isGridGame) ...[
                    if (isPlusGridGame)
                      PlusGrid(
                        controller: gameController as PlusGridController,
                        onAnswerValidated: (isCorrect) {
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
                        },
                      )
                    else
                      MinusGrid(
                        controller: gameController as MinusGridController,
                        onAnswerValidated: (isCorrect) {
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
                        },
                      ),
                  ] else if (isJudgementGame) ...[
                    JudgementQuestion(
                      questionText: gameController.getQuestionText(),
                      onAnswerSelected: (bool answer) {
                        if (isAnswerSelected) return;
                        
                        final judgementController = gameController as JudgementController;
                        bool isCorrect = judgementController.checkAnswer(answer);
                        
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
                      },
                      isEnabled: !isAnswerSelected,
                      correctCount: (gameController as JudgementController).correctCount,
                      wrongCount: (gameController as JudgementController).wrongCount,
                    ),
                  ] else ...[
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!isOptionsGame && !isGridGame && !isJudgementGame) ...[
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
