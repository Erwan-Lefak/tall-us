import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

/// Overlay for LIKE/NOPE/SUPERLIKE indicators
enum CardOverlay {
  none,
  like,
  pass,
  superLike,
}

/// Premium Swipeable Card with Physics and Natural Animations
class PremiumSwipeableCard extends StatefulWidget {
  final Widget cardContent;
  final Function(CardOverlay)? onSwipe;
  final bool enableDrag;
  final Function()? onTap;

  const PremiumSwipeableCard({
    super.key,
    required this.cardContent,
    this.onSwipe,
    this.enableDrag = true,
    this.onTap,
  });

  @override
  State<PremiumSwipeableCard> createState() => _PremiumSwipeableCardState();
}

class _PremiumSwipeableCardState extends State<PremiumSwipeableCard>
    with SingleTickerProviderStateMixin {
  CardOverlay _overlay = CardOverlay.none;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: widget.enableDrag ? _handlePanStart : null,
      onPanUpdate: widget.enableDrag ? _handlePanUpdate : null,
      onPanEnd: widget.enableDrag ? _handlePanEnd : null,
      onTap: widget.onTap,
      child: Stack(
        children: [
          // Main card content
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: widget.cardContent,
            ),
          ),

          // Overlay indicator
          if (_overlay != CardOverlay.none) _buildOverlay(),

          // Swipe indicators (small icons in corners)
          _buildSwipeIndicators(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    String text;
    Color color;
    double rotation;

    switch (_overlay) {
      case CardOverlay.like:
        text = 'LIKE';
        color = AppTheme.success;
        rotation = -0.3;
        break;
      case CardOverlay.pass:
        text = 'NOPE';
        color = AppTheme.navy.withValues(alpha: 0.7);
        rotation = 0.3;
        break;
      case CardOverlay.superLike:
        text = 'SUPER\nLIKE';
        color = AppTheme.gold;
        rotation = 0;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color,
              width: 4,
            ),
            color: color.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Transform.rotate(
              angle: rotation,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: color.withValues(alpha: 0.5),
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 150.ms).scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.elasticOut),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeIndicators() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pass indicator (top left)
              _buildIndicatorIcon(
                Icons.close_rounded,
                AppTheme.navy.withValues(alpha: 0.6),
                _overlay == CardOverlay.pass,
              ),

              // Super like indicator (top center)
              _buildIndicatorIcon(
                Icons.star_rounded,
                AppTheme.gold,
                _overlay == CardOverlay.superLike,
              ),

              // Like indicator (top right)
              _buildIndicatorIcon(
                Icons.favorite_rounded,
                AppTheme.bordeaux,
                _overlay == CardOverlay.like,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorIcon(IconData icon, Color color, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : color,
        size: 28,
      ),
    ).animate(target: isActive ? 1 : 0).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
          duration: 150.ms,
          curve: Curves.easeOut,
        );
  }

  // Gesture handlers
  Offset? _dragStartPos;

  void _handlePanStart(DragStartDetails details) {
    _dragStartPos = details.globalPosition;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_dragStartPos == null) return;

    final deltaX = details.globalPosition.dx - _dragStartPos!.dx;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final threshold = screenWidth * 0.2;

    if (deltaX > threshold) {
      setState(() => _overlay = CardOverlay.like);
    } else if (deltaX < -threshold) {
      setState(() => _overlay = CardOverlay.pass);
    } else {
      setState(() => _overlay = CardOverlay.none);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_overlay != CardOverlay.none) {
      widget.onSwipe?.call(_overlay);
    }
    setState(() => _overlay = CardOverlay.none);
    _dragStartPos = null;
  }
}
