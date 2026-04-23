import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated Tagline with Staggered Letter Animation
class AnimatedTaglineWidget extends StatelessWidget {
  final String tagline;
  final TextStyle style;
  final Duration delay;

  const AnimatedTaglineWidget({
    super.key,
    required this.tagline,
    required this.style,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    // Split tagline into words for staggered animation
    final words = tagline.split(' ');

    return Wrap(
      alignment: WrapAlignment.center,
      children: words.map((word) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            word,
            style: style,
          )
              .animate()
              .fadeIn(delay: delay, duration: 600.ms)
              .slideY(
                  begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOut)
              .then()
              .shimmer(
                  duration: 1500.ms,
                  color: Colors.white.withValues(alpha: 0.3)),
        );
      }).toList(),
    );
  }
}
