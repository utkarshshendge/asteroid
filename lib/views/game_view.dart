import 'package:asteroid_game/viewmodels/bullter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/game_engine.dart';
import '../viewmodels/player_view_model.dart';
import '../viewmodels/particle_view_model.dart';
import '../constants/difficulty.dart';
import 'game_over_view.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  late final PlayerViewModel _playerViewModel;
  late final ParticleViewModel _particleViewModel;
  late final BulletViewModel _bulletViewModel;
  late final GameEngine _gameEngine;
  Size _gameAreaSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _playerViewModel = PlayerViewModel();
    _particleViewModel = ParticleViewModel(particleCount: 50);
    _bulletViewModel = BulletViewModel();
    _gameEngine = GameEngine(
      playerViewModel: _playerViewModel,
      particleViewModel: _particleViewModel,
      bulletViewModel: _bulletViewModel,
    );

    _gameEngine.addListener(() {
      if (_gameEngine.gameOver) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GameOverView(elapsedTime: _gameEngine.elapsedTime),
          ),
        );
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _gameEngine.disposeEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final fullWidth = constraints.maxWidth;
          final fullHeight = constraints.maxHeight;
          final timerAreaHeight = fullHeight * 0.15;
          final gameAreaHeight = fullHeight * 0.85;
          _gameAreaSize = Size(fullWidth, gameAreaHeight);

          if (!_gameEngine.gameOver &&
              _gameEngine.elapsedTime == Duration.zero) {
            _gameEngine.start(this, _gameAreaSize);
          }

          return Column(
            children: [
              TimerArea(
                elapsedTime: _gameEngine.elapsedTime,
                height: timerAreaHeight,
                currentDifficulty: _gameEngine.currentDifficulty,
                onDifficultyChange: (Difficulty newDifficulty) {
                  setState(() {
                    _gameEngine.changeDifficulty(newDifficulty);
                  });
                },
              ),
              Expanded(
                child: GamePlayArea(
                  playerViewModel: _playerViewModel,
                  particleViewModel: _particleViewModel,
                  bulletViewModel: _bulletViewModel,
                  gameEngine: _gameEngine,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TimerArea extends StatelessWidget {
  final Duration elapsedTime;
  final double height;
  final Difficulty currentDifficulty;
  final Function(Difficulty) onDifficultyChange;

  const TimerArea({
    Key? key,
    required this.elapsedTime,
    required this.height,
    required this.currentDifficulty,
    required this.onDifficultyChange,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  String _difficultyToString(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return "Easy";
      case Difficulty.medium:
        return "Medium";
      case Difficulty.hard:
        return "Hard";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDuration(elapsedTime),
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const Text("Shoot with space",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              const Text("Change difficulty with arrow keys (->  <-)",
                  style: TextStyle(fontSize: 16, color: Colors.black))
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => onDifficultyChange(Difficulty.easy),
            child: Text(
              "Easy",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentDifficulty == Difficulty.easy ? Colors.green : null,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onDifficultyChange(Difficulty.medium),
            child: Text("Medium",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentDifficulty == Difficulty.medium ? Colors.green : null,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => onDifficultyChange(Difficulty.hard),
            child: Text("Hit Me Daddy ",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  currentDifficulty == Difficulty.hard ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}

class GamePlayArea extends StatelessWidget {
  final PlayerViewModel playerViewModel;
  final ParticleViewModel particleViewModel;
  final BulletViewModel bulletViewModel;
  final GameEngine gameEngine;

  const GamePlayArea({
    Key? key,
    required this.playerViewModel,
    required this.particleViewModel,
    required this.bulletViewModel,
    required this.gameEngine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            bulletViewModel.shoot(
                playerViewModel.x, playerViewModel.y, playerViewModel.angle);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            Difficulty newDifficulty;
            if (gameEngine.currentDifficulty == Difficulty.easy) {
              newDifficulty = Difficulty.medium;
            } else if (gameEngine.currentDifficulty == Difficulty.medium) {
              newDifficulty = Difficulty.hard;
            } else {
              newDifficulty = Difficulty.hard;
            }
            gameEngine.changeDifficulty(newDifficulty,
                increaseParticleSize: true);
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            Difficulty newDifficulty;
            if (gameEngine.currentDifficulty == Difficulty.hard) {
              newDifficulty = Difficulty.medium;
            } else if (gameEngine.currentDifficulty == Difficulty.medium) {
              newDifficulty = Difficulty.easy;
            } else {
              newDifficulty = Difficulty.easy;
            }
            gameEngine.changeDifficulty(newDifficulty,
                increaseParticleSize: true);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        onHover: (event) {
          playerViewModel.updatePosition(
              event.localPosition.dx, event.localPosition.dy);
        },
        child: CustomPaint(
          painter: GamePlayPainter(
            playerViewModel: playerViewModel,
            particleViewModel: particleViewModel,
            bulletViewModel: bulletViewModel,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class GamePlayPainter extends CustomPainter {
  final PlayerViewModel playerViewModel;
  final ParticleViewModel particleViewModel;
  final BulletViewModel bulletViewModel;

  GamePlayPainter({
    required this.playerViewModel,
    required this.particleViewModel,
    required this.bulletViewModel,
  }) : super(
          repaint: Listenable.merge([
            playerViewModel,
            particleViewModel,
            bulletViewModel,
          ]),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (var particle in particleViewModel.particles) {
      Path path = Path();
      if (particle.polygon.isNotEmpty) {
        Offset first = Offset(particle.x + particle.polygon.first.dx,
            particle.y + particle.polygon.first.dy);
        path.moveTo(first.dx, first.dy);
        for (var vertex in particle.polygon.skip(1)) {
          path.lineTo(particle.x + vertex.dx, particle.y + vertex.dy);
        }
        path.close();
        canvas.drawPath(path, particlePaint);
      }
    }

    final bulletPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (var bullet in bulletViewModel.bullets) {
      canvas.drawCircle(Offset(bullet.x, bullet.y), bullet.radius, bulletPaint);
    }

    final playerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Path cursorPath = Path();
    cursorPath.moveTo(-10, -5);
    cursorPath.lineTo(10, 0);
    cursorPath.lineTo(-10, 5);
    cursorPath.close();

    canvas.save();
    canvas.translate(playerViewModel.x, playerViewModel.y);
    canvas.rotate(playerViewModel.angle);
    canvas.drawPath(cursorPath, playerPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GamePlayPainter oldDelegate) => true;
}
