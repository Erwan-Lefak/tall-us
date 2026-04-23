import 'package:flutter/material.dart';

/// Premium Glowing Logo Widget with Pulse Effect
class GlowingLogoWidget extends StatefulWidget {
  final double size;
  final String? imagePath;
  final String logoText;
  final Color glowColor;
  final Duration pulseDuration;

  const GlowingLogoWidget({
    super.key,
    this.size = 200,
    this.imagePath,
    this.logoText = 'TU',
    this.glowColor = const Color(0xFFC9A962), // Gold
    this.pulseDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<GlowingLogoWidget> createState() => _GlowingLogoWidgetState();
}

class _GlowingLogoWidgetState extends State<GlowingLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for glow effect
    _pulseController = AnimationController(
      vsync: this,
      duration: widget.pulseDuration,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 0.12),
                boxShadow: [
                  // Inner glow
                  BoxShadow(
                    color: widget.glowColor
                        .withValues(alpha: 0.3 * _pulseAnimation.value),
                    blurRadius: 30 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                  // Outer glow
                  BoxShadow(
                    color: widget.glowColor
                        .withValues(alpha: 0.2 * _pulseAnimation.value),
                    blurRadius: 60 * _pulseAnimation.value,
                    spreadRadius: 10 * _pulseAnimation.value,
                  ),
                  // Ambient glow
                  BoxShadow(
                    color: widget.glowColor.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.size * 0.12),
                child: Container(
                  color: Colors.white,
                  child: widget.imagePath != null
                      ? Image.asset(
                          widget.imagePath!,
                          width: widget.size,
                          height: widget.size,
                          fit: BoxFit.contain,
                        )
                      : Center(
                          child: Text(
                            widget.logoText,
                            style: TextStyle(
                              fontSize: widget.size * 0.5,
                              fontWeight: FontWeight.bold,
                              color: widget.glowColor,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
