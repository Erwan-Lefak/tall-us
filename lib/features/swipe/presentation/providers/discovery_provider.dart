import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';

/// Discovery state
class DiscoveryState {
  final List<UserProfileEntity> profiles;
  final int currentIndex;
  final bool isLoading;
  final bool isProcessingSwipe;
  final String? error;
  final MatchEntity? newMatch; // Latest match if any

  const DiscoveryState({
    this.profiles = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.isProcessingSwipe = false,
    this.error,
    this.newMatch,
  });

  bool get hasProfiles => profiles.isNotEmpty;
  bool get hasCurrentProfile => currentIndex < profiles.length;
  UserProfileEntity? get currentProfile =>
      hasCurrentProfile ? profiles[currentIndex] : null;

  DiscoveryState copyWith({
    List<UserProfileEntity>? profiles,
    int? currentIndex,
    bool? isLoading,
    bool? isProcessingSwipe,
    String? error,
    MatchEntity? newMatch,
  }) {
    return DiscoveryState(
      profiles: profiles ?? this.profiles,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isProcessingSwipe: isProcessingSwipe ?? this.isProcessingSwipe,
      error: error,
      newMatch: newMatch,
    );
  }
}

/// Discovery notifier
class DiscoveryNotifier extends StateNotifier<DiscoveryState> {
  DiscoveryNotifier() : super(const DiscoveryState());

  /// Load discovery profiles based on preferences
  Future<void> loadProfiles(DiscoveryPreferencesEntity preferences) async {
    state = state.copyWith(isLoading: true, error: null);

    // TODO: Implement with actual use case
    // For now, simulate loading
    await Future.delayed(const Duration(seconds: 1));

    // Replace with actual implementation
    state = state.copyWith(
      isLoading: false,
      profiles: [], // Will be populated by use case
    );
  }

  /// Load more profiles (pagination)
  Future<void> loadMoreProfiles() async {
    if (state.isLoading) return;

    // TODO: Implement pagination
  }

  /// Handle swipe action
  Future<MatchEntity?> handleSwipe({
    required String targetId,
    required String action,
  }) async {
    if (!state.hasCurrentProfile || state.isProcessingSwipe) {
      return null;
    }

    state = state.copyWith(isProcessingSwipe: true, error: null);

    // TODO: Implement with actual use case
    // For now, simulate swipe
    await Future.delayed(const Duration(milliseconds: 300));

    final match = action == 'like' ? null : null; // Will be populated by use case

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isProcessingSwipe: false,
      newMatch: match,
    );

    // Load more if needed
    if (state.currentIndex >= state.profiles.length - 2) {
      loadMoreProfiles();
    }

    return match;
  }

  /// Clear new match notification
  void clearNewMatch() {
    state = state.copyWith(newMatch: null);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for discovery notifier
final discoveryProvider =
    StateNotifierProvider<DiscoveryNotifier, DiscoveryState>((ref) {
  return DiscoveryNotifier();
});
