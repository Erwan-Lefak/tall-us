import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/discovery/domain/usecases/get_profiles_to_discover_usecase.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_state.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Notifier for discovery state
class DiscoveryNotifier extends StateNotifier<DiscoveryState> {
  final GetProfilesToDiscoverUseCase _getProfilesUseCase;

  DiscoveryNotifier(this._getProfilesUseCase)
      : super(const DiscoveryState.initial()) {
    loadProfiles();
  }

  /// Load profiles to discover
  Future<void> loadProfiles() async {
    state = const DiscoveryState.loading();

    // TODO: Get current user ID and preferences from auth/profile providers
    final userId = 'current-user-id'; // Placeholder
    final preferences = DiscoveryPreferencesEntity.defaults(
      userId: userId,
      userAge: 25,
      userHeight: 180,
      userGender: 'homme',
      city: 'Paris',
      country: 'France',
    );

    final result = await _getProfilesUseCase(
      userId: userId,
      minAge: preferences.minAge,
      maxAge: preferences.maxAge,
      minHeightCm: preferences.minHeightCm,
      maxHeightCm: preferences.maxHeightCm,
      preferredGenders: preferences.preferredGenders,
      maxDistanceKm: preferences.maxDistanceKm,
      userCity: preferences.city,
      userCountry: preferences.country,
    );

    result.fold(
      (failure) {
        AppLogger.e('Failed to load profiles: ${failure.message}');
        // Use demo profiles when Appwrite fails
        AppLogger.i('Using demo profiles for testing');
        state = DiscoveryState.loaded(_getDemoProfiles());
      },
      (profiles) {
        if (profiles.isEmpty) {
          AppLogger.i('No more profiles to discover, using demo profiles');
          state = DiscoveryState.loaded(_getDemoProfiles());
        } else {
          AppLogger.i('Loaded ${profiles.length} profiles');
          state = DiscoveryState.loaded(profiles);
        }
      },
    );
  }

  /// Get demo profiles for testing
  List<UserProfileEntity> _getDemoProfiles() {
    return [
      UserProfileEntity(
        id: 'demo1',
        userId: 'demo1',
        displayName: 'Sophie',
        birthday: DateTime.now().subtract(const Duration(days: 9490)), // 26 ans
        heightCm: 178,
        city: 'Paris',
        country: 'France',
        gender: 'femme',
        bio:
            'Passionnée de randonnée et de photographie. Je cherche quelqu\'un qui atteint les sommets avec moi ! 🏔️',
        photoUrls: [
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=600&fit=crop'
        ],
        heightVerified: true,
      ),
      UserProfileEntity(
        id: 'demo2',
        userId: 'demo2',
        displayName: 'Camille',
        birthday: DateTime.now().subtract(const Duration(days: 8760)), // 24 ans
        heightCm: 180,
        city: 'Lyon',
        country: 'France',
        gender: 'femme',
        bio:
            'Architecte, amatrice de vin bio et de bonnes blagues. 1m80 sans talons ! 🍷',
        photoUrls: [
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&h=600&fit=crop'
        ],
        heightVerified: true,
      ),
      UserProfileEntity(
        id: 'demo3',
        userId: 'demo3',
        displayName: 'Julie',
        birthday: DateTime.now().subtract(const Duration(days: 9855)), // 27 ans
        heightCm: 182,
        city: 'Bordeaux',
        country: 'France',
        gender: 'femme',
        bio:
            'Je cherche quelqu\'un qui me comprend... littéralement, vu ma taille ! 😄',
        photoUrls: [
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop'
        ],
        heightVerified: true,
      ),
      UserProfileEntity(
        id: 'demo4',
        userId: 'demo4',
        displayName: 'Marie',
        birthday: DateTime.now().subtract(const Duration(days: 9125)), // 25 ans
        heightCm: 183,
        city: 'Marseille',
        country: 'France',
        gender: 'femme',
        bio:
            'Voyageuse, rêveuse et grande ! À la recherche de quelqu\'un qui voit haut ! ✈️',
        photoUrls: [
          'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=400&h=600&fit=crop'
        ],
        heightVerified: true,
      ),
      UserProfileEntity(
        id: 'demo5',
        userId: 'demo5',
        displayName: 'Isabelle',
        birthday:
            DateTime.now().subtract(const Duration(days: 10220)), // 28 ans
        heightCm: 185,
        city: 'Nantes',
        country: 'France',
        gender: 'femme',
        bio:
            '1m85 et fière ! J\'adore le basketball et la cuisine. Qui pour un match ? 🏀',
        photoUrls: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop'
        ],
        heightVerified: true,
      ),
    ];
  }

  /// Refresh profiles
  Future<void> refresh() async {
    await loadProfiles();
  }

  /// Remove profile from list (when swiped)
  void removeProfile(String profileId) {
    state.whenOrNull(
      loaded: (profiles) {
        final updatedProfiles =
            profiles.where((p) => p.id != profileId).toList();
        if (updatedProfiles.isEmpty) {
          state = const DiscoveryState.noMoreProfiles();
        } else {
          state = DiscoveryState.loaded(updatedProfiles);
        }
      },
    );
  }
}
