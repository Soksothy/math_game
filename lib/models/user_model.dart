class UserModel {
  String name;
  int age;
  bool isBoy;
  int avatarIndex;
  int level;
  int stars; 
  DateTime lastPlayedAt;
  Map<String, dynamic> topicScores;

  UserModel({
    required this.name,
    required this.age,
    required this.isBoy,
    required this.avatarIndex,
    this.level = 1,
    this.stars = 0,
    DateTime? lastPlayedAt,
    Map<String, dynamic>? topicScores,
  })  : assert(age > 0 && age < 120, 'Age must be between 1 and 120'),
        assert(avatarIndex >= 0, 'Avatar index must be non-negative'),
        lastPlayedAt = lastPlayedAt ?? DateTime.now(),
        topicScores = topicScores ?? {};

  String get avatarPath => 'lib/asset/avatar/${avatarIndex + 1}.png';

  void updateTopicScore(String topic, int starsEarned) {
    String attemptKey = topic;
    int currentAttempts = (topicScores[attemptKey] as int?) ?? 0;
    topicScores[attemptKey] = currentAttempts + 1;
    
    String starsKey = '${topic}_stars';
    int currentStars = (topicScores[starsKey] as int?) ?? 0;
    topicScores[starsKey] = currentStars + starsEarned;
  }

  double getCategoryAverage(String category) {
    final attempts = topicScores[category] ?? 0;
    final totalStars = topicScores['${category}_stars'] ?? 0;
    return attempts > 0 ? (totalStars / attempts) : 0.0;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'isBoy': isBoy,
        'avatarIndex': avatarIndex,
        'level': level,
        'stars': stars,
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'topicScores': topicScores,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? 'Player',
        age: json['age'] ?? 10,
        isBoy: json['isBoy'] ?? true,
        avatarIndex: json['avatarIndex'] ?? 0,
        level: json['level'] ?? 1,
        stars: json['stars'] ?? 0,
        lastPlayedAt: json['lastPlayedAt'] != null
            ? DateTime.parse(json['lastPlayedAt'])
            : DateTime.now(),
        topicScores: json['topicScores'] != null
            ? Map<String, dynamic>.from(json['topicScores'])
            : {},
      );

  static UserModel defaultUser() {
    return UserModel(
      name: 'Player',
      age: 10,
      isBoy: true,
      avatarIndex: 0,
      level: 1,
      stars: 0,
    );
  }
}
