import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Swipeable profile card showing user information
class ProfileCard extends StatefulWidget {
  final UserProfileEntity profile;
  final VoidCallback? onLike;
  final VoidCallback? onPass;
  final VoidCallback? onSuperLike;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onLike,
    this.onPass,
    this.onSuperLike,
    this.onTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double _dragOffset = 0.0;
  final double _dragThreshold = 100.0; // Distance to trigger swipe

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;

        // Check if swipe should trigger
        if (_dragOffset > _dragThreshold || velocity > 500) {
          // Swiped right - LIKE
          if (widget.onLike != null) {
            widget.onLike!();
          }
        } else if (_dragOffset < -_dragThreshold || velocity < -500) {
          // Swiped left - PASS
          if (widget.onPass != null) {
            widget.onPass!();
          }
        }

        // Reset offset
        setState(() {
          _dragOffset = 0.0;
        });
      },
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Transform.rotate(
          angle: _dragOffset * 0.05, // Rotate slightly when dragging
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo section
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // LIKE overlay (when dragging right)
                    if (_dragOffset > 20)
                      Positioned(
                        top: 80,
                        left: 40,
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.bordeaux,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'LIKE',
                              style: TextStyle(
                                color: AppTheme.bordeaux,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // NOPE overlay (when dragging left)
                    if (_dragOffset < -20)
                      Positioned(
                        top: 80,
                        right: 40,
                        child: Transform.rotate(
                          angle: 0.3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.navy.withValues(alpha: 0.6),
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'NOPE',
                              style: TextStyle(
                                color: AppTheme.navy.withValues(alpha: 0.6),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                  // Main photo
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: widget.profile.photoUrls.isNotEmpty
                        ? Image.network(
                            widget.profile.photoUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.navy.withValues(alpha: 0.1),
                                child: const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: AppTheme.navy,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppTheme.navy.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.person,
                              size: 100,
                              color: AppTheme.navy,
                            ),
                          ),
                  ),

                  // Gradient overlay for text readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Verified badge
                  if (widget.profile.heightVerified)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Taille vérifiée',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // User info overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and age
                          Row(
                            children: [
                              Text(
                                widget.profile.displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.profile.calculateAge()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Height
                          Row(
                            children: [
                              const Icon(
                                Icons.height,
                                color: AppTheme.gold,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.profile.heightCm}cm (${widget.profile.getHeightInFeetInches()})',
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Location
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.profile.city}, ${widget.profile.country}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Bio
                          if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              widget.profile.bio!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Prompt section (if available)
            if (widget.profile.promptAnswer != null && widget.profile.promptAnswer!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.profile.promptAnswer!,
                      style: TextStyle(
                        color: AppTheme.navy,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  ),
);
  }
}
