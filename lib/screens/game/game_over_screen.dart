import 'package:flutter/material.dart';

import '../../models/game_player.dart';


class GameOverScreen extends StatelessWidget {
  final String winner;
  final Player player1;
  final Player player2;

  const GameOverScreen({
    super.key,
    required this.winner,
    required this.player1,
    required this.player2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20),
            Text(
              winner == 'Draw' ? 'It\'s a Draw!' : 'Winner: $winner',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Back to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
