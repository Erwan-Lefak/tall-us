import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Premium Rewind Button - Undo last swipe
class RewindButton extends StatelessWidget {
  final bool canRewind;
  final int? hoursRemaining;
  final VoidCallback onRewind;

  const RewindButton({
    super.key,
    required this.canRewind,
    this.hoursRemaining,
    required this.onRewind,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canRewind ? onRewind : _showLockedDialog,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: canRewind ? AppTheme.gold : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: canRewound
                  ? AppTheme.gold.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: canRewound
            ? const Icon(
                Icons.replay,
                color: Colors.white,
                size: 28,
              )
            : Icon(
                Icons.lock,
                color: AppTheme.navy.withValues(alpha: 0.3),
                size: 24,
              ),
      ),
    ).animate(target: canRewind ? 1 : 0).shake(
          hz: 2,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
        );
  }

  void _showLockedDialog() {
    // Can be implemented to show premium upsell
  }
}

/// Premium Boost Button - Increase profile visibility
class BoostButton extends StatefulWidget {
  final bool canBoost;
  final int? boostsRemaining;
  final VoidCallback onBoost;

  const BoostButton({
    super.key,
    required this.canBoost,
    this.boostsRemaining,
    required this.onBoost,
  });

  @override
  State<BoostButton> createState() => _BoostButtonState();
}

class _BoostButtonState extends State<BoostButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.canBoost ? widget.onBoost : _showLockedDialog,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.canBoost ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: widget.canBoost
                    ? LinearGradient(
                        colors: [
                          AppTheme.bordeaux,
                          AppTheme.bordeaux.withValues(alpha: 0.8),
                        ],
                      )
                    : null,
                color: widget.canBoost ? null : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.canBoost
                        ? AppTheme.bordeaux.withValues(
                            alpha: _glowAnimation.value,
                          )
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: widget.canBoost ? 20 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: widget.canBoost
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 24,
                        ),
                        if (widget.boostsRemaining != null)
                          Text(
                            '${widget.boostsRemaining}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    )
                  : Icon(
                      Icons.lock,
                      color: AppTheme.navy.withValues(alpha: 0.3),
                      size: 24,
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showLockedDialog() {
    // Show premium upsell dialog
  }
}

/// Premium Boost Active Indicator
class BoostActiveIndicator extends StatefulWidget {
  final DateTime boostStartTime;
  final Duration boostDuration;

  const BoostActiveIndicator({
    super.key,
    required this.boostStartTime,
    required this.boostDuration,
  });

  @override
  State<BoostActiveIndicator> createState() => _BoostActiveIndicatorState();
}

class _BoostActiveIndicatorState extends State<BoostActiveIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bordeaux,
            AppTheme.bordeaux.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOOST ACTIVÉ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  final elapsed =
                      DateTime.now().difference(widget.boostStartTime);
                  final remaining = widget.boostDuration - elapsed;
                  if (remaining.isNegative) return const SizedBox.shrink();
                  final minutes = remaining.inMinutes;
                  final seconds = remaining.inSeconds % 60;
                  return Text(
                    '$minutes:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().pulse(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
  }
}
