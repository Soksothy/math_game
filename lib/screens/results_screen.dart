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

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  int _selectedIndex = 2;
  bool _hasUpdatedStats = false;
  int? _initialLevel; // Add this field to track initial level

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // Initialize with default value
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _progressController.dispose();
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

  void updateUserStats(UserModel user, String gameType, int stars, int totalQuestions) {
    // Update topic scores with actual stars earned
    user.updateTopicScore(gameType, stars);
    
    // Save user data
    UserStorage.saveUser(user);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UserModel user = args['userModel'];
    final int stars = args['stars'] ?? 0;
    final Duration totalTime = args['totalTime'] ?? Duration.zero;
    final int totalQuestions = args['totalQuestions'] ?? 10; // Add this line

    // Store initial level on first build
    _initialLevel ??= user.level;

    // Update user stats only once
    if (!_hasUpdatedStats) {
      updateUserStats(user, args['gameType'], stars, totalQuestions);
      user.stars += stars;
      
      // Calculate new level based on total stars
      final int newLevel = (user.stars / 10).floor() + 1;
      
      if (newLevel > user.level) {
        user.level = newLevel;
      }
      
      UserStorage.saveUser(user);
      _hasUpdatedStats = true;

      // Update the animation's end value and restart
      _progressAnimation = Tween<double>(
        begin: 0.0,
        end: (user.stars % 10) / 10,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController.forward(from: 0.0);
    }

    final bool leveledUp = user.level > _initialLevel!;

    return Scaffold(
      appBar: GameAppBar(
        user: user, 
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 231, 231, 231)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Change from center to start
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Add small top padding
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'CONGRATULATIONS!',
                      style: TextStyle(
                        fontSize: 35, // Reduced from 48
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFAF57),
                      ),
                    ),
                    const SizedBox(height: 16), // Reduced from 24
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildStatsCard(
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
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildStatsCard('Time', _formatDuration(totalTime)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Reduced spacing
                    // Level Progress Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(12),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Level ${user.level}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF525252),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return Text(
                                    '${((_progressAnimation.value * 10).floor())}/10 stars',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFAF57),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: _progressAnimation.value,
                                  minHeight: 8, // Reduced from 12
                                  backgroundColor: Colors.grey[200],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFAF57),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced from 12
                    Image.asset(
                      leveledUp ? 'lib/asset/up_level.png' : 'lib/asset/win.png',
                      height: 180, // Reduced from 200
                    ),
                    const SizedBox(height: 8), // Reduced from 12
                    Text(
                       'Great Jop, ${user.name}!',
                      style: const TextStyle(
                        fontSize: 23, // Reduced from 32
                        color: Color(0xFF525252),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (leveledUp) ...[
                      const Text(
                        'Level Up!',
                        style: TextStyle(
                          fontSize: 28, // Reduced from 32
                          color: Color(0xFF74CF48),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Level $_initialLevel → ${user.level}',
                        style: const TextStyle(
                          fontSize: 20, // Reduced from 24
                          color: Color(0xFF525252),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home',
                            (route) => false,
                            arguments: {'userModel': user}, // Pass the updated userModel
                          );
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 252, 189, 123),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36, // Reduced padding
                          vertical: 12, // Reduced padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                      const SizedBox(width: 12), // Reduced from 16
                      ElevatedButton(
                        onPressed: () {
                          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                          Navigator.pushReplacementNamed(
                            context,
                            '/game',
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
                          horizontal: 36, // Reduced padding
                          vertical: 12, // Reduced padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        ),
                        child: const Text(
                        'Retry',
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
              ],
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
