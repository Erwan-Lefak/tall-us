import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/cached_network_image_widget.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Top Picks - Algorithm-based matching
class TopPickScore {
  final UserProfileEntity profile;
  final double compatibilityScore;
  final List<String> matchReasons;

  const TopPickScore({
    required this.profile,
    required this.compatibilityScore,
    required this.matchReasons,
  });
}

/// Top Picks Widget
class TopPicksWidget extends StatefulWidget {
  final List<UserProfileEntity> allProfiles;
  final List<String> userInterests;
  final Function(UserProfileEntity) onPickSelected;

  const TopPicksWidget({
    super.key,
    required this.allProfiles,
    required this.userInterests,
    required this.onPickSelected,
  });

  @override
  State<TopPicksWidget> createState() => _TopPicksWidgetState();
}

class _TopPicksWidgetState extends State<TopPicksWidget> {
  bool _isLoading = true;
  List<TopPickScore> _topPicks = [];

  @override
  void initState() {
    super.initState();
    _calculateTopPicks();
  }

  Future<void> _calculateTopPicks() async {
    // Simulate algorithm calculation
    await Future.delayed(const Duration(milliseconds: 800));

    final scores = widget.allProfiles.map((profile) {
      final score = _calculateCompatibilityScore(profile);
      return TopPickScore(
        profile: profile,
        compatibilityScore: score,
        matchReasons: _getMatchReasons(profile),
      );
    }).toList();

    // Sort by score and take top 10
    scores.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    setState(() {
      _topPicks = scores.take(10).toList();
      _isLoading = false;
    });
  }

  double _calculateCompatibilityScore(UserProfileEntity profile) {
    double score = 50.0; // Base score

    // Interest overlap (40% weight)
    final profileInterests = profile.interests ?? [];
    final commonInterests = widget.userInterests
        .where((interest) => profileInterests.contains(interest))
        .length;
    final interestScore = (commonInterests / 5) * 40; // Max 40 points
    score += interestScore;

    // Distance proximity (20% weight)
    // In production, calculate actual distance
    final distanceScore = 15.0; // Placeholder
    score += distanceScore;

    // Age proximity (15% weight)
    // In production, compare with user's age
    final ageScore = 10.0; // Placeholder
    score += ageScore;

    // Profile completeness (15% weight)
    final hasPhoto = profile.photoUrls.isNotEmpty;
    final hasBio = profile.bio != null && profile.bio!.isNotEmpty;
    final hasPrompts = profile.prompts.isNotEmpty;
    final completenessScore =
        ((hasPhoto ? 1 : 0) + (hasBio ? 1 : 0) + (hasPrompts ? 1 : 0)) / 3 * 15;
    score += completenessScore;

    // Activity score (10% weight)
    // In production, use last active timestamp
    final activityScore = 8.0; // Placeholder
    score += activityScore;

    return score.clamp(0, 100);
  }

  List<String> _getMatchReasons(UserProfileEntity profile) {
    final reasons = <String>[];

    final profileInterests = profile.interests ?? [];
    final commonInterests = widget.userInterests
        .where((interest) => profileInterests.contains(interest))
        .toList();

    if (commonInterests.isNotEmpty) {
      reasons.add(
          'Vous avez ${commonInterests.length} intérêt${commonInterests.length > 1 ? 's' : ''} en commun');
    }

    if (profile.heightVerified) {
      reasons.add('Taille vérifiée');
    }

    if (profile.bio != null && profile.bio!.isNotEmpty) {
      reasons.add('Profil complet');
    }

    if (profile.photoUrls.length >= 3) {
      reasons.add('Plusieurs photos');
    }

    if (reasons.isEmpty) {
      reasons.add('Profil intéressant');
    }

    return reasons.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.gold,
                          AppTheme.gold.withValues(alpha: 0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Top Picks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      Text(
                        'Sélectionnés pour vous',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.gold,
                      AppTheme.gold.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Platinum',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Content
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
              ),
            )
          else if (_topPicks.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppTheme.gray300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun top pick disponible',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _topPicks.length,
              itemBuilder: (context, index) {
                final pick = _topPicks[index];
                return _TopPickCard(
                  pick: pick,
                  onTap: () => widget.onPickSelected(pick.profile),
                  rank: index + 1,
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Top Pick Card
class _TopPickCard extends StatelessWidget {
  final TopPickScore pick;
  final VoidCallback onTap;
  final int rank;

  const _TopPickCard({
    required this.pick,
    required this.onTap,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final profile = pick.profile;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Photo
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: profile.photoUrls.isNotEmpty
                        ? CachedNetworkImageWidget(
                            imageUrl: profile.photoUrls.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Container(
                            color: AppTheme.gray200,
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: AppTheme.gray400,
                            ),
                          ),
                  ),

                  // Rank badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.gold,
                            AppTheme.gold.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.gold.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '#$rank',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).scale(),

                  // Compatibility score
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: AppTheme.bordeaux,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pick.compatibilityScore.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: AppTheme.bordeaux,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // User info
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '${profile.calculateAge()}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (profile.heightVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.success.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${profile.heightCm}cm',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Match reasons
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppTheme.gray200,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...pick.matchReasons.take(2).map((reason) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.success,
                            size: 12,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.gray700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale();
  }
}

/// "See who likes you" widget
class WhoLikesYouWidget extends StatefulWidget {
  final List<UserProfileEntity> usersWhoLiked;
  final bool isPlatinum;
  final VoidCallback onUpgrade;

  const WhoLikesYouWidget({
    super.key,
    required this.usersWhoLiked,
    required this.isPlatinum,
    required this.onUpgrade,
  });

  @override
  State<WhoLikesYouWidget> createState() => _WhoLikesYouWidgetState();
}

class _WhoLikesYouWidgetState extends State<WhoLikesYouWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppTheme.bordeaux,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vous aime',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                  Text(
                    '${widget.usersWhoLiked.length} personne${widget.usersWhoLiked.length > 1 ? 's' : ''} vous aime${widget.usersWhoLiked.length > 1 ? 'nt' : ''}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Content
          if (!widget.isPlatinum)
            _buildLockedContent()
          else if (widget.usersWhoLiked.isEmpty)
            _buildEmptyContent()
          else
            _buildLikedList(),
        ],
      ),
    );
  }

  Widget _buildLockedContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.platinum.withValues(alpha: 0.1),
            AppTheme.bordeaux.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.platinum.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock,
            size: 48,
            color: AppTheme.platinum.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Fonction Platinum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Passez Platinum pour voir qui vous aime',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: widget.onUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.platinum,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Passer Platinum',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppTheme.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            'Personne ne vous aime encore',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continuez à swiper pour augmenter vos chances',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.usersWhoLiked.length,
      itemBuilder: (context, index) {
        final user = widget.usersWhoLiked[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.bordeaux.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: user.photoUrls.isNotEmpty
                    ? CachedNetworkImageWidget(
                        imageUrl: user.photoUrls.first,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: AppTheme.gray200,
                        child: Icon(
                          Icons.person,
                          color: AppTheme.gray400,
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navy,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${user.calculateAge()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (user.city != null)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.gray500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user.city!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.gray600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Like icon
              Icon(
                Icons.favorite,
                color: AppTheme.bordeaux,
                size: 28,
              ),
            ],
          ),
        );
      },
    );
  }
}
