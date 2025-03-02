import 'package:flutter/material.dart';
import 'views/game_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asteroids Game',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: GameView(),
    );
  }
}
