import 'package:flutter/material.dart';

import '../models/game_player.dart';


class PlayerInfo extends StatelessWidget {
  final Player player1;
  final Player player2;
  final bool isPlayer1Turn;

  const PlayerInfo({
    super.key,
    required this.player1,
    required this.player2,
    required this.isPlayer1Turn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerScore(player1, isPlayer1Turn),
          _buildPlayerScore(player2, !isPlayer1Turn),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(Player player, bool isCurrentTurn) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color:
            isCurrentTurn ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        border:
            isCurrentTurn ? Border.all(color: Colors.blue, width: 2.0) : null,
      ),
      child: Column(
        children: [
          Text(
            player.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isCurrentTurn ? FontWeight.bold : FontWeight.normal,
              color: isCurrentTurn ? Colors.blue : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Score: ${player.score}',
            style: TextStyle(
              fontSize: 16,
              color: isCurrentTurn ? Colors.blue : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
