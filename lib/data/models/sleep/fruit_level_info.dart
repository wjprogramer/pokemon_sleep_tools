class FruitLevelInfo {
  FruitLevelInfo({
    required this.level,
    required this.energy,
  });

  factory FruitLevelInfo.from(
      int level,
      int energy) {
    return FruitLevelInfo(
      level: level,
      energy: energy,
    );
  }

  final int level;
  final int energy;
}