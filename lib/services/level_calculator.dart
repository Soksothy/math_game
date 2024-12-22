class LevelProgress {
  final bool leveledUp;
  final double progress;

  LevelProgress(this.leveledUp, this.progress);
}

class LevelCalculator {
  static LevelProgress calculateProgress(int totalStars) {
    const int starsPerLevel = 10;

    final double progress = (totalStars % starsPerLevel) / starsPerLevel;
    final bool leveledUp = (totalStars % starsPerLevel) == 0 && totalStars != 0;

    return LevelProgress(leveledUp, progress);
  }
}
