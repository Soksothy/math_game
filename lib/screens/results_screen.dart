import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart';
import 'package:confetti/confetti.dart';
import 'package:math_game/widgets/app_bar.dart';
import 'package:math_game/widgets/bottom_navigation_bar.dart';
import 'package:math_game/services/level_calculator.dart';
import 'package:math_game/services/user_storage.dart';
import 'package:math_game/widgets/animated_value.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;
  int _selectedIndex = 2;
  bool _hasUpdatedStats = false; // Add this flag

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  Widget _buildStatsCard(String title, String value, {Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF525252),
            ),
          ),
          const SizedBox(height: 8),
          child ?? Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFAF57),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UserModel user = args['userModel'];
    final int stars = args['stars'] ?? 0;
    final int totalQuestions = args['totalQuestions'] ?? 0;
    final Duration totalTime = args['totalTime'] ?? Duration.zero;

    // Calculate level progress
    final levelProgress = LevelCalculator.calculateProgress(user.stars + stars);
    final bool leveledUp = levelProgress.leveledUp;
    final int currentLevel = user.level;
    final int nextLevel = currentLevel + (leveledUp ? 1 : 0);

    return Scaffold(
      appBar: GameAppBar(
        user: user, // This user now has updated stars
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFBF2), Color(0xFFFFF0D6)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Great Job!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF525252),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatsCard(
                              'Stars',
                              '',
                              child: AnimatedValue(
                                value: stars,
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFAF57),
                                ),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                              ),
                            ),
                            _buildStatsCard('Time', _formatDuration(totalTime)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (leveledUp) ...[
                          const Text(
                            'Level Up!',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFF74CF48),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Level $currentLevel → $nextLevel',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF525252),
                            ),
                          ),
                        ],
                        const SizedBox(height: 48),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (!_hasUpdatedStats) { // Only update if not already done
                                user.stars += stars;
                                if (leveledUp) {
                                  user.level = nextLevel;
                                }
                                await UserStorage.saveUser(user);
                                _hasUpdatedStats = true; // Set flag to prevent multiple updates
                              }

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                (route) => false,
                                arguments: {'userModel': user}, // Pass the updated userModel
                              );
                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF74CF48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            ),
                            child: const Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/game',
                                (route) => false,
                                arguments: {
                                  'userModel': user,
                                  'gameType': args['gameType'] ?? 'addition', // Add gameType
                                  'gameName': args['gameName'] ?? 'Sum Sprint', // Add gameName
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF74CF48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            ),
                            child: const Text(
                            'Play Again',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
