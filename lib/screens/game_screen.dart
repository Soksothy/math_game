import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:math_game/models/question_model.dart';
import 'package:math_game/widgets/timer_widget.dart';
import 'package:math_game/controller/base_controller.dart';
import 'package:math_game/controller/game_factory.dart';

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

  @override
  void initState() {
    super.initState();
    // Controller will be initialized in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String gameType = args['gameType'];
    
    // Initialize the appropriate controller
    gameController = GameControllerFactory.createController(gameType);
    gameController.startGame();
  }

  void handleAnswer(int answer) {
    if (isAnswerSelected) return;
    
    setState(() {
      isAnswerSelected = true;
      bool isCorrect = gameController.checkAnswer(answer);
      if (isCorrect) stars++;
    });

    // Wait 1 second before moving to next question
    Future.delayed(const Duration(seconds: 1), () {
      if (gameController.nextQuestion()) {
        setState(() {
          isAnswerSelected = false;
          remainingSeconds = 10;  // Reset timer for next question
        });
      } else {
        // Game finished
        gameController.endGame();
        // Navigate to results screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UserModel user = args['userModel'];
    final QuestionModel currentQuestion = gameController.questions[gameController.currentQuestionIndex];

    return Scaffold(
      appBar: GameTimerBar(
        user: user,
        stars: stars,
        remainingSeconds: remainingSeconds,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentQuestion.questionText,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: currentQuestion.options.map((option) {
                return ElevatedButton(
                  onPressed: isAnswerSelected ? null : () => handleAnswer(option),
                  child: Text(
                    option.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameController.endGame();
    super.dispose();
  }
}
