import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/match/presentation/widgets/match_dialog.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/presentation/providers/swipe_providers.dart';
import 'package:tall_us/features/swipe/presentation/widgets/profile_card.dart';
import 'package:tall_us/features/swipe/presentation/widgets/super_like_animation.dart';

/// Discovery/Swipe screen with real Appwrite data
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  void _handleSwipe(BuildContext context, WidgetRef ref, String profileId, SwipeAction action) async {
    final currentUser = ref.read(authenticatedUserProvider);

    if (currentUser == null) {
      AppLogger.e('User not authenticated, cannot swipe');
      return;
    }

    AppLogger.i('Swipe ${action.name} on $profileId by ${currentUser.id}');

    // Show Super Like animation if it's a super like
    if (action == SwipeAction.superLike) {
      _showSuperLikeAnimation(context);
      // Wait a bit for the animation to start
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Send swipe to backend
    final swipeNotifier = ref.read(swipeNotifierProvider.notifier);
    await swipeNotifier.performSwipe(
      swiperId: currentUser.id,
      targetId: profileId,
      action: action,
    );

    // Remove profile from discovery list
    ref.read(discoveryNotifierProvider.notifier).removeProfile(profileId);

    // Check if there was a match
    final swipeState = ref.read(swipeNotifierProvider);
    if (swipeState.match != null) {
      _showMatchDialog(context, ref, swipeState.match!);
    }
    if (swipeState.error != null) {
      AppLogger.e('Swipe failed: ${swipeState.error}');
    }
  }

  void _showSuperLikeAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: false,
      builder: (context) => SuperLikeAnimation(
        onAnimationComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showMatchDialog(BuildContext context, WidgetRef ref, MatchEntity match) {
    final currentUser = ref.read(authenticatedUserProvider);

    // Get the matched user ID (the one that's not current user)
    final matchedUserId = match.user1Id == currentUser?.id ? match.user2Id : match.user1Id;

    // Create a UserProfileEntity from UserEntity
    // In production, you'd fetch the matched user's full profile
    UserProfileEntity currentUserProfile = UserProfileEntity(
      id: currentUser?.id ?? '',
      userId: currentUser?.id ?? '',
      displayName: currentUser?.profile?.displayName ?? 'User',
      gender: currentUser?.profile?.gender ?? 'unknown',
      heightCm: currentUser?.profile?.heightCm ?? 170,
      birthday: currentUser?.profile?.birthday ?? DateTime.now(),
      city: currentUser?.profile?.city ?? 'Unknown',
      country: currentUser?.profile?.countryCode ?? 'Unknown',
      photoUrls: [], // ProfileEntity doesn't have photoUrls yet, will be empty for now
    );

    final matchedUser = UserProfileEntity(
      id: matchedUserId,
      userId: matchedUserId,
      displayName: 'Matched User', // In production, fetch real name
      gender: 'unknown',
      heightCm: 170,
      birthday: DateTime.now(),
      city: 'Unknown',
      country: 'Unknown',
      photoUrls: [], // Will show placeholder icon
    );

    if (context.mounted && currentUser != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => MatchDialog(
          currentUser: currentUserProfile,
          matchedUser: matchedUser,
          onMessageTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to chat screen
            AppLogger.i('Navigate to chat with $matchedUserId');
          },
          onKeepSwipingTap: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.05),
              AppTheme.navy.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(ref),

              // Cards stack
              Expanded(
                child: discoveryState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                    ),
                  ),
                  loaded: (profiles) => profiles.isEmpty
                      ? _buildEmptyState()
                      : _buildCardStack(ref, profiles),
                  error: (message) => _buildErrorState(ref, message),
                  noMoreProfiles: () => _buildEmptyState(),
                  initial: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                    ),
                  ),
                ),
              ),

              // Action buttons
              discoveryState.maybeWhen(
                loaded: (profiles) {
                  if (profiles.isNotEmpty) {
                    return _buildActionButtons(ref, profiles.first.id);
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile button
          IconButton(
            icon: const Icon(Icons.person_outline),
            iconSize: 32,
            color: AppTheme.navy,
            onPressed: () {
              // Already on profile tab
            },
          ),

          // Logo
          Column(
            children: [
              Text(
                'Tall Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bordeaux,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'L\'amour vu d\'en haut',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.navy.withValues(alpha: 0.7),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          // Matches button
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            iconSize: 32,
            color: AppTheme.navy,
            onPressed: () {
              // Already on matches tab
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack(WidgetRef ref, List profiles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max card width based on screen size
        final maxWidth = constraints.maxWidth > 600
            ? 400.0 // Tablet/Desktop: limit to 400px
            : double.infinity; // Mobile: full width

        final maxHeight = constraints.maxHeight > 800
            ? constraints.maxHeight * 0.75 // Tablet/Desktop: 75% of height
            : double.infinity; // Mobile: full height

        return Center(
          child: SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Stack(
              children: [
                // Background cards (for depth effect)
                if (profiles.length > 1)
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 0.95,
                      child: Opacity(
                        opacity: 0.5,
                        child: ProfileCard(profile: profiles[1]),
                      ),
                    ),
                  ),
                if (profiles.length > 2)
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 0.9,
                      child: Opacity(
                        opacity: 0.3,
                        child: ProfileCard(profile: profiles[2]),
                      ),
                    ),
                  ),

                // Current interactive card
                Positioned.fill(
                  child: ProfileCard(
                    profile: profiles.first,
                    onTap: () {
                      // TODO: Show full profile view
                    },
                    onLike: () => _handleSwipe(context, ref, profiles.first.id, SwipeAction.like),
                    onPass: () => _handleSwipe(context, ref, profiles.first.id, SwipeAction.pass),
                    onSuperLike: () => _handleSwipe(context, ref, profiles.first.id, SwipeAction.superLike),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(WidgetRef ref, String firstProfileId) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Constrain button width on larger screens
        final maxWidth = constraints.maxWidth > 600 ? 400.0 : double.infinity;

        return Center(
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pass button
                _ActionButton(
                  icon: Icons.close,
                  color: AppTheme.navy.withValues(alpha: 0.6),
                  size: 28,
                  onTap: () => _handleSwipe(context, ref, firstProfileId, SwipeAction.pass),
                ),

                // Super Like button
                _ActionButton(
                  icon: Icons.star,
                  color: AppTheme.gold,
                  size: 24,
                  onTap: () => _handleSwipe(context, ref, firstProfileId, SwipeAction.superLike),
                ),

                // Like button
                _ActionButton(
                  icon: Icons.favorite,
                  color: AppTheme.bordeaux,
                  size: 28,
                  onTap: () => _handleSwipe(context, ref, firstProfileId, SwipeAction.like),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_satisfied_alt_outlined,
            size: 80,
            color: AppTheme.bordeaux.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Bienvenue sur Tall Us !',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'L\'application est en cours de configuration. Pour tester l\'interface, nous allons ajouter des profils de démonstration.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.navy.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Refresh button - will be handled by parent
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Actualiser'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppTheme.bordeaux.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(discoveryNotifierProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
