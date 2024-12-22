import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../models/user_model.dart';

class LeaderboardScreen extends StatelessWidget {
  final UserModel user;
  
  const LeaderboardScreen({
    super.key,
    required this.user,
  });

  String _formatPlayTime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}hr ${remainingMinutes}min';
  }

  Widget _buildOverviewCard(UserModel user) {
    final totalAttempts = user.topicScores.entries
        .where((e) => !e.key.contains('_best'))
        .fold<int>(0, (sum, e) => sum + (e.value as int)); // Keep as int

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/asset/coin.png', width: 30, height: 30),
          const SizedBox(width: 8),
          Text(
            'Total Stars: ${user.stars}',
            style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFAF57),
            ),
          ),
        ],
          ),
          const SizedBox(height: 12),
          Text(
        'Quizzes Completed : $totalAttempts',
        style: const TextStyle(fontSize: 18, color: Color(0xFF525252)),
          ),
          const SizedBox(height: 8),
          Text(
        'Play Time: ${_formatPlayTime(user.lastPlayedAt.difference(DateTime.now()).inMinutes.abs())}',
        style: const TextStyle(fontSize: 18, color: Color(0xFF525252)),
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateCategoryAverages() {
    Map<String, double> averages = {};
    
    void calculateForCategory(String category) {
      final attempts = user.topicScores[category] ?? 0;
      final totalStars = user.topicScores['${category}_stars'] ?? 0;
      final average = attempts > 0 ? (totalStars / attempts) : 0.0;
      averages[category] = average;
    }

    calculateForCategory('addition');
    calculateForCategory('subtraction');
    calculateForCategory('multiplication');
    calculateForCategory('division');

    return averages;
  }

  Widget _buildCategoryCard(String title, String imagePath, Map<String, dynamic> stats, double averageStars) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF525252),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attempts: ${stats['attempts']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF525252),
                      ),
                    ),
                    Text(
                      'Average: ${averageStars.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFAF57),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, dynamic>> _getCategoryStats() {
    return {
      'Addition': {
        'attempts': user.topicScores['addition'] as int? ?? 0,
        'total_stars': user.topicScores['addition_stars'] as int? ?? 0,
        'image': 'lib/asset/add1.png',
      },
      'Subtraction': {
        'attempts': user.topicScores['subtraction'] as int? ?? 0,
        'total_stars': user.topicScores['subtraction_stars'] as int? ?? 0,
        'image': 'lib/asset/sub1.png',
      },
      'Multiplication': {
        'attempts': user.topicScores['multiplication'] as int? ?? 0,
        'total_stars': user.topicScores['multiplication_stars'] as int? ?? 0,
        'image': 'lib/asset/mul1.png',
      },
      'Division': {
        'attempts': user.topicScores['division'] as int? ?? 0,
        'total_stars': user.topicScores['division_stars'] as int? ?? 0,
        'image': 'lib/asset/div1.png',
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoryStats = _getCategoryStats();
    final categoryAverages = _calculateCategoryAverages();

    return Scaffold(
      appBar: GameAppBar(user: user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
              'Great progress, ${user.name}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF525252),
              ),
              ),
            ),
            const SizedBox(height: 16),
            _buildOverviewCard(user),
            const SizedBox(height: 24),
            const Text(
              'Category Progress',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF525252),
              ),
            ),
            const SizedBox(height: 16),
            ...categoryStats.entries.map((entry) {
              final categoryName = entry.key.toLowerCase();
              return _buildCategoryCard(
                entry.key,
                entry.value['image'] as String,
                entry.value,
                categoryAverages[categoryName] ?? 0.0,
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 3,
        onIndexChanged: (index) {
          if (index != 3) {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: {'userModel': user},
            );
          }
        },
      ),
    );
  }
}
