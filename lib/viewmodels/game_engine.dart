import 'package:asteroid_game/viewmodels/bullter_view_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'player_view_model.dart';
import 'particle_view_model.dart';
import '../models/player.dart';
import '../models/particle.dart';
import '../utils/collision_detector.dart';
import '../constants/difficulty.dart';

class GameEngine extends ChangeNotifier {
  final PlayerViewModel playerViewModel;
  final ParticleViewModel particleViewModel;
  final BulletViewModel bulletViewModel;
  Duration elapsedTime = Duration.zero;
  bool gameOver = false;
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;
  Size gameAreaSize = Size.zero;
  bool _isStarted = false;

  Difficulty currentDifficulty = Difficulty.easy;

  GameEngine({
    required this.playerViewModel,
    required this.particleViewModel,
    required this.bulletViewModel,
  });

  void start(TickerProvider tickerProvider, Size gameAreaSize) {
    if (_isStarted) return;
    _isStarted = true;
    this.gameAreaSize = gameAreaSize;
    elapsedTime = Duration.zero;
    gameOver = false;
    particleViewModel.initialize(gameAreaSize,
        params: difficultySettings[currentDifficulty]);
    _lastTick = Duration.zero;
    _ticker = tickerProvider.createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    if (gameOver) return;
    final dt = (elapsed - _lastTick).inMilliseconds / 1000;
    _lastTick = elapsed;
    elapsedTime += Duration(milliseconds: (dt * 1000).toInt());

    particleViewModel.update(dt, gameAreaSize);
    bulletViewModel.update(dt, gameAreaSize);

    // Check collision
    for (var particle in particleViewModel.particles) {
      if (CollisionDetector.checkCollision(
        Player(x: playerViewModel.x, y: playerViewModel.y),
        particle,
      )) {
        gameOver = true;
        stop();
        notifyListeners();
        return;
      }
    }

    // collision check betn bullets and particles.
    for (int i = bulletViewModel.bullets.length - 1; i >= 0; i--) {
      var bullet = bulletViewModel.bullets[i];
      for (int j = particleViewModel.particles.length - 1; j >= 0; j--) {
        var particle = particleViewModel.particles[j];
        if (CollisionDetector.checkCircleCollision(bullet.x, bullet.y,
            bullet.radius, particle.x, particle.y, particle.collisionRadius)) {
          bulletViewModel.bullets.removeAt(i);
          particleViewModel.particles.removeAt(j);
          final diffParams = difficultySettings[currentDifficulty]!;
          Particle newParticle = Particle.random(
            gameAreaSize.width,
            gameAreaSize.height,
            minSize: diffParams.minAsteroidSize,
            maxSize: diffParams.maxAsteroidSize,
            minSpeed: -50 * diffParams.asteroidSpeedMultiplier,
            maxSpeed: 50 * diffParams.asteroidSpeedMultiplier,
          );
          particleViewModel.particles.add(newParticle);
          break;
        }
      }
    }
    notifyListeners();
  }

  void changeDifficulty(Difficulty newDifficulty,
      {bool increaseParticleSize = false}) {
    if (newDifficulty == currentDifficulty) return;
    var oldParams = difficultySettings[currentDifficulty]!;
    var newParams = difficultySettings[newDifficulty]!;
    final effectiveNewParams = increaseParticleSize
        ? DifficultyParems(
            minAsteroidSize: newParams.minAsteroidSize * 1.2,
            maxAsteroidSize: newParams.maxAsteroidSize * 1.2,
            asteroidSpeedMultiplier: newParams.asteroidSpeedMultiplier,
            bulletSpeeed: newParams.bulletSpeeed,
          )
        : newParams;
    particleViewModel.updateDifficulty(effectiveNewParams, oldParams);
    bulletViewModel.bulletSpeeed = effectiveNewParams.bulletSpeeed;
    currentDifficulty = newDifficulty;
    notifyListeners();
  }

  void stop() {
    _ticker.stop();
  }

  void disposeEngine() {
    _ticker.dispose();
  }
}
