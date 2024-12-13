class Player {
  final String name;
  final String symbol;
  int score;

  Player({
    required this.name,
    required this.symbol,
    this.score = 0,
  });
}

enum GameMode {
  playerVsPlayer,
  playerVsCpu,
}
