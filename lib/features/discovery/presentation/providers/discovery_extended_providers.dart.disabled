import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/discovery/data/repositories/discovery_extended_repository.dart';
import 'package:tall_us/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';

part 'discovery_extended_providers.freezed.dart';
part 'discovery_extended_providers.g.dart';

// ==================== Extended Repository Provider ====================

/// Provider for DiscoveryExtendedRepository
final discoveryExtendedRepositoryProvider =
    Provider<DiscoveryExtendedRepository>((ref) {
  final databases = ref.watch(databasesProvider);

  return DiscoveryExtendedRepositoryImpl(databases: databases);
});

// ==================== Who Likes You Provider ====================

/// Notifier for Who Likes You State
class WhoLikesYouNotifier extends StateNotifier<WhoLikesYouState> {
  final DiscoveryExtendedRepository _repository;
  String? _currentUserId;

  WhoLikesYouNotifier(this._repository)
      : super(const WhoLikesYouState.initial());

  void setCurrentUser(String userId) {
    _currentUserId = userId;
    loadWhoLikesYou();
  }

  Future<void> loadWhoLikesYou() async {
    if (_currentUserId == null) return;

    state = const WhoLikesYouState.loading();

    try {
      final usersWhoLiked = await _repository.getWhoLikedMe(_currentUserId!);
      state = WhoLikesYouState.loaded(usersWhoLiked);
    } catch (e, st) {
      AppLogger.e('Failed to load who likes you', error: e, stackTrace: st);
      state = WhoLikesYouState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await loadWhoLikesYou();
  }

  Future<void> markAsSeen(String likeId) async {
    try {
      await _repository.markLikeAsSeen(likeId);
      // Refresh to update the list (seen likes might be handled differently)
      await loadWhoLikesYou();
    } catch (e) {
      AppLogger.e('Failed to mark like as seen', error: e);
    }
  }
}

/// Provider for WhoLikesYouNotifier
final whoLikesYouProvider =
    StateNotifierProvider<WhoLikesYouNotifier, WhoLikesYouState>((ref) {
  final repository = ref.watch(discoveryExtendedRepositoryProvider);
  return WhoLikesYouNotifier(repository);
});

@freezed
class WhoLikesYouState with _$WhoLikesYouState {
  const factory WhoLikesYouState({
    required List<UserProfileEntity> usersWhoLiked,
    @Default(true) bool isLoading,
    String? error,
  }) = _WhoLikesYouState;

  const factory WhoLikesYouState.initial() = _WhoLikesYouState;

  const factory WhoLikesYouState.loading() = _WhoLikesYouState;

  const factory WhoLikesYouState.loaded(List<UserProfileEntity> users) =
      _WhoLikesYouState;

  const factory WhoLikesYouState.error(String message) = _WhoLikesYouState;

  const factory WhoLikesYouState.unauthenticated() = _WhoLikesYouState;
}

// ==================== Top Picks Provider ====================

/// Notifier for Top Picks State
class TopPicksNotifier extends StateNotifier<TopPicksState> {
  final DiscoveryExtendedRepository _repository;
  final DiscoveryRepository _discoveryRepository;
  String? _currentUserId;
  List<String> _userInterests = [];

  TopPicksNotifier(this._repository, this._discoveryRepository)
      : super(const TopPicksState.initial());

  void setCurrentUser(String userId, List<String> interests) {
    _currentUserId = userId;
    _userInterests = interests;
    loadTopPicks();
  }

  Future<void> loadTopPicks() async {
    if (_currentUserId == null) return;

    state = const TopPicksState.calculating();

    try {
      // Get all profiles first
      final profiles = await _discoveryRepository.getProfilesToDiscover(
        userId: _currentUserId!,
        limit: 50,
      );

      // Calculate top picks
      final topPickScores = await _repository.getTopPicks(_currentUserId!);

      if (topPickScores.isEmpty) {
        // No cached scores - calculate on client side
        final calculatedScores = _calculateTopPicks(profiles);
        state = TopPicksState.loaded(calculatedScores);
      } else {
        // Merge profiles with scores
        final profileMap = {for (var p in profiles) p.id: p};
        final topPicks = topPickScores
            .where((score) => profileMap.containsKey(score.profileId))
            .map((score) => TopPickWithProfile(
                  score: score,
                  profile: profileMap[score.profileId]!,
                ))
            .toList();

        state = TopPicksState.loaded(topPicks);
      }
    } catch (e, st) {
      AppLogger.e('Failed to load top picks', error: e, stackTrace: st);
      state = TopPicksState.error(e.toString());
    }
  }

