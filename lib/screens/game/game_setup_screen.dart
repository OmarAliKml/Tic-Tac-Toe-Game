import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../medels/game_player.dart';
import '../../theme/app_theme.dart';
import 'game_screen.dart';

class GameSetupScreen extends StatefulWidget {
  final bool isPlayerVsPlayer;

  const GameSetupScreen({
    super.key,
    required this.isPlayerVsPlayer,
  });

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final _player1Controller = TextEditingController(text: 'Player 1');
  final _player2Controller = TextEditingController(text: 'Player 2');
  String _player1Symbol = 'X';
  String _player2Symbol = 'O';

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
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
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildPlayerSetup(
                  controller: _player1Controller,
                  label: 'Player 1 Name',
                  symbol: _player1Symbol,
                  onSymbolChanged: (value) {
                    setState(() {
                      _player1Symbol = value;
                      _player2Symbol = value == 'X' ? 'O' : 'X';
                    });
                  },
                ).animate().fadeIn(delay: 300.ms).slideX(),
                const SizedBox(height: 24),
                if (widget.isPlayerVsPlayer)
                  _buildPlayerSetup(
                    controller: _player2Controller,
                    label: 'Player 2 Name',
                    symbol: _player2Symbol,
                    enabled: false,
                  ).animate().fadeIn(delay: 500.ms).slideX(),
                const SizedBox(height: 48),
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 20),
        Text(
          widget.isPlayerVsPlayer ? 'Player vs Player' : 'Player vs CPU',
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your game',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildPlayerSetup({
    required TextEditingController controller,
    required String label,
    required String symbol,
    bool enabled = true,
    void Function(String)? onSymbolChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Symbol:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 16),
              if (enabled)
                _buildSymbolToggle(
                  symbol,
                  onSymbolChanged ?? (_) {},
                )
              else
                Text(
                  symbol,
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolToggle(String currentSymbol, Function(String) onChanged) {
    return Row(
      children: ['X', 'O'].map((symbol) {
        final isSelected = currentSymbol == symbol;
        return GestureDetector(
          onTap: () => onChanged(symbol),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accentColor
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              symbol,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _startGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('START GAME'),
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2);
  }

  void _startGame() {
    final player1 = Player(
      name: _player1Controller.text.trim(),
      symbol: _player1Symbol,
    );

    final player2 = Player(
      name: widget.isPlayerVsPlayer
          ? _player2Controller.text.trim()
          : 'CPU',
      symbol: _player2Symbol,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          player1: player1,
          player2: player2,
          isPlayerVsCpu: !widget.isPlayerVsPlayer,
        ),
      ),
    );
  }
}
