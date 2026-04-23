import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Typing indicator widget showing animated dots
class TypingIndicator extends StatelessWidget {
  final List<String> userNames;
  final bool isTyping;

  const TypingIndicator({
    super.key,
    required this.userNames,
    this.isTyping = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTyping || userNames.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDots(),
                const SizedBox(width: 8),
                _buildTypingText(),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAnimatedDots() {
    return Row(
      children: [
        _buildDot(delay: 0),
        const SizedBox(width: 4),
        _buildDot(delay: 150),
        const SizedBox(width: 4),
        _buildDot(delay: 300),
      ],
    );
  }

  Widget _buildDot({required int delay}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.bordeaux,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .then()
        .fadeOut(duration: 600.ms);
  }

  Widget _buildTypingText() {
    final text = userNames.length == 1
        ? '${userNames.first} est en train d\'écrire...'
        : '${userNames.length} personnes sont en train d\'écrire...';

    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: AppTheme.gray700,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Compact typing indicator for inline display
class CompactTypingIndicator extends StatelessWidget {
  final bool isTyping;

  const CompactTypingIndicator({
    super.key,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTyping) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.bordeaux.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: Stack(
              children: [
                _buildDot(0),
                _buildDot(150),
                _buildDot(300),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildDot(int delay) {
    return Positioned(
      left: delay ~/ 40,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: AppTheme.bordeaux,
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 600.ms, delay: delay.ms)
          .then()
          .fadeOut(duration: 600.ms),
    );
  }
}

/// Typing indicator with avatar
class TypingIndicatorWithAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String userName;
  final bool isTyping;

  const TypingIndicatorWithAvatar({
    super.key,
    this.avatarUrl,
    required this.userName,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTyping) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 16, color: AppTheme.gray500)
                : null,
          ),

          const SizedBox(width: 8),

          // Typing bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDots(),
                const SizedBox(width: 8),
                Text(
                  'écrit...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAnimatedDots() {
    return Row(
      children: [
        _buildDot(delay: 0),
        const SizedBox(width: 4),
        _buildDot(delay: 150),
        const SizedBox(width: 4),
        _buildDot(delay: 300),
      ],
    );
  }

  Widget _buildDot({required int delay}) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppTheme.bordeaux,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .then()
        .fadeOut(duration: 600.ms);
  }
}
