import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'game/game_setup_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Professional color scheme
  final List<Color> _backgroundColors = [
    const Color(0xFF1A237E), // Deep Indigo
    const Color(0xFF283593), // Slightly lighter Indigo
  ];

  final Color _accentColor = const Color(0xFF64FFDA); // Teal accent
  final Color _buttonColor = Colors.white;
  final Color _buttonTextColor = const Color(0xFF1A237E);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _backgroundColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildAnimatedBackground(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        _buildTitle(),
                        const SizedBox(height: 64),
                        _buildGameModeButtons(),
                        const Spacer(),
                        _buildCredits(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: BackgroundPainter(
            animation: _controller.value,
            accentColor: _accentColor,
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [_accentColor, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Tic Tac Toe',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(3, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _accentColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  'Classic Game',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameModeButtons() {
    return Column(
      children: [
        _buildMenuButton(
          'Player vs Player',
          Icons.people_rounded,
          () => _navigateToGameSetup(true),
          _buttonColor,
        ),
        const SizedBox(height: 20),
        _buildMenuButton(
          'Player vs CPU',
          Icons.smart_toy_rounded,
          () => _navigateToGameSetup(false),
          _buttonColor.withOpacity(0.9),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 68,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: _buttonTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30),
                  const SizedBox(width: 16),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  Widget _buildCredits() {
    return Text(
      '© ${DateTime.now().year} XO',
      style: TextStyle(
        color: _accentColor.withOpacity(0.8),
        fontSize: 14,
        letterSpacing: 1,
      ),
    );
  }

  void _navigateToGameSetup(bool isPlayerVsPlayer) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameSetupScreen(
          initialIsPlayerVsPlayer: isPlayerVsPlayer,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuint;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animation;
  final Color accentColor;

  BackgroundPainter({required this.animation, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final count = 5;
    final step = size.width / count;

    for (var i = 0; i < count; i++) {
      for (var j = 0; j < count; j++) {
        final x = i * step;
        final y = j * step;

        canvas.save();
        canvas.translate(x + step / 2, y + step / 2);
        canvas.rotate((animation * 2 * math.pi + (i + j) / 2));

        canvas.drawLine(
          const Offset(-20, -20),
          const Offset(20, 20),
          paint,
        );
        canvas.drawLine(
          const Offset(-20, 20),
          const Offset(20, -20),
          paint,
        );

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) =>
      animation != oldDelegate.animation ||
      accentColor != oldDelegate.accentColor;
}
