import 'dart:math';
import 'package:flutter/material.dart';
import '../models/bullet.dart';

class BulletViewModel extends ChangeNotifier {
  final List<Bullet> bullets = [];
  double bulletSpeeed = 300;

  void shoot(double startX, double startY, double angle) {
    double vx = bulletSpeeed * cos(angle);
    double vy = bulletSpeeed * sin(angle);
    bullets.add(Bullet(x: startX, y: startY, vx: vx, vy: vy));
    notifyListeners();
  }

  void update(double dt, Size gameAreaSize) {
    for (var bullet in bullets) {
      bullet.update(dt, gameAreaSize);
    }
    bullets.removeWhere((bullet) => bullet.isOutOfBounds(gameAreaSize));
    notifyListeners();
  }
}