  List<TopPickWithProfile> _calculateTopPicks(
      List<UserProfileEntity> profiles) {
    final scores = profiles.map((profile) {
      final score = _calculateCompatibilityScore(profile);
      final reasons = _getMatchReasons(profile);

      return TopPickWithProfile(
        score: TopPickScore(
          profileId: profile.id,
          compatibilityScore: score,
          matchReasons: reasons,
          calculatedAt: DateTime.now(),
        ),
        profile: profile,
      );
    }).toList();

    // Sort by score descending
    scores.sort((a, b) =>
        b.score.compatibilityScore.compareTo(a.score.compatibilityScore));

    // Take top 10
    return scores.take(10).toList();
  }

  double _calculateCompatibilityScore(UserProfileEntity profile) {
    double score = 50.0; // Base score

    // Interest overlap (40% weight)
    final profileInterests = profile.interests ?? [];
    final commonInterests = _userInterests
        .where((interest) => profileInterests.contains(interest))
        .length;
    final interestScore = (commonInterests / 5) * 40; // Max 40 points
    score += interestScore;

    // Distance proximity (20% weight) - Placeholder
    final distanceScore = 15.0;
    score += distanceScore;

    // Age proximity (15% weight) - Placeholder
    final ageScore = 10.0;
    score += ageScore;

    // Profile completeness (15% weight)
    final hasPhoto = profile.photoUrls.isNotEmpty;
    final hasBio = profile.bio != null && profile.bio!.isNotEmpty;
    final hasPrompts = profile.prompts.isNotEmpty;
    final completenessScore =
        ((hasPhoto ? 1 : 0) + (hasBio ? 1 : 0) + (hasPrompts ? 1 : 0)) / 3 * 15;
    score += completenessScore;

    // Activity score (10% weight) - Placeholder
    final activityScore = 8.0;
    score += activityScore;

    return score.clamp(0, 100);
  }

  List<String> _getMatchReasons(UserProfileEntity profile) {
    final reasons = <String>[];

    final profileInterests = profile.interests ?? [];
    final commonInterests = _userInterests
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

  Future<void> refresh() async {
    await loadTopPicks();
  }
}

/// Provider for TopPicksNotifier
final topPicksProvider =
    StateNotifierProvider<TopPicksNotifier, TopPicksState>((ref) {
  final extendedRepository = ref.watch(discoveryExtendedRepositoryProvider);
  final discoveryRepository = ref.watch(discoveryRepositoryProvider);
  return TopPicksNotifier(extendedRepository, discoveryRepository);
});

/// Top Pick with associated profile
class TopPickWithProfile {
  final TopPickScore score;
  final UserProfileEntity profile;

  const TopPickWithProfile({
    required this.score,
    required this.profile,
  });
}

@freezed
class TopPicksState with _$TopPicksState {
  const factory TopPicksState({
    required List<TopPickWithProfile> topPicks,
    @Default(true) bool isLoading,
    String? error,
  }) = _TopPicksState;

  const factory TopPicksState.initial() = _TopPicksState;

  const factory TopPicksState.calculating() = _TopPicksState;

  const factory TopPicksState.loaded(List<TopPickWithProfile> topPicks) =
      _TopPicksState;

  const factory TopPicksState.error(String message) = _TopPicksState;

  const factory TopPicksState.unauthenticated() = _TopPicksState;
}

// ==================== Premium Status Provider ====================

/// Notifier for Premium Status State
class PremiumStatusNotifier extends StateNotifier<PremiumStatusState> {
  PremiumStatusNotifier() : super(const PremiumStatusState());

  void updateSubscription(SubscriptionTier tier) {
    state = PremiumStatusState(
      isGold:
          tier == SubscriptionTier.gold || tier == SubscriptionTier.platinum,
      isPlatinum: tier == SubscriptionTier.platinum,
      subscriptionTier: tier,
    );
  }
}

/// Provider for PremiumStatusNotifier
final premiumStatusProvider =
    StateNotifierProvider<PremiumStatusNotifier, PremiumStatusState>((ref) {
  return PremiumStatusNotifier();
});

@freezed
class PremiumStatusState with _$PremiumStatusState {
  const factory PremiumStatusState({
    @Default(false) bool isGold,
    @Default(false) bool isPlatinum,
    @Default(SubscriptionTier.free) SubscriptionTier subscriptionTier,
  }) = _PremiumStatusState;
}

/// Subscription tier enum
enum SubscriptionTier {
  free,
  gold,
  platinum,
}
