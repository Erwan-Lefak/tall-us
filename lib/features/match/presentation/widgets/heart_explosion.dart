import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_theme.dart';

/// Premium Heart Explosion Effect for Matches
///
/// Creates a spectacular explosion of hearts when a match occurs
class HeartExplosionWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const HeartExplosionWidget({
    super.key,
    this.onComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<HeartExplosionWidget> createState() => _HeartExplosionWidgetState();
}

class _HeartExplosionWidgetState extends State<HeartExplosionWidget>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: widget.duration);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Start explosion
    _startExplosion();
  }

  void _startExplosion() {
    // Create multiple bursts of confetti
    Future.delayed(const Duration(milliseconds: 100), () {
      _confettiController.play();
    });

    // Stop after duration
    Future.delayed(widget.duration, () {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Confetti layers
          _buildConfettiLayer(),

          // Central pulsing heart
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.3),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.bordeaux.withValues(alpha: 0.4),
                          blurRadius: 40 * _pulseController.value,
                          spreadRadius: 10 * _pulseController.value,
                        ),
                        BoxShadow(
                          color: AppTheme.gold.withValues(alpha: 0.3),
                          blurRadius: 60 * _pulseController.value,
                          spreadRadius: 20 * _pulseController.value,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.bordeaux,
                      size: 120,
                    ),
                  ),
                );
              },
            ),
          ),

          // Orbiting hearts
          ...List.generate(6, (index) {
            final angle = (index * 60) * (pi / 180);
            return _buildOrbitingHeart(angle, index);
          }),
        ],
      ),
    );
  }

  Widget _buildConfettiLayer() {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: pi * 2, // 360 degrees
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 100,
        gravity: 0.2,
        shouldLoop: false,
        colors: [
          AppTheme.bordeaux,
          AppTheme.gold,
          const Color(0xFFFF6B9D), // Pink
          const Color(0xFFFFB6C1), // Light pink
          Colors.white,
        ],
        createParticlePath: (size) {
          // Heart shape
          final Path path = Path();
          final double width = size.width;
          final double height = size.height;
          final double x = width / 2;
          final double y = height / 2;

          path.moveTo(x, y + height * 0.15);
          path.cubicTo(
            x - width * 0.5,
            y - height * 0.15,
            x - width * 0.5,
            y - height * 0.5,
            x,
            y - height * 0.25,
          );
          path.cubicTo(
            x + width * 0.5,
            y - height * 0.5,
            x + width * 0.5,
            y - height * 0.15,
            x,
            y + height * 0.15,
          );

          return path;
        },
      ),
    );
  }

  Widget _buildOrbitingHeart(double angle, int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final orbitRadius = 120 + (_pulseController.value * 30);
        final x = cos(angle + _pulseController.value * 2) * orbitRadius;
        final y = sin(angle + _pulseController.value * 2) * orbitRadius;

        return Transform.translate(
          offset: Offset(x, y),
          child: Transform.scale(
            scale: 0.8 + (_pulseController.value * 0.4),
            child: Icon(
              Icons.favorite_rounded,
              color: [
                AppTheme.bordeaux,
                AppTheme.gold,
                const Color(0xFFFF6B9D),
              ][index % 3],
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

/// Premium Match Dialog with Heart Explosion
class PremiumMatchDialog extends StatefulWidget {
  final String currentUserPhoto;
  final String matchedUserPhoto;
  final String matchedUserName;
  final VoidCallback onMessageTap;
  final VoidCallback onKeepSwipingTap;

  const PremiumMatchDialog({
    super.key,
    required this.currentUserPhoto,
    required this.matchedUserPhoto,
    required this.matchedUserName,
    required this.onMessageTap,
    required this.onKeepSwipingTap,
  });

  @override
  State<PremiumMatchDialog> createState() => _PremiumMatchDialogState();
}

class _PremiumMatchDialogState extends State<PremiumMatchDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // Heart explosion background
          HeartExplosionWidget(
            duration: const Duration(seconds: 2),
          ),

          // Match content
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Match title
                  Text(
                    'It\'s a Match!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.bordeaux,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Photos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPhoto(widget.currentUserPhoto),
                      const SizedBox(width: 16),
                      _buildPhoto(widget.matchedUserPhoto),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Matched user name
                  Text(
                    'You and ${widget.matchedUserName} liked each other!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onMessageTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.bordeaux,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Send a Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: widget.onKeepSwipingTap,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.navy.withValues(alpha: 0.6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Keep Swiping',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto(String photoUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.gold,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bordeaux.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.gray200,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.gray400,
                    ),
                  );
                },
              )
            : Container(
                color: AppTheme.gray200,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppTheme.gray400,
                ),
              ),
      ),
    );
  }
}
