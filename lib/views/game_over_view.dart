import 'package:flutter/material.dart';
import 'game_view.dart';

class GameOverView extends StatelessWidget {
  final Duration elapsedTime;

  const GameOverView({Key? key, required this.elapsedTime}) : super(key: key);

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "$minutes mins and $seconds sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(fontSize: 32, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              'You lasted for ${_formatDuration(elapsedTime)} only. LMAO',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameView()),
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
