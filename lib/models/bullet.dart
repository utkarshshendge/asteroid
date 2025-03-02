import 'dart:ui';

class Bullet {
  double x;
  double y;
  double vx;
  double vy;
  final double radius;

  Bullet({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    this.radius = 3,
  });

  void update(double dt, Size gameAreaSize) {
    x += vx * dt;
    y += vy * dt;
  }

  bool isOutOfBounds(Size size) {
    return x < 0 || x > size.width || y < 0 || y > size.height;
  }
}
