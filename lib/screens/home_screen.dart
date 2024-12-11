import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'game/game_setup_screen.dart';

// Update main.dart first
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          primary: AppTheme.primaryColor,
          secondary: AppTheme.accentColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// Updated HomeScreen with centered UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 60),
                    _buildGameModes(context),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 800.ms)
        .scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
      duration: 800.ms,
      curve: Curves.easeOutCubic,
    )
        .shimmer(duration: 2000.ms, delay: 800.ms);
  }

  Widget _buildGameModes(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          _buildGameModeButton(
            context: context,
            text: 'Player vs Player',
            isPlayerVsPlayer: true,
            icon: Icons.people,
            delay: 1000,
          ),
          const SizedBox(height: 20),
          _buildGameModeButton(
            context: context,
            text: 'Player vs CPU',
            isPlayerVsPlayer: false,
            icon: Icons.smart_toy,
            delay: 1200,
          ),
        ],
      ),
    );
  }

  Widget _buildGameModeButton({
    required BuildContext context,
    required String text,
    required bool isPlayerVsPlayer,
    required IconData icon,
    required int delay,
  }) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor,
            AppTheme.accentColor.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToGameSetup(context, isPlayerVsPlayer),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideX(
      begin: 0.2,
      end: 0,
      delay: Duration(milliseconds: delay),
      curve: Curves.easeOutCubic,
    )
        .scale(
      begin: const Offset(0.95, 0.95),
      end: const Offset(1, 1),
      delay: Duration(milliseconds: delay),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildFooter() {
    return Text(
      '© 2024 XO',
      style: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 14,
      ),
    )
        .animate()
        .fadeIn(delay: 1400.ms)
        .slide(begin: const Offset(0, 1), end: const Offset(0, 0));
  }

  void _navigateToGameSetup(BuildContext context, bool isPlayerVsPlayer) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GameSetupScreen(
          isPlayerVsPlayer: isPlayerVsPlayer,
        ),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
