class DishLevelInfo {
  DishLevelInfo({
    required this.level,
    required this.exp,
    required this.energy,
  });

  factory DishLevelInfo.from(
      int level,
      int exp,
      int energy) {
    return DishLevelInfo(
      level: level,
      exp: exp,
      energy: energy,
    );
  }

  final int level;
  final int exp;
  final int energy;
}