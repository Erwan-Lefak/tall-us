import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Swipeable profile card with expand/collapse animation.
///
/// Compact state: Tinder-style photo with overlay info.
/// Expanded state: Scrollable details with photo at top.
class ProfileCard extends StatefulWidget {
  final UserProfileEntity profile;
  final VoidCallback? onLike;
  final VoidCallback? onPass;
  final VoidCallback? onSuperLike;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onLike,
    this.onPass,
    this.onSuperLike,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with SingleTickerProviderStateMixin {
  double _dragOffsetX = 0.0;
  double _totalDragX = 0.0;
  double _totalDragY = 0.0;
  bool _isExpanded = false;
  bool _dragDirectionDecided = false;
  bool _isVerticalDrag = false;

  final double _swipeThreshold = 100.0;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  String _getGenderLabel(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'homme':
      case 'man':
        return 'Homme';
      case 'female':
      case 'femme':
      case 'woman':
        return 'Femme';
      default:
        return 'Autre';
    }
  }

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'homme':
      case 'man':
        return Icons.male;
      case 'female':
      case 'femme':
      case 'woman':
        return Icons.female;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, _) {
            final expandValue = _expandAnimation.value;

            return Transform.translate(
              offset: Offset(_dragOffsetX * (1 - expandValue), 0),
              child: Transform.rotate(
                angle: _dragOffsetX * 0.05 * (1 - expandValue),
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
                  clipBehavior: Clip.antiAlias,
                  child: GestureDetector(
                    onTap: _toggleExpand,
                    onPanStart: (_) {
                      _dragDirectionDecided = false;
                      _isVerticalDrag = false;
                      _totalDragX = 0;
                      _totalDragY = 0;
                    },
                    onPanUpdate: (details) {
                      _totalDragX += details.delta.dx;
                      _totalDragY += details.delta.dy;

                      // Decide direction once
                      if (!_dragDirectionDecided) {
                        if (_totalDragX.abs() > 8 || _totalDragY.abs() > 8) {
                          _dragDirectionDecided = true;
                          _isVerticalDrag = _totalDragY.abs() > _totalDragX.abs();
                        }
                      }

                      if (_isVerticalDrag) {
                        // Vertical drag → expand/collapse
                        setState(() {
                          if (details.delta.dy > 0 && !_isExpanded) {
                            _toggleExpand();
                          } else if (details.delta.dy < 0 && _isExpanded) {
                            _toggleExpand();
                          }
                        });
                      } else if (!_isExpanded) {
                        // Horizontal drag → swipe (only in compact mode)
                        setState(() {
                          _dragOffsetX += details.delta.dx;
                        });
                      }
                    },
                    onPanEnd: (details) {
                      if (!_isVerticalDrag && !_isExpanded) {
                        final velocityX = details.velocity.pixelsPerSecond.dx;
                        if (_dragOffsetX > _swipeThreshold || velocityX > 500) {
                          widget.onLike?.call();
                        } else if (_dragOffsetX < -_swipeThreshold || velocityX < -500) {
                          widget.onPass?.call();
                        }
                      }
                      setState(() {
                        _dragOffsetX = 0.0;
                      });
                    },
                    child: expandValue < 0.5
                        ? _buildCompactView(constraints, expandValue)
                        : _buildExpandedView(constraints, expandValue),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Compact view: photo fills entire card with overlay info
  Widget _buildCompactView(BoxConstraints constraints, double expandValue) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main photo
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: widget.profile.photoUrls.isNotEmpty
              ? Image.network(
                  widget.profile.photoUrls.first,
                  fit: BoxFit.cover,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
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

        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
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

        // LIKE overlay
        if (_dragOffsetX > 20)
          Positioned(
            top: 80,
            left: 40,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.bordeaux, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LIKE',
                  style: TextStyle(
                    color: AppTheme.bordeaux,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.black.withValues(alpha: 0.3)),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // NOPE overlay
        if (_dragOffsetX < -20)
          Positioned(
            top: 80,
            right: 40,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.navy.withValues(alpha: 0.6), width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NOPE',
                  style: TextStyle(
                    color: AppTheme.navy.withValues(alpha: 0.6),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.black.withValues(alpha: 0.3)),
                    ],
                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Taille vérifiée',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

        // Photo counter
        if (widget.profile.photoUrls.length > 1)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '1/${widget.profile.photoUrls.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),

        // Compact info overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: (1.0 - expandValue * 2).clamp(0.0, 1.0),
            child: _buildCompactInfoOverlay(),
          ),
        ),

        // Chevron hint
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  /// Expanded view: photo at top + scrollable details
  Widget _buildExpandedView(BoxConstraints constraints, double expandValue) {
    final photoHeight = constraints.maxHeight * 0.38;

    return Column(
      children: [
        // Photo at top (reduced height)
        SizedBox(
          height: photoHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: widget.profile.photoUrls.isNotEmpty
                    ? Image.network(
                        widget.profile.photoUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.navy.withValues(alpha: 0.1),
                            child: const Icon(Icons.person, size: 80, color: AppTheme.navy),
                          );
                        },
                      )
                    : Container(
                        color: AppTheme.navy.withValues(alpha: 0.1),
                        child: const Icon(Icons.person, size: 80, color: AppTheme.navy),
                      ),
              ),

              // Light gradient on top photo
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.15),
                      ],
                      stops: const [0.0, 0.6, 1.0],
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Taille vérifiée',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Scrollable details
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and age
                Row(
                  children: [
                    Text(
                      widget.profile.displayName,
                      style: TextStyle(color: AppTheme.navy, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.profile.calculateAge()}',
                      style: TextStyle(
                        color: AppTheme.navy.withValues(alpha: 0.7),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Height row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.height, color: AppTheme.gold, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        '${widget.profile.heightCm} cm',
                        style: TextStyle(color: AppTheme.navy, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.profile.getHeightInFeetInches()})',
                        style: TextStyle(color: AppTheme.navy.withValues(alpha: 0.6), fontSize: 16),
                      ),
                      const Spacer(),
                      if (widget.profile.heightVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: AppTheme.success, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Vérifiée',
                                style: TextStyle(color: AppTheme.success, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppTheme.bordeaux, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.profile.city}, ${widget.profile.country}',
                      style: TextStyle(color: AppTheme.navy.withValues(alpha: 0.8), fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Gender
                Row(
                  children: [
                    Icon(_getGenderIcon(widget.profile.gender), color: AppTheme.bordeaux, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      _getGenderLabel(widget.profile.gender),
                      style: TextStyle(color: AppTheme.navy.withValues(alpha: 0.8), fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Divider
                Divider(color: AppTheme.navy.withValues(alpha: 0.08), thickness: 1),

                const SizedBox(height: 20),

                // Bio
                if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty) ...[
                  Text(
                    'À propos',
                    style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.profile.bio!,
                    style: TextStyle(
                      color: AppTheme.navy.withValues(alpha: 0.8),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: AppTheme.navy.withValues(alpha: 0.08), thickness: 1),
                  const SizedBox(height: 20),
                ],

                // Prompt
                if (widget.profile.promptAnswer != null && widget.profile.promptAnswer!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.bordeaux.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.bordeaux.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.format_quote, color: AppTheme.bordeaux, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Ma réponse',
                              style: TextStyle(color: AppTheme.bordeaux, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.profile.promptAnswer!,
                          style: TextStyle(
                            color: AppTheme.navy,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Collapse hint
                Center(
                  child: GestureDetector(
                    onTap: _toggleExpand,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.navy.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_up, color: AppTheme.navy.withValues(alpha: 0.5), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Voir moins',
                            style: TextStyle(
                              color: AppTheme.navy.withValues(alpha: 0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Compact info overlay shown at bottom of photo (Tinder-style)
  Widget _buildCompactInfoOverlay() {
    return Padding(
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
                  shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.profile.calculateAge()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Height
          Row(
            children: [
              const Icon(Icons.height, color: AppTheme.gold, size: 20),
              const SizedBox(width: 4),
              Text(
                '${widget.profile.heightCm}cm (${widget.profile.getHeightInFeetInches()})',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black45)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text(
                '${widget.profile.city}, ${widget.profile.country}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black45)],
                ),
              ),
            ],
          ),
          // Bio preview
          if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              widget.profile.bio!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                shadows: [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black45)],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
