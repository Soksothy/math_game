class UserModel {
  String name;
  int age;
  bool isBoy;
  int avatarIndex;
  int level;
  int coins;
  int experience;
  int highestScore;
  DateTime lastPlayedAt;
  List<String> achievementsUnlocked;
  Map<String, int> topicScores; // Store scores for different math topics

  // Constructor
  UserModel({
    required this.name,
    required this.age,
    required this.isBoy,
    required this.avatarIndex,
    this.level = 1,
    this.coins = 0,
    this.experience = 0,
    this.highestScore = 0,
    DateTime? lastPlayedAt,
    List<String>? achievementsUnlocked,
    Map<String, int>? topicScores,
  })  : assert(age > 0 && age < 120, 'Age must be between 1 and 120'),
        assert(avatarIndex >= 0, 'Avatar index must be non-negative'),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        achievementsUnlocked = achievementsUnlocked ?? [],
        topicScores = topicScores ?? {};

  // Get avatar image path
  String get avatarPath => 'lib/asset/avatar/${avatarIndex + 1}.png';

  // Calculate user level based on experience
  void calculateLevel() {
    // Simple level calculation: every 1000 XP = 1 level
    level = (experience / 1000).floor() + 1;
  }

  // Add experience points and update level with validation
  void addExperience(int points) {
    if (points < 0) throw ArgumentError('Experience points cannot be negative');
    experience += points;
    calculateLevel();
  }

  // Add coins with validation
  void addCoins(int amount) {
    if (amount < 0) throw ArgumentError('Coin amount cannot be negative');
    coins += amount;
  }

  // Update topic score
  void updateTopicScore(String topic, int score) {
    if (!topicScores.containsKey(topic) || score > topicScores[topic]!) {
      topicScores[topic] = score;
    }
  }

  // Get current level progress percentage
  double getLevelProgress() {
    final currentLevelXP = (level - 1) * 1000;
    final xpInCurrentLevel = experience - currentLevelXP;
    return (xpInCurrentLevel / 1000).clamp(0.0, 1.0);
  }

  // Check and unlock achievement
  bool unlockAchievement(String achievementId) {
    if (!achievementsUnlocked.contains(achievementId)) {
      achievementsUnlocked.add(achievementId);
      return true;
    }
    return false;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'isBoy': isBoy,
        'avatarIndex': avatarIndex,
        'level': level,
        'coins': coins,
        'experience': experience,
        'highestScore': highestScore,
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'achievementsUnlocked': achievementsUnlocked,
        'topicScores': topicScores,
      };

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
        age: json['age'],
        isBoy: json['isBoy'],
        avatarIndex: json['avatarIndex'],
        level: json['level'],
        coins: json['coins'],
        experience: json['experience'],
        highestScore: json['highestScore'],
        lastPlayedAt: DateTime.parse(json['lastPlayedAt']),
        achievementsUnlocked: List<String>.from(json['achievementsUnlocked']),
        topicScores: Map<String, int>.from(json['topicScores']),
      );
}
