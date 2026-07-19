import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Animated match dialog with confetti burst, elastic photo entrance and a
/// pulsing heart. Self-contained (no extra dependencies).
class MatchDialog extends StatefulWidget {
  final UserProfileEntity currentUser;
  final UserProfileEntity matchedUser;
  final VoidCallback onMessageTap;
  final VoidCallback onKeepSwipingTap;

  const MatchDialog({
    super.key,
    required this.currentUser,
    required this.matchedUser,
    required this.onMessageTap,
    required this.onKeepSwipingTap,
  });

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog>
    with TickerProviderStateMixin {
  late final AnimationController _mainController; // entrance
  late final AnimationController _confettiController; // looping confetti
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _leftPhotoAnim;
  late final Animation<double> _rightPhotoAnim;
  late final Animation<double> _heartPulse;
  late final Animation<double> _titleAnim;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _scaleAnim = CurvedAnimation(
        parent: _mainController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(
        parent: _mainController, curve: const Interval(0.2, 1.0));

    _titleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.7, curve: Curves.elasticOut),
      ),
    );

    _leftPhotoAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutBack),
      ),
    );
    _rightPhotoAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.95, curve: Curves.easeOutBack),
      ),
    );

    _heartPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _confettiController,
        curve: Curves.easeInOut,
      ),
    );

    _mainController.forward();
    // Start confetti shortly after entrance begins.
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _confettiController.repeat();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Confetti layer (spills outside the card via the stack)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confettiController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(_confettiController.value),
                  );
                },
              ),
            ),
          ),

          // Main card
          FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              alignment: Alignment.center,
              child: Container(
                width: double.maxFinite,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF722F37), // bordeaux
                      Color(0xFFB23A48),
                      Color(0xFFFF6B6B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.bordeaux.withValues(alpha: 0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 36),

                    // Title with elastic pop + shimmer
                    ScaleTransition(
                      scale: _titleAnim,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFFFE082),
                              Colors.white,
                            ],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "C'est un Match !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Text(
                          'Vous et ${widget.matchedUser.displayName} vous êtes plu mutuellement',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Photos with bounce-in + pulsing heart
                    SizedBox(
                      height: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Left photo (current user)
                          Transform.translate(
                            offset: const Offset(-52, 0),
                            child: _AnimatedPhoto(
                              progress: _leftPhotoAnim,
                              rotate: -0.12,
                              photoUrl: _photo(widget.currentUser),
                              borderColor: Colors.white,
                            ),
                          ),
                          // Right photo (matched user)
                          Transform.translate(
                            offset: const Offset(52, 0),
                            child: _AnimatedPhoto(
                              progress: _rightPhotoAnim,
                              rotate: 0.12,
                              photoUrl: _photo(widget.matchedUser),
                              borderColor: const Color(0xFFFFE082),
                            ),
                          ),
                          // Pulsing heart in the middle
                          ScaleTransition(
                            scale: _heartPulse,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.favorite,
                                  color: AppTheme.bordeaux, size: 34),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              onTap: widget.onKeepSwipingTap,
                              label: 'Continuer',
                              filled: false,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ActionButton(
                              onTap: widget.onMessageTap,
                              label: 'Message',
                              filled: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _photo(UserProfileEntity p) {
    if (p.photoUrls.isNotEmpty) return p.photoUrls.first;
    return p.avatarUrl ?? '';
  }
}

class _AnimatedPhoto extends StatelessWidget {
  final Animation<double> progress;
  final double rotate;
  final String photoUrl;
  final Color borderColor;
  const _AnimatedPhoto({
    required this.progress,
    required this.rotate,
    required this.photoUrl,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value;
        return Transform.translate(
          offset: Offset(0, 40 * (1 - t)),
          child: Transform.rotate(
            angle: rotate * t,
            child: Transform.scale(
              scale: 0.5 + 0.5 * t,
              child: Opacity(opacity: t, child: child),
            ),
          ),
        );
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.white24,
        child: const Icon(Icons.person, size: 44, color: Colors.white70),
      );
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool filled;
  const _ActionButton(
      {required this.onTap, required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: filled
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white70, width: 1.5),
                ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: filled ? AppTheme.bordeaux : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Confetti painter: colored particles falling and rotating over time.
class _ConfettiPainter extends CustomPainter {
  final double t; // 0..1 progress
  _ConfettiPainter(this.t);

  static const _colors = [
    Color(0xFFFFE082),
    Color(0xFFFF6B6B),
    Color(0xFFFFFFFF),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFAB47BC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rnd = Random(42); // deterministic layout
    final count = 60;

    for (var i = 0; i < count; i++) {
      // Each particle has its own spread angle and speed.
      final angle = (rnd.nextDouble() * pi * 2);
      final dist = (size.shortestSide * 0.55) *
          (0.3 + rnd.nextDouble() * 0.9) *
          (t + 0.05);
      final dx = center.dx + cos(angle) * dist;
      // Add gravity so particles drift downward over time.
      final dy = center.dy + sin(angle) * dist + t * t * 220;

      final rectW = 6.0 + rnd.nextDouble() * 6;
      final rectH = 3.0 + rnd.nextDouble() * 4;
      final rotation = (angle + t * 6 + i) ;
      final color = _colors[i % _colors.length];

      final paint = Paint()
        ..color = color.withValues(alpha: (1 - t).clamp(0.0, 1.0) * 0.95);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: rectW, height: rectH),
          Radius.circular(rectH / 2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.t != t;
}
