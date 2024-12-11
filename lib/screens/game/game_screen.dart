import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/player.dart';

enum Difficulty { easy, medium, hard }

class GameScreen extends StatefulWidget {
  final Player player1;
  final Player player2;
  final bool isPlayerVsPlayer;

  const GameScreen({
    super.key,
    required this.player1,
    required this.player2,
    required this.isPlayerVsPlayer,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<List<String>> _board;
  late bool _isPlayer1Turn;
  late bool _gameOver;
  late String _winner;
  late List<List<AnimationController>> _cellAnimationControllers;
  late AnimationController _boardAnimationController;
  final Random _random = Random();
  Difficulty? selectedDifficulty;
  bool isDifficultySelected = false;

  final Color _backgroundColor = const Color(0xFF34495E);
  final Color _player1Color = Colors.blue;
  final Color _player2Color = Colors.red;
  final Color _cardColor = Colors.white;
  final Color _textColor = Colors.white;

  final Map<Difficulty, DifficultySettings> _difficultySettings = {
    Difficulty.easy: DifficultySettings(
      optimalPlayChance: 20,
      centerPreference: 30,
      cornerPreference: 20,
      blockingMoveChance: 25,
      minMoveDelay: 300,
      maxMoveDelay: 800,
    ),
    Difficulty.medium: DifficultySettings(
      optimalPlayChance: 65,
      centerPreference: 75,
      cornerPreference: 65,
      blockingMoveChance: 75,
      minMoveDelay: 200,
      maxMoveDelay: 500,
    ),
    Difficulty.hard: DifficultySettings(
      optimalPlayChance: 95,
      centerPreference: 95,
      cornerPreference: 90,
      blockingMoveChance: 98,
      minMoveDelay: 100,
      maxMoveDelay: 300,
    ),
  };

  @override
  void initState() {
    super.initState();
    if (widget.isPlayerVsPlayer) {
      isDifficultySelected = true;
      _initializeGame();
    }
  }

  Widget _buildDifficultySelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Difficulty',
            style: TextStyle(
              color: _textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...Difficulty.values.map((difficulty) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cardColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDifficulty = difficulty;
                      isDifficultySelected = true;
                      _initializeGame();
                    });
                  },
                  child: Text(
                    difficulty.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _initializeGame() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _isPlayer1Turn = true;
    _gameOver = false;
    _winner = '';

    _cellAnimationControllers = List.generate(
      3,
      (i) => List.generate(
        3,
        (j) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );

    _boardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _boardAnimationController.forward();
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  void _handleCellTap(int row, int col) {
    if (_board[row][col].isNotEmpty || _gameOver) return;

    setState(() {
      _board[row][col] = _isPlayer1Turn ? 'X' : 'O';
      _cellAnimationControllers[row][col].forward(from: 0.0);

      if (_checkWinner(row, col)) {
        _gameOver = true;
        if (!widget.isPlayerVsPlayer && !_isPlayer1Turn) {
          _winner = 'CPU';
          widget.player2.score++;
        } else if (_isPlayer1Turn) {
          _winner = widget.isPlayerVsPlayer ? widget.player1.name : 'Player';
          widget.player1.score++;
        } else {
          _winner = widget.player2.name;
          widget.player2.score++;
        }
      } else if (_isBoardFull()) {
        _gameOver = true;
        _winner = 'Draw';
      } else {
        _isPlayer1Turn = !_isPlayer1Turn;

        if (!widget.isPlayerVsPlayer && !_isPlayer1Turn) {
          _makeCPUMove();
        }
      }
    });
  }

  void _makeCPUMove() async {
    await Future.delayed(Duration(
      milliseconds: _random.nextInt(
            (_difficultySettings[selectedDifficulty]?.maxMoveDelay ?? 400) -
                (_difficultySettings[selectedDifficulty]?.minMoveDelay ?? 200),
          ) +
          (_difficultySettings[selectedDifficulty]?.minMoveDelay ?? 200),
    ));

    if (_gameOver) return;

    List<List<int>> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j].isEmpty) {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isEmpty) return;

    // Try to find a winning move
    for (var cell in emptyCells) {
      int row = cell[0], col = cell[1];
      _board[row][col] = 'O';
      if (_checkWinner(row, col)) {
        setState(() {
          _handleCellTap(row, col);
        });
        return;
      }
      _board[row][col] = '';
    }

    // Try to block player's winning move
    for (var cell in emptyCells) {
      int row = cell[0], col = cell[1];
      _board[row][col] = 'X';
      if (_checkWinner(row, col)) {
        _board[row][col] = '';
        if (_random.nextInt(100) <
            (_difficultySettings[selectedDifficulty]?.blockingMoveChance ??
                70)) {
          setState(() {
            _handleCellTap(row, col);
          });
          return;
        }
      }
      _board[row][col] = '';
    }

    // Try to take center
    if (_board[1][1].isEmpty &&
        _random.nextInt(100) <
            (_difficultySettings[selectedDifficulty]?.centerPreference ?? 70)) {
      setState(() {
        _handleCellTap(1, 1);
      });
      return;
    }

    // Try to take corners
    List<List<int>> corners = [
      [0, 0],
      [0, 2],
      [2, 0],
      [2, 2]
    ];
    corners.shuffle(_random);
    for (var corner in corners) {
      if (_board[corner[0]][corner[1]].isEmpty &&
          _random.nextInt(100) <
              (_difficultySettings[selectedDifficulty]?.cornerPreference ??
                  60)) {
        setState(() {
          _handleCellTap(corner[0], corner[1]);
        });
        return;
      }
    }

    // Make a random move
    var randomCell = emptyCells[_random.nextInt(emptyCells.length)];
    setState(() {
      _handleCellTap(randomCell[0], randomCell[1]);
    });
  }

  bool _checkWinner(int row, int col) {
    String symbol = _board[row][col];
    if (_board[row].every((cell) => cell == symbol)) return true;
    if (_board.every((row) => row[col] == symbol)) return true;
    if (row == col &&
        _board
            .asMap()
            .entries
            .every((entry) => _board[entry.key][entry.key] == symbol)) {
      return true;
    }
    if (row + col == 2 &&
        _board
            .asMap()
            .entries
            .every((entry) => _board[entry.key][2 - entry.key] == symbol)) {
      return true;
    }
    return false;
  }

  bool _isBoardFull() {
    return _board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  Widget _buildGameStatus() {
    if (!_gameOver) {
      return Text(
        _isPlayer1Turn ? "Your Turn" : "CPU's Turn",
        style: TextStyle(
          color: _textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    String message;
    Color messageColor;

    if (_winner == 'Draw') {
      message = "It's a Draw!";
      messageColor = _textColor;
    } else if (_winner == 'CPU') {
      message = "CPU Wins!";
      messageColor = _player2Color;
    } else {
      message = "You Win!";
      messageColor = _player1Color;
    }

    return Column(
      children: [
        Text(
          message,
          style: TextStyle(
            color: messageColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _resetGame,
          style: ElevatedButton.styleFrom(
            backgroundColor: _cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Play Again',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: _backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  'Leave Game?',
                  style: TextStyle(color: _textColor),
                ),
                content: Text(
                  'Are you sure you want to return to the menu? Current game progress will be lost.',
                  style: TextStyle(color: _textColor),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text(
                      'Leave',
                      style: TextStyle(color: _player2Color),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGameBoard() {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: _buildBackButton(),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isPlayerVsPlayer
                          ? '${widget.player1.name}: ${widget.player1.score}'
                          : 'Player: ${widget.player1.score}',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.isPlayerVsPlayer
                          ? '${widget.player2.name}: ${widget.player2.score}'
                          : 'CPU: ${widget.player2.score}',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildGameStatus(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final row = index ~/ 3;
                    final col = index % 3;
                    return GestureDetector(
                      onTap: () => _handleCellTap(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _board[row][col],
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: _board[row][col] == 'X'
                                  ? _player1Color
                                  : _player2Color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var row in _cellAnimationControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    _boardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: _backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Leave Game?',
                style: TextStyle(color: _textColor),
              ),
              content: Text(
                'Are you sure you want to return to the menu? Current game progress will be lost.',
                style: TextStyle(color: _textColor),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(
                    'Leave',
                    style: TextStyle(color: _player2Color),
                  ),
                  onPressed: () {
                    shouldPop = true;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: !widget.isPlayerVsPlayer && !isDifficultySelected
              ? _buildDifficultySelection()
              : _buildGameBoard(),
        ),
      ),
    );
  }
}

class DifficultySettings {
  final int optimalPlayChance;
  final int centerPreference;
  final int cornerPreference;
  final int blockingMoveChance;
  final int minMoveDelay;
  final int maxMoveDelay;

  DifficultySettings({
    required this.optimalPlayChance,
    required this.centerPreference,
    required this.cornerPreference,
    required this.blockingMoveChance,
    required this.minMoveDelay,
    required this.maxMoveDelay,
  });
}
