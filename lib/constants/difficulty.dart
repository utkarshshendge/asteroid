enum Difficulty { easy, medium, hard }

class DifficultyParems {
  final double minAsteroidSize;
  final double maxAsteroidSize;
  final double asteroidSpeedMultiplier;
  final double bulletSpeeed;

  const DifficultyParems({
    required this.minAsteroidSize,
    required this.maxAsteroidSize,
    required this.asteroidSpeedMultiplier,
    required this.bulletSpeeed,
  });
}

const Map<Difficulty, DifficultyParems> difficultySettings = {
  Difficulty.easy: DifficultyParems(
    minAsteroidSize: 12,
    maxAsteroidSize: 12.0,
    asteroidSpeedMultiplier: 1.0,
    bulletSpeeed: 500,
  ),
  Difficulty.medium: DifficultyParems(
    minAsteroidSize: 8,
    maxAsteroidSize: 10.0,
    asteroidSpeedMultiplier: 2,
    bulletSpeeed: 250,
  ),
  Difficulty.hard: DifficultyParems(
    minAsteroidSize: 6,
    maxAsteroidSize: 8.0,
    asteroidSpeedMultiplier: 4,
    bulletSpeeed: 100,
  ),
};
