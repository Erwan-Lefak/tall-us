import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Repository interface for profile operations
abstract class ProfileRepository {
  /// Get user profile by user ID
  Future<Either<Failure, UserProfileEntity>> getProfile(String userId);

  /// Get current authenticated user's profile
  Future<Either<Failure, UserProfileEntity>> getCurrentUserProfile();

  /// Create new user profile
  Future<Either<Failure, UserProfileEntity>> createProfile(UserProfileEntity profile);

  /// Update user profile
  Future<Either<Failure, UserProfileEntity>> updateProfile(UserProfileEntity profile);

  /// Update specific profile fields
  Future<Either<Failure, UserProfileEntity>> updateProfileFields({
    required String userId,
    String? bio,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? promptAnswer,
    String? promptId,
  });

  /// Upload a profile photo
  Future<Either<Failure, String>> uploadPhoto({
    required String userId,
    required String filePath,
    int? position,
  });

  /// Upload multiple photos
  Future<Either<Failure, List<String>>> uploadMultiplePhotos({
    required String userId,
    required List<String> filePaths,
  });

  /// Delete a photo
  Future<Either<Failure, void>> deletePhoto({
    required String userId,
    required String photoUrl,
  });

  /// Reorder photos
  Future<Either<Failure, void>> reorderPhotos({
    required String userId,
    required List<String> photoUrls,
  });

  /// Get discovery preferences
  Future<Either<Failure, DiscoveryPreferencesEntity>> getDiscoveryPreferences(String userId);

  /// Update discovery preferences
  Future<Either<Failure, DiscoveryPreferencesEntity>> updateDiscoveryPreferences(
      DiscoveryPreferencesEntity preferences);

  /// Delete user profile
  Future<Either<Failure, void>> deleteProfile(String userId);
}
