import 'package:flutter/material.dart';
import '../models/particle.dart';
import '../constants/difficulty.dart';

class ParticleViewModel extends ChangeNotifier {
  List<Particle> particles = [];
  final int particleCount;

  ParticleViewModel({this.particleCount = 50});

  void initialize(Size screenSize, {DifficultyParems? params}) {
    final DifficultyParems p = params ?? difficultySettings[Difficulty.easy]!;
    particles = List.generate(
      particleCount,
      (_) => Particle.random(
        screenSize.width,
        screenSize.height,
        minSize: p.minAsteroidSize,
        maxSize: p.maxAsteroidSize,
        minSpeed: -50 * p.asteroidSpeedMultiplier,
        maxSpeed: 50 * p.asteroidSpeedMultiplier,
      ),
    );
    notifyListeners();
  }

  void updateDifficulty(
      DifficultyParems newParams, DifficultyParems oldParams) {
    //  a fixed reference from the "easy" difficulty.
    double referenceMax = difficultySettings[Difficulty.easy]!.maxAsteroidSize;
    double newSizeScale = newParams.maxAsteroidSize / referenceMax;
    double speedFactor =
        newParams.asteroidSpeedMultiplier / oldParams.asteroidSpeedMultiplier;
    for (var particle in particles) {
      particle.size = particle.originalSize * newSizeScale;
      particle.collisionRadius =
          particle.originalCollisionRadius * newSizeScale;
      particle.polygon = particle.originalPolygon
          .map((vertex) => vertex * newSizeScale)
          .toList();
      particle.vx *= speedFactor;
      particle.vy *= speedFactor;
    }
    notifyListeners();
  }

  void update(double dt, Size screenSize) {
    for (var particle in particles) {
      particle.update(dt, screenSize);
    }
    notifyListeners();
  }
}
