import 'dart:math';
import '../models/player.dart';
import '../models/particle.dart';

class CollisionDetector {
  static bool checkCollision(
    Player player,
    Particle particle, {
    double playerRadius = 10,
  }) {
    double dx = player.x - particle.x;
    double dy = player.y - particle.y;
    double distance = sqrt(dx * dx + dy * dy);
    return distance < (playerRadius + particle.size);
  }

  //  simple colision detect between two circles
  static bool checkCircleCollision(
      double x1, double y1, double r1, double x2, double y2, double r2) {
    double dx = x1 - x2;
    double dy = y1 - y2;
    double distance = sqrt(dx * dx + dy * dy);
    return distance < (r1 + r2);
  }
}
