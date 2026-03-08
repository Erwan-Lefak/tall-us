import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/usecases/get_discovery_preferences_usecase.dart';
import 'package:tall_us/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:tall_us/features/profile/domain/usecases/update_discovery_preferences_usecase.dart';
import 'package:tall_us/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:tall_us/features/profile/domain/usecases/upload_photo_usecase.dart';

/// Profile state
class ProfileState {
  final UserProfileEntity? profile;
  final DiscoveryPreferencesEntity? preferences;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.profile,
    this.preferences,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    UserProfileEntity? profile,
    DiscoveryPreferencesEntity? preferences,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Profile notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadPhotoUseCase _uploadPhotoUseCase;
  final GetDiscoveryPreferencesUseCase _getDiscoveryPreferencesUseCase;
  final UpdateDiscoveryPreferencesUseCase _updateDiscoveryPreferencesUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UploadPhotoUseCase uploadPhotoUseCase,
    required GetDiscoveryPreferencesUseCase getDiscoveryPreferencesUseCase,
    required UpdateDiscoveryPreferencesUseCase updateDiscoveryPreferencesUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _uploadPhotoUseCase = uploadPhotoUseCase,
        _getDiscoveryPreferencesUseCase = getDiscoveryPreferencesUseCase,
        _updateDiscoveryPreferencesUseCase = updateDiscoveryPreferencesUseCase,
        super(const ProfileState());

  /// Load current user's profile
  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getProfileUseCase(userId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          profile: profile,
          isLoading: false,
        );
      },
    );
  }

  /// Update profile
  Future<void> updateProfile(UserProfileEntity profile) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _updateProfileUseCase(profile);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (updatedProfile) {
        state = state.copyWith(
          profile: updatedProfile,
          isLoading: false,
        );
      },
    );
  }

  /// Update specific profile fields
  Future<void> updateProfileFields({
    String? bio,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? promptAnswer,
    String? promptId,
  }) async {
    if (state.profile == null) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _updateProfileUseCase.updateFields(
      userId: state.profile!.userId,
      bio: bio,
      city: city,
      country: country,
      photoUrls: photoUrls,
      promptAnswer: promptAnswer,
      promptId: promptId,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (updatedProfile) {
        state = state.copyWith(
          profile: updatedProfile,
          isLoading: false,
        );
      },
    );
  }

  /// Upload a photo
  Future<void> uploadPhoto(String filePath) async {
    if (state.profile == null) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _uploadPhotoUseCase(
      userId: state.profile!.userId,
      filePath: filePath,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (photoUrl) {
        final updatedPhotos = [...state.profile!.photoUrls, photoUrl];
        updateProfileFields(photoUrls: updatedPhotos);
      },
    );
  }

  /// Delete a photo
  Future<void> deletePhoto(String photoUrl) async {
    if (state.profile == null) return;

    final updatedPhotos = state.profile!.photoUrls.where((url) => url != photoUrl).toList();
    await updateProfileFields(photoUrls: updatedPhotos);
  }

  /// Load discovery preferences
  Future<void> loadDiscoveryPreferences(String userId) async {
    final result = await _getDiscoveryPreferencesUseCase(userId);

    result.fold(
      (failure) {
        // Don't show error, preferences might not exist yet
        state = state.copyWith(preferences: null);
      },
      (preferences) {
        state = state.copyWith(preferences: preferences);
      },
    );
  }

  /// Update discovery preferences
  Future<void> updateDiscoveryPreferences(DiscoveryPreferencesEntity preferences) async {
    final result = await _updateDiscoveryPreferencesUseCase(preferences);

    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (updatedPreferences) {
        state = state.copyWith(preferences: updatedPreferences);
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for profile use cases
final profileUseCasesProvider = Provider((ref) {
  // This will be provided by dependency injection
  // For now, returning null - will be implemented with DI
  throw UnimplementedError('Will be provided by DI container');
});

/// Provider for profile notifier
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  // This will be provided by dependency injection
  // For now, returning null - will be implemented with DI
  throw UnimplementedError('Will be provided by DI container');
});

/// Provider for current user's profile
final currentUserProfileProvider = Provider<ProfileState>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState;
});
