import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key, required bool isSinglePlayer});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage>
    with TickerProviderStateMixin {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  List<List<bool>> winningCells =
  List.generate(3, (_) => List.filled(3, false));
  bool isPlayerTurn = true;
  int playerScore = 0;
  int computerScore = 0;
  int ties = 0;
  bool isSinglePlayer = true;
  bool gameEnded = false;
  late AnimationController winController;
  late Animation<double> winAnimation;
  late List<List<AnimationController>> cellControllers;
  late List<List<Animation<double>>> cellAnimations;

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  void initAnimations() {
    winController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    winAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: winController, curve: Curves.elasticInOut),
    );

    cellControllers = List.generate(
      3,
          (_) =>
          List.generate(
            3,
                (_) =>
                AnimationController(
                  duration: const Duration(milliseconds: 200),
                  vsync: this,
                ),
          ),
    );

    cellAnimations = List.generate(
      3,
          (_) =>
          List.generate(
            3,
                (_) =>
                Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: cellControllers[_][_], curve: Curves.easeOut),
                ),
          ),
    );
  }

  @override
  void dispose() {
    winController.dispose();
    for (var row in cellControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.black,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              buildTurnIndicator(),
              const SizedBox(height: 20),
              buildScoreBoard(),
              const Spacer(),
              buildGameBoard(),
              const Spacer(),
              buildGameControls(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTurnIndicator() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: gameEnded ? 0.0 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isPlayerTurn ? "X's Turn" : "O's Turn",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isPlayerTurn ? Colors.blue : Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildScoreColumn(
              'Player X',
              playerScore,
              Colors.blue,
              isPlayerTurn && !gameEnded,
            ),
            buildScoreColumn(
              'Ties',
              ties,
              Colors.white,
              false,
            ),
            buildScoreColumn(
              isSinglePlayer ? 'CPU O' : 'Player O',
              computerScore,
              Colors.purple,
              !isPlayerTurn && !gameEnded,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScoreColumn(String label, int score, Color color,
      bool isCurrentTurn) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentTurn ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      constraints: const BoxConstraints(maxWidth: 400),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(15),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final row = index ~/ 3;
              final col = index % 3;
              return buildCell(row, col);
            },
          ),
        ),
      ),
    );
  }

  Widget buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => handleCellTap(row, col),
      child: AnimatedBuilder(
        animation: Listenable.merge([cellAnimations[row][col], winAnimation]),
        builder: (context, child) {
          double scale = winningCells[row][col]
              ? winAnimation.value
              : 1.0 + (cellAnimations[row][col].value * 0.2);

          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: winningCells[row][col]
                    ? (board[row][col] == 'X'
                    ? Colors.blue.withOpacity(0.3)
                    : Colors.purple.withOpacity(0.3))
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: winningCells[row][col]
                      ? (board[row][col] == 'X' ? Colors.blue : Colors.purple)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Center(
                child: Text(
                  board[row][col],
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: board[row][col] == 'X' ? Colors.blue : Colors.purple,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildGameControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildControlButton(
            'New Game',
            Icons.refresh,
            resetGame,
          ),
          buildControlButton(
            isSinglePlayer ? '2 Players' : '1 Player',
            isSinglePlayer ? Icons.people : Icons.person,
                () {
              setState(() {
                isSinglePlayer = !isSinglePlayer;
                resetGame();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildControlButton(String text, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleCellTap(int row, int col) {
    if (gameEnded ||
        board[row][col].isNotEmpty ||
        (!isPlayerTurn && isSinglePlayer)) {
      return;
    }

    setState(() {
      board[row][col] = isPlayerTurn ? 'X' : 'O';
      cellControllers[row][col].forward();
    });

    if (!checkWinner(isPlayerTurn ? 'X' : 'O')) {
      isPlayerTurn = !isPlayerTurn;
      if (isSinglePlayer && !isPlayerTurn) {
        computerMove();
      }
    }
  }

  void computerMove() {
    if (gameEnded) return;

    Timer(const Duration(milliseconds: 500), () {
      // Try to win
      if (makeWinningMove('O')) return;

      // Block player
      if (makeWinningMove('X')) return;

      // Take center
      if (board[1][1].isEmpty) {
        makeMove(1, 1);
        return;
      }

      // Take corner
      List<Point<int>> corners = [
        const Point(0, 0),
        const Point(0, 2),
        const Point(2, 0),
        const Point(2, 2),
      ];
      corners.shuffle();
      for (var corner in corners) {
        if (board[corner.x.toInt()][corner.y.toInt()].isEmpty) {
          makeMove(corner.x.toInt(), corner.y.toInt());
          return;
        }
      }

      // Random move
      List<Point<int>> emptyCells = [];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j].isEmpty) {
            emptyCells.add(Point(i, j));
          }
        }
      }

      if (emptyCells.isNotEmpty) {
        final move = emptyCells[Random().nextInt(emptyCells.length)];
        makeMove(move.x.toInt(), move.y.toInt());
      }
    });
  }

  bool makeWinningMove(String symbol) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          board[i][j] = symbol;
          if (checkWinningCombination(symbol)) {
            board[i][j] = '';
            makeMove(i, j);
            return true;
          }
          board[i][j] = '';
        }
      }
    }
    return false;
  }

  void makeMove(int row, int col) {
    setState(() {
      board[row][col] = 'O';
      cellControllers[row][col].forward();
      if (!checkWinner('O')) {
        isPlayerTurn = true;
      }
    });
  }

  bool checkWinner(String player) {
    if (checkWinningCombination(player)) {
      gameEnded = true;
      winController.forward();
      updateScore(player);
      return true;
    }

    if (isBoardFull()) {
      gameEnded = true;
      setState(() => ties++);
      Future.delayed(const Duration(milliseconds: 1000), resetBoard);
      return true;
    }

    return false;
  }

  bool checkWinningCombination(String player) {
    winningCells = List.generate(3, (_) => List.filled(3, false));

    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player)) {
        winningCells[i] = List.filled(3, true);
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board.every((row) => row[i] == player)) {
        for (int j = 0; j < 3; j++) {
          winningCells[j][i] = true;
        }
        return true;
      }
    }

    // Check diagonals
    if (board[0][0] == player &&
        board[1][1] == player &&
        board[2][2] == player) {
      winningCells[0][0] = winningCells[1][1] = winningCells[2][2] = true;
      return true;
    }

    if (board[0][2] == player &&
        board[1][1] == player &&
        board[2][0] == player) {
      winningCells[0][2] = winningCells[1][1] = winningCells[2][0] = true;
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void updateScore(String player) {
    setState(() {
      if (player == 'X') {
        playerScore++;
      } else {
        computerScore++;
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), resetBoard);
  }

  void resetBoard() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      winningCells = List.generate(3, (_) => List.filled(3, false));
      isPlayerTurn = true;
      gameEnded = false;
      winController.reset();
      for (var row in cellControllers) {
        for (var controller in row) {
          controller.reset();
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      playerScore = 0;
      computerScore = 0;
      ties = 0;
      resetBoard();
    });
  }
}
