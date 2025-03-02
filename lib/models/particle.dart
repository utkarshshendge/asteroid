import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double size;
  double vx;
  double vy;
  List<Offset> polygon;
  double collisionRadius;

  final double originalSize;
  final List<Offset> originalPolygon;
  final double originalCollisionRadius;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.vx,
    required this.vy,
    required this.polygon,
    required this.collisionRadius,
    required this.originalSize,
    required this.originalPolygon,
    required this.originalCollisionRadius,
  });

  factory Particle.random(
    double screenWidth,
    double screenHeight, {
    double minSize = 2.0,
    double maxSize = 8.0,
    double minSpeed = -50,
    double maxSpeed = 50,
  }) {
    final random = Random();
    double baseSize = minSize + random.nextDouble() * (maxSize - minSize);
    double x = random.nextDouble() * screenWidth;
    double y = random.nextDouble() * screenHeight;
    double vx = minSpeed + random.nextDouble() * (maxSpeed - minSpeed);
    double vy = minSpeed + random.nextDouble() * (maxSpeed - minSpeed);

    int vertexCount = random.nextInt(4) + 5;
    List<Offset> vertices = [];
    for (int i = 0; i < vertexCount; i++) {
      double baseAngle = (2 * pi / vertexCount) * i;
      double angleVariation = (random.nextDouble() - 0.5) * (pi / vertexCount);
      double angle = baseAngle + angleVariation;
      double r = baseSize * (0.8 + random.nextDouble() * 0.4);
      vertices.add(Offset(r * cos(angle), r * sin(angle)));
    }
    double collisionRadius =
        vertices.fold(0, (prev, v) => v.distance > prev ? v.distance : prev);

    return Particle(
      x: x,
      y: y,
      size: baseSize,
      vx: vx,
      vy: vy,
      polygon: List.from(vertices),
      collisionRadius: collisionRadius,
      originalSize: baseSize,
      originalPolygon: List.from(vertices),
      originalCollisionRadius: collisionRadius,
    );
  }

  void update(double dt, Size screenSize) {
    x += vx * dt;
    y += vy * dt;

    if (x - collisionRadius < 0) {
      x = collisionRadius;
      vx = -vx;
    } else if (x + collisionRadius > screenSize.width) {
      x = screenSize.width - collisionRadius;
      vx = -vx;
    }
    if (y - collisionRadius < 0) {
      y = collisionRadius;
      vy = -vy;
    } else if (y + collisionRadius > screenSize.height) {
      y = screenSize.height - collisionRadius;
      vy = -vy;
    }
  }
}
