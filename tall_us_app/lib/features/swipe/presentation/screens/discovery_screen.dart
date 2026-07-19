import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_providers.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/match/presentation/widgets/match_dialog.dart';
import 'package:tall_us/features/notification/presentation/widgets/notifications_dropdown.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/presentation/providers/swipe_providers.dart';
import 'package:tall_us/features/swipe/presentation/widgets/profile_card.dart';
import 'package:tall_us/features/swipe/presentation/widgets/super_like_animation.dart';
import 'package:tall_us/features/swipe/presentation/providers/swipe_limits_provider.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';
import 'package:tall_us/features/verification/presentation/providers/height_verification_provider.dart';

/// Discovery/Swipe screen with real Appwrite data
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  void _handleSwipe(BuildContext context, WidgetRef ref, String profileId, SwipeAction action) async {
    final currentUser = ref.read(authenticatedUserProvider);

    if (currentUser == null) {
      AppLogger.e('User not authenticated, cannot swipe');
      return;
    }

    // Height-verification gate: like / super-like require a verified height.
    // Pass (j'aime pas) is always allowed.
    if (action == SwipeAction.like || action == SwipeAction.superLike) {
      final status =
          await ref.read(heightVerificationStatusProvider.future);
      final verified = status?.isVerified() ?? false;
      if (!verified) {
        _showHeightVerificationGate(context, status);
        return; // abort: no swipe created, card stays in the stack
      }
    }

    // Daily-limit gate: like / super-like consume a daily allowance based on
    // the user's subscription tier. Pass is always allowed.
    if (action == SwipeAction.like || action == SwipeAction.superLike) {
      final limits = await ref.read(swipeLimitsProvider.future);
      final allowed = action == SwipeAction.like
          ? limits.canLike
          : limits.canSuperLike;
      if (!allowed) {
        _showDailyLimitReached(context, action, limits);
        return;
      }
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

    // Refresh the daily-limit counter so the next gate is accurate.
    if (action == SwipeAction.like || action == SwipeAction.superLike) {
      ref.invalidate(swipeLimitsProvider);
    }

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

  /// Contextual popup shown when an unverified user tries to like / super-like.
  void _showHeightVerificationGate(
      BuildContext context, HeightVerificationEntity? status) {
    final inProgress = status?.isInProgress() ?? false;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(inProgress ? Icons.hourglass_top : Icons.verified_user,
                color: AppTheme.bordeaux),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                inProgress ? 'Presque !' : 'Vérifie ta taille',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        content: Text(
          inProgress
              ? 'Ta vérification est en cours. Tu pourras liker dès qu\'elle est validée par notre équipe.'
              : 'Pour liker et super-liker, prouve ta taille avec une photo. C\'est rapide et ça débloque les likes.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              inProgress ? 'D\'accord' : 'Plus tard',
              style: TextStyle(color: AppTheme.navy.withValues(alpha: 0.6)),
            ),
          ),
          if (!inProgress)
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/verify-height');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
              ),
              child: const Text('Vérifier ma taille'),
            ),
        ],
      ),
    );
  }

  /// Popup shown when the daily like / super-like allowance is exhausted.
  void _showDailyLimitReached(
      BuildContext context, SwipeAction action, SwipeLimits limits) {
    final isLike = action == SwipeAction.like;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.bolt, color: AppTheme.gold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isLike
                    ? 'Limite de likes atteinte'
                    : 'Super likes épuisés',
                style: const TextStyle(
                    fontSize: 19, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        content: Text(
          isLike
              ? "Tu as utilisé tes ${limits.likeLimit} likes gratuits d'aujourd'hui. Passe à Tall pour 15 likes/jour — ou à Élite pour des likes illimités."
              : "Les super likes sont réservés aux forfaits Tall (5/j) et au-delà. Découvre nos forfaits pour en profiter.",
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Plus tard',
                style: TextStyle(
                    color: AppTheme.navy.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
            ),
            child: const Text('Voir les forfaits'),
          ),
        ],
      ),
    );
  }

  void _showMatchDialog(BuildContext context, WidgetRef ref, MatchEntity match) {
    final currentUser = ref.read(authenticatedUserProvider);

    // Get the matched user ID (the one that's not current user)
    final matchedUserId =
        match.user1Id == currentUser?.id ? match.user2Id : match.user1Id;

    _presentMatchDialog(context, ref, currentUser?.id ?? '', matchedUserId);
  }

  Future<void> _presentMatchDialog(BuildContext context, WidgetRef ref,
      String currentUserId, String matchedUserId) async {
    final databases = ref.read(databasesProvider);

    UserProfileEntity? currentUserProfile;
    UserProfileEntity? matchedUserProfile;

    // Fetch both profiles (doc id == userId in this app).
    try {
      final cur = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: currentUserId,
      );
      currentUserProfile = UserProfileEntity.fromMap(cur.data);
    } catch (_) {}
    try {
      final m = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: matchedUserId,
      );
      matchedUserProfile = UserProfileEntity.fromMap(m.data);
    } catch (_) {}

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MatchDialog(
        currentUser: currentUserProfile ??
            UserProfileEntity(
              id: currentUserId,
              userId: currentUserId,
              displayName: 'Vous',
              gender: 'other',
              heightCm: 170,
              birthday: DateTime.now(),
              city: '',
              country: '',
            ),
        matchedUser: matchedUserProfile ??
            UserProfileEntity(
              id: matchedUserId,
              userId: matchedUserId,
              displayName: 'Nouveau match',
              gender: 'other',
              heightCm: 170,
              birthday: DateTime.now(),
              city: '',
              country: '',
            ),
        onMessageTap: () {
          Navigator.of(context).pop();
          AppLogger.i('Navigate to chat with $matchedUserId');
        },
        onKeepSwipingTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
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
              _buildHeader(context, ref),

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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Likes button
          IconButton(
            icon: const Icon(Icons.favorite_border),
            iconSize: 30,
            color: AppTheme.bordeaux,
            onPressed: () => context.go('/likes'),
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

          // Notifications button
          IconButton(
            icon: const Icon(Icons.notifications_none),
            iconSize: 30,
            color: AppTheme.navy,
            onPressed: () => showNotificationsDropdown(context),
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

        return Center(
          child: SizedBox(
            width: maxWidth,
            child: Stack(
              clipBehavior: Clip.none,
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

                // Boost button (Légende tier; placeholder)
                _ActionButton(
                  icon: Icons.bolt,
                  color: AppTheme.gold,
                  size: 24,
                  onTap: () => _showBoost(context, ref),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Boost action: gated to premium tiers, placeholder animation otherwise.
  void _showBoost(BuildContext context, WidgetRef ref) {
    final isPremium = ref.read(authenticatedUserProvider)?.role.maybeWhen(
          premium: () => true,
          admin: () => true,
          orElse: () => false,
        ) ??
        false;

    if (!isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Les boosts sont inclus dans le forfait Légende ✨'),
          backgroundColor: AppTheme.bordeaux,
          action: SnackBarAction(
            label: 'Voir',
            textColor: Colors.white,
            onPressed: () => context.go('/subscription'),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt, color: AppTheme.gold, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Profil boosté !',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy)),
            const SizedBox(height: 8),
            Text(
              'Ton profil est mis en avant pendant 30 minutes. Tu apparaîtras en priorité chez les autres membres.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.7)),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                foregroundColor: Colors.white,
              ),
              child: const Text('Génial !'),
            ),
          ),
        ],
      ),
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
