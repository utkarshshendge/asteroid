import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/player.dart';

class PlayerViewModel extends ChangeNotifier {
  final Player _player = Player();
  double _angle = 0;

  double get x => _player.x;
  double get y => _player.y;
  double get angle => _angle;

  void updatePosition(double newX, double newY) {
    // oonly update if there is a difference
    if (newX == _player.x && newY == _player.y) return;

    final double dx = newX - _player.x;
    final double dy = newY - _player.y;
    if (dx != 0 || dy != 0) {
      _angle = atan2(dy, dx);
    }
    _player.x = newX;
    _player.y = newY;
    notifyListeners();
  }
}
