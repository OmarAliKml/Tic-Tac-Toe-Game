import 'package:flutter/material.dart';

import '../../models/player.dart';
import 'game_screen.dart';

class GameSetupScreen extends StatefulWidget {
  final bool initialIsPlayerVsPlayer;

  const GameSetupScreen({
    super.key,
    required this.initialIsPlayerVsPlayer,
  });

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _player1Controller;
  late TextEditingController _player2Controller;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _accentColor = const Color(0xFF3498DB);
  final Color _backgroundColor = const Color(0xFF34495E);
  final Color _cardColor = const Color(0xFF2C3E50);
  final Color _textColor = Colors.white;
  final Color _secondaryTextColor = const Color(0xFFBDC3C7);

  @override
  void initState() {
    super.initState();
    _player1Controller = TextEditingController(text: 'Player 1');
    _player2Controller = TextEditingController(
      text: widget.initialIsPlayerVsPlayer ? 'Player 2' : 'CPU',
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startGame() {
    final player1 = Player(
      name: _player1Controller.text.trim().isNotEmpty
          ? _player1Controller.text.trim()
          : 'Player 1',
      symbol: 'X',
    );
    final player2 = Player(
      name: _player2Controller.text.trim().isNotEmpty
          ? _player2Controller.text.trim()
          : widget.initialIsPlayerVsPlayer
              ? 'Player 2'
              : 'CPU',
      symbol: 'O',
    );

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GameScreen(
          player1: player1,
          player2: player2,
          isPlayerVsPlayer: widget.initialIsPlayerVsPlayer,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Text(
        widget.initialIsPlayerVsPlayer
            ? 'Player vs Player Setup'
            : 'Player vs CPU Setup',
        style: TextStyle(
          color: _textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlayerInput(
    String label,
    TextEditingController controller,
    IconData icon,
    bool enabled,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              color: _cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _accentColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: _secondaryTextColor),
                prefixIcon: Icon(icon, color: _accentColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _accentColor,
                  _accentColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _accentColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _startGame,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 28,
                    color: _textColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Start Game',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _backgroundColor,
            _backgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Game Setup',
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: _textColor),
        ),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            );
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildPlayerInput(
                    'Player 1 Name',
                    _player1Controller,
                    Icons.person,
                    true,
                  ),
                  const SizedBox(height: 24),
                  _buildPlayerInput(
                    widget.initialIsPlayerVsPlayer
                        ? 'Player 2 Name'
                        : 'CPU Name',
                    _player2Controller,
                    widget.initialIsPlayerVsPlayer
                        ? Icons.person
                        : Icons.smart_toy_rounded,
                    widget.initialIsPlayerVsPlayer,
                  ),
                  const Spacer(),
                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
