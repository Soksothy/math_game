class UserModel {
  String name;
  int age;
  bool isBoy;
  int avatarIndex;
  int level;
  int stars; // Replace 'coins' with 'stars'
  int experience;
  int highestScore;
  DateTime lastPlayedAt;
  List<String> achievementsUnlocked;
  Map<String, dynamic> topicScores; // Changed from Map<String, int> to allow both int and double

  // Constructor
  UserModel({
    required this.name,
    required this.age,
    required this.isBoy,
    required this.avatarIndex,
    this.level = 1,
    this.stars = 0, // Initialize stars
    this.experience = 0,
    this.highestScore = 0,
    DateTime? lastPlayedAt,
    List<String>? achievementsUnlocked,
    Map<String, dynamic>? topicScores, // Updated type
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

  // Add stars with validation
  void addStars(int amount) {
    if (amount < 0) throw ArgumentError('Star amount cannot be negative');
    stars += amount;
  }

  // Update topic score
  void updateTopicScore(String topic, int starsEarned) {
    // Track attempts as integer
    String attemptKey = topic;
    int currentAttempts = (topicScores[attemptKey] as int?) ?? 0;
    topicScores[attemptKey] = currentAttempts + 1;
    
    // Track total stars for this topic
    String starsKey = '${topic}_stars';
    int currentStars = (topicScores[starsKey] as int?) ?? 0;
    topicScores[starsKey] = currentStars + starsEarned;
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

  double getCategoryAverage(String category) {
    final attempts = topicScores[category] ?? 0;
    final totalStars = topicScores['${category}_stars'] ?? 0;
    return attempts > 0 ? (totalStars / attempts) : 0.0;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'isBoy': isBoy,
        'avatarIndex': avatarIndex,
        'level': level,
        'stars': stars, // Update 'coins' to 'stars'
        'experience': experience,
        'highestScore': highestScore,
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'achievementsUnlocked': achievementsUnlocked,
        'topicScores': topicScores,
      };

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? 'Player',
        age: json['age'] ?? 10,
        isBoy: json['isBoy'] ?? true,
        avatarIndex: json['avatarIndex'] ?? 0,
        level: json['level'] ?? 1,
        stars: json['stars'] ?? 0, // Ensure 'stars' is not null
        experience: json['experience'] ?? 0,
        highestScore: json['highestScore'] ?? 0,
        lastPlayedAt: json['lastPlayedAt'] != null
            ? DateTime.parse(json['lastPlayedAt'])
            : DateTime.now(),
        achievementsUnlocked: json['achievementsUnlocked'] != null
            ? List<String>.from(json['achievementsUnlocked'])
            : [],
        topicScores: json['topicScores'] != null
            ? Map<String, dynamic>.from(json['topicScores'])
            : {},
      );

  static UserModel defaultUser() {
    return UserModel(
      name: 'Player', // Default name
      age: 10, // Example default age
      isBoy: true, // Default gender
      avatarIndex: 0, // Default avatar index
      level: 1, // Starting level
      stars: 0, // Initialize 'stars' instead of 'coins'
    );
  }
}
