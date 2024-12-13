
import 'game_player.dart';

class GameState {
  List<String> board;
  bool isCrossTurn;
  bool gameOver;
  String winner;
  Player? player1;
  Player? player2;
  bool isPlayerVsPlayer;

  GameState({
    required this.board,
    this.isCrossTurn = true,
    this.gameOver = false,
    this.winner = '',
    this.player1,
    this.player2,
    this.isPlayerVsPlayer = true,
  });
}
