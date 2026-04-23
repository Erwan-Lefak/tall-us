import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

/// Premium Shimmer Loading Effect
///
/// Provides a smooth, elegant shimmer effect for loading states
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor = AppTheme.gray100,
    this.highlightColor = AppTheme.gray200,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Skeleton Card for Profile Loading
class SkeletonProfileCard extends StatelessWidget {
  final double? width;
  final double? height;

  const SkeletonProfileCard({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 500,
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ShimmerLoading(
        baseColor: AppTheme.gray100,
        highlightColor: AppTheme.gray200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo placeholder
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              ),
            ),

            // Info section
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name placeholder
                    Container(
                      width: 150,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Location placeholder
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info badges
                    Row(
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 60,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.gray100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        curve: Curves.easeOut);
  }
}

/// Skeleton List for Messages/Matches
class SkeletonListItem extends StatelessWidget {
  final bool showAvatar;
  final bool showTrailing;

  const SkeletonListItem({
    super.key,
    this.showAvatar = true,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      baseColor: AppTheme.gray50,
      highlightColor: AppTheme.gray200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Avatar
            if (showAvatar)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  shape: BoxShape.circle,
                ),
              ),

            if (showAvatar) const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Container(
                    width: 120,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Message preview
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            // Trailing
            if (showTrailing) ...[
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: AppTheme.gray200);
  }
}

/// Premium Loading Indicator
class PremiumLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const PremiumLoadingIndicator({
    super.key,
    this.message,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              backgroundColor: AppTheme.gray200,
            ),
          ).animate().fadeIn(duration: 300.ms).then().shimmer(
              duration: 1500.ms, color: AppTheme.gold.withValues(alpha: 0.5)),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.navy.withValues(alpha: 0.6),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
        ],
      ),
    );
  }
}

/// Skeleton Card Stack for Discovery Screen
class SkeletonCardStack extends StatelessWidget {
  final int cardCount;

  const SkeletonCardStack({
    super.key,
    this.cardCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(cardCount, (index) {
        final offset = index * 8.0;
        final scale = 1.0 - (index * 0.05);
        final opacity = 1.0 - (index * 0.3);

        return Positioned.fill(
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, offset),
                child: SkeletonProfileCard(),
              ),
            ),
          ),
        );
      }),
    ).animate().fadeIn(duration: 400.ms);
  }
}
