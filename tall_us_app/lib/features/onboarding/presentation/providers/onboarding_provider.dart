import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';

/// In-progress onboarding data (profile completion + matching preferences).
class OnboardingData {
  final String userId;
  final String displayName;
  final String gender;
  final int heightCm;
  final String city;
  final String country;
  final String bio;
  final List<String> photoUrls;
  final List<String> hobbies;
  final String lookingFor; // 'shoot' | 'poster' | 'dunk' | 'relationship'
  final List<String> preferredGenders;
  final int minAge;
  final int maxAge;
  final int minHeightCm;
  final int maxHeightCm;
  final int maxDistanceKm;
  final bool isSubmitting;
  final String? error;

  const OnboardingData({
    required this.userId,
    required this.displayName,
    required this.gender,
    required this.heightCm,
    required this.city,
    required this.country,
    this.bio = '',
    this.photoUrls = const [],
    this.hobbies = const [],
    this.lookingFor = 'shoot',
    this.preferredGenders = const [],
    this.minAge = 21,
    this.maxAge = 40,
    this.minHeightCm = 160,
    this.maxHeightCm = 210,
    this.maxDistanceKm = 50,
    this.isSubmitting = false,
    this.error,
  });

  OnboardingData copyWith({
    String? bio,
    List<String>? photoUrls,
    List<String>? hobbies,
    String? lookingFor,
    List<String>? preferredGenders,
    int? minAge,
    int? maxAge,
    int? minHeightCm,
    int? maxHeightCm,
    int? maxDistanceKm,
    String? city,
    bool? isSubmitting,
    String? error,
  }) {
    return OnboardingData(
      userId: userId,
      displayName: displayName,
      gender: gender,
      heightCm: heightCm,
      city: city ?? this.city,
      country: country,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      hobbies: hobbies ?? this.hobbies,
      lookingFor: lookingFor ?? this.lookingFor,
      preferredGenders: preferredGenders ?? this.preferredGenders,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minHeightCm: minHeightCm ?? this.minHeightCm,
      maxHeightCm: maxHeightCm ?? this.maxHeightCm,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingData?> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(null);

  /// Initialize from the current user's profile + sensible defaults.
  void init(UserProfileEntity profile) {
    state = OnboardingData(
      userId: profile.userId,
      displayName: profile.displayName,
      gender: profile.gender,
      heightCm: profile.heightCm,
      city: profile.city,
      country: profile.country,
      bio: profile.bio ?? '',
      photoUrls: List<String>.from(profile.photoUrls),
      hobbies: List<String>.from(profile.hobbies),
      lookingFor: _normalizeLookingFor(profile.lookingFor),
      // Default preferred gender = opposite of the user's gender.
      preferredGenders:
          profile.gender == 'female' ? ['male'] : ['female'],
      minAge: 21,
      maxAge: 45,
      minHeightCm: 160,
      maxHeightCm: 210,
      maxDistanceKm: 50,
    );
  }

  String _normalizeLookingFor(String lf) {
    final v = lf.toLowerCase();
    if (v == 'shoot' || v == 'poster' || v == 'dunk') return v;
    return 'shoot';
  }

  void setBio(String bio) => state = state?.copyWith(bio: bio);
  void setCity(String city) => state = state?.copyWith(city: city);
  void setLookingFor(String lf) => state = state?.copyWith(lookingFor: lf);

  void addPhoto(String url) {
    if (state == null || state!.photoUrls.contains(url)) return;
    state = state!.copyWith(photoUrls: [...state!.photoUrls, url]);
  }

  void removePhoto(String url) {
    if (state == null) return;
    state = state!.copyWith(
        photoUrls: state!.photoUrls.where((p) => p != url).toList());
  }

  void toggleHobby(String hobby) {
    if (state == null) return;
    final list = List<String>.from(state!.hobbies);
    if (list.contains(hobby)) {
      list.remove(hobby);
    } else {
      list.add(hobby);
    }
    state = state!.copyWith(hobbies: list);
  }

  void togglePreferredGender(String gender) {
    if (state == null) return;
    final list = List<String>.from(state!.preferredGenders);
    if (list.contains(gender)) {
      list.remove(gender);
    } else {
      list.add(gender);
    }
    state = state!.copyWith(preferredGenders: list);
  }

  void setAgeRange(int min, int max) =>
      state = state?.copyWith(minAge: min, maxAge: max);
  void setHeightRange(int min, int max) =>
      state = state?.copyWith(minHeightCm: min, maxHeightCm: max);
  void setDistance(int km) => state = state?.copyWith(maxDistanceKm: km);

  /// Persist everything and mark onboarding complete. Returns true on success.
  Future<bool> submit() async {
    if (state == null) return false;
    final data = state!;
    state = data.copyWith(isSubmitting: true, error: null);

    try {
      final profileState = _ref.read(profileProvider);
      final base = profileState.profile;
      if (base == null) {
        state = data.copyWith(
            isSubmitting: false, error: 'Profil introuvable');
        return false;
      }

      // 1. Update the profile (bio, photos, hobbies, lookingFor, completed).
      final updated = base.copyWith(
        bio: data.bio.trim(),
        photoUrls: data.photoUrls,
        hobbies: data.hobbies,
        lookingFor: data.lookingFor,
        city: data.city,
        onboardingCompleted: true,
      );
      await _ref.read(profileProvider.notifier).updateProfile(updated);

      // 2. Create-or-update matching preferences.
      final prefs = DiscoveryPreferencesEntity(
        userId: data.userId,
        minAge: data.minAge,
        maxAge: data.maxAge,
        minHeightCm: data.minHeightCm,
        maxHeightCm: data.maxHeightCm,
        preferredGenders: data.preferredGenders,
        maxDistanceKm: data.maxDistanceKm,
        city: data.city,
        country: data.country,
      );
      await _ref
          .read(profileRemoteDataSourceProvider)
          .saveDiscoveryPreferences(prefs);

      state = data.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      AppLogger.e('Onboarding submit failed', error: e);
      state = data.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingData?>((ref) {
  return OnboardingNotifier(ref);
});

/// Curated hobby list for the hobbies step.
const onboardingHobbies = [
  'Basket 🏀', 'Running', 'Football', 'Fitness', 'Natation', 'Tennis',
  'Musique', 'Cinéma', 'Lecture', 'Gaming', 'Voyage', 'Cuisine',
  'Photographie', 'Mode', 'Randonnée', 'Tech', 'Art', 'Danse',
  'Ski', 'Yoga',
];
