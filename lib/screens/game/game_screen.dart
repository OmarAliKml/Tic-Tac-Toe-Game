import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../medels/game_player.dart';
import '../../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  final Player player1;
  final Player player2;
  final bool isPlayerVsCpu;

  const GameScreen({
    super.key,
    required this.player1,
    required this.player2,
    required this.isPlayerVsCpu,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> _board;
  late bool _isPlayer1Turn;
  late bool _gameOver;
  String? _winner;
  List<int>? _winningLine;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _board = List.filled(9, '');
    _isPlayer1Turn = true;
    _gameOver = false;
    _winner = null;
    _winningLine = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.backgroundColor,
            ],
            stops: [0.2, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader().animate().fadeIn(duration: 600.ms),
              const Spacer(),
              _buildGameBoard(),
              const Spacer(),
              _buildGameStatus().animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 20),
              _buildControls().animate().fadeIn(duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Column(
            children: [
              const Text(
                'SCORE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    widget.player1.score.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '-',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Text(
                    widget.player2.score.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 9,
            itemBuilder: (context, index) => _buildCell(index),
          ),
        ),
      ),
    ).animate().scale(
      duration: 600.ms,
      curve: Curves.easeOutBack,
      begin: const Offset(0.8, 0.8),
    );
  }

  Widget _buildCell(int index) {
    final isWinningCell = _winningLine?.contains(index) ?? false;
    final cellContent = _board[index];

    return GestureDetector(
      onTap: () => _onCellTapped(index),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.blue[900]?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: cellContent.isEmpty
            ? _buildEmptyCell()
            : _buildSymbol(cellContent, isWinningCell),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return const SizedBox.expand();
  }

  Widget _buildSymbol(String symbol, bool isWinningCell) {
    if (symbol == 'X') {
      return _buildX(isWinningCell);
    } else {
      return _buildO(isWinningCell);
    }
  }

  Widget _buildX(bool isWinningCell) {
    return CustomPaint(
      painter: XPainter(
        color: isWinningCell ? AppTheme.accentColor : Colors.white,
      ),
    ).animate()
        .scale(
      duration: 200.ms,
      curve: Curves.easeOutBack,
    )
        .fadeIn(duration: 200.ms);
  }

  Widget _buildO(bool isWinningCell) {
    return CustomPaint(
      painter: OPainter(
        color: isWinningCell ? AppTheme.accentColor : Colors.white,
      ),
    ).animate()
        .scale(
      duration: 200.ms,
      curve: Curves.easeOutBack,
    )
        .fadeIn(duration: 200.ms);
  }

  Widget _buildGameStatus() {
    final currentPlayer = _isPlayer1Turn ? widget.player1 : widget.player2;
    String statusText;
    Color statusColor;

    if (_gameOver) {
      if (_winner != null) {
        final winner = _winner == widget.player1.symbol
            ? widget.player1
            : widget.player2;
        statusText = '${winner.name} Wins!';
        statusColor = AppTheme.accentColor;
      } else {
        statusText = "It's a Draw!";
        statusColor = Colors.white70;
      }
    } else {
      statusText = "${currentPlayer.name}'s Turn";
      statusColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            onPressed: _resetGame,
            icon: Icons.refresh,
            label: 'New Game',
          ),
          _buildButton(
            onPressed: () => Navigator.pop(context),
            icon: Icons.exit_to_app,
            label: 'Exit Game',
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _onCellTapped(int index) {
    if (_board[index].isEmpty && !_gameOver) {
      setState(() {
        _board[index] = _isPlayer1Turn
            ? widget.player1.symbol
            : widget.player2.symbol;

        _checkGameEnd();

        if (!_gameOver) {
          _isPlayer1Turn = !_isPlayer1Turn;

          if (widget.isPlayerVsCpu && !_isPlayer1Turn) {
            _makeCpuMove();
          }
        }
      });
    }
  }

  void _makeCpuMove() {
    Timer(const Duration(milliseconds: 500), () {
      if (!_gameOver) {
        final emptyIndices = List.generate(9, (i) => i)
            .where((i) => _board[i].isEmpty)
            .toList();

        if (emptyIndices.isNotEmpty) {
          final random = Random();
          final index = emptyIndices[random.nextInt(emptyIndices.length)];
          _onCellTapped(index);
        }
      }
    });
  }

  void _checkGameEnd() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (_board[i].isNotEmpty &&
          _board[i] == _board[i + 1] &&
          _board[i] == _board[i + 2]) {
        _winningLine = [i, i + 1, i + 2];
        _endGame(_board[i]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[i].isNotEmpty &&
          _board[i] == _board[i + 3] &&
          _board[i] == _board[i + 6]) {
        _winningLine = [i, i + 3, i + 6];
        _endGame(_board[i]);
        return;
      }
    }

    // Check diagonals
    if (_board[0].isNotEmpty &&
        _board[0] == _board[4] &&
        _board[0] == _board[8]) {
      _winningLine = [0, 4, 8];
      _endGame(_board[0]);
      return;
    }
    if (_board[2].isNotEmpty &&
        _board[2] == _board[4] &&
        _board[2] == _board[6]) {
      _winningLine = [2, 4, 6];
      _endGame(_board[2]);
      return;
    }

    // Check for draw
    if (!_board.contains('')) {
      _endGame(null);
    }
  }

  void _endGame(String? winner) {
    _gameOver = true;
    _winner = winner;

    if (winner != null) {
      if (winner == widget.player1.symbol) {
        widget.player1.score++;
      } else {
        widget.player2.score++;
      }
    }
  }

  void _resetGame() {
    setState(_initializeGame);
  }
}

class XPainter extends CustomPainter {
  final Color color;

  XPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final padding = size.width * 0.2;

    // First line of X
    canvas.drawLine(
      Offset(padding, padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );

    // Second line of X
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(padding, size.height - padding),
      paint,
    );
  }

  @override
  bool shouldRepaint(XPainter oldDelegate) => color != oldDelegate.color;
}

class OPainter extends CustomPainter {
  final Color color;

  OPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.6;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(OPainter oldDelegate) => color != oldDelegate.color;
}
