import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/cached_network_image_widget.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Animated match dialog showing two profiles that matched
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),

                // Match title
                const Text(
                  'It\'s a Match!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'You and ${widget.matchedUser.displayName} liked each other',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 32),

                // Photos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Current user photo
                    _buildPhoto(
                      widget.currentUser.photoUrls.isNotEmpty
                          ? widget.currentUser.photoUrls.first
                          : '',
                      isCurrentUser: true,
                    ),

                    const SizedBox(width: 20),

                    // Heart icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.favorite,
                          color: AppTheme.bordeaux,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Matched user photo
                    _buildPhoto(
                      widget.matchedUser.photoUrls.isNotEmpty
                          ? widget.matchedUser.photoUrls.first
                          : '',
                      isCurrentUser: false,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Keep swiping button
                      Expanded(
                        child: _buildActionButton(
                          onTap: widget.onKeepSwipingTap,
                          label: 'Keep Swiping',
                          isSecondary: true,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Send message button
                      Expanded(
                        child: _buildActionButton(
                          onTap: widget.onMessageTap,
                          label: 'Send Message',
                          isSecondary: false,
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
    );
  }

  Widget _buildPhoto(String photoUrl, {required bool isCurrentUser}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? CachedNetworkImageWidget(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey.shade600,
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String label,
    required bool isSecondary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSecondary ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border:
              isSecondary ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSecondary
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSecondary ? Colors.white : AppTheme.bordeaux,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
