class Player {
  final String name;
  final String symbol;
  int score;

  Player({
    required this.name,
    required this.symbol,
    this.score = 0,
  });

  Player copyWith({
    String? name,
    String? symbol,
    int? score,
  }) {
    return Player(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      score: score ?? this.score,
    );
  }
}
