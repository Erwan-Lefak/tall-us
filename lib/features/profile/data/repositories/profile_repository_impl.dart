import 'package:dartz/dartz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tall_us/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:tall_us/features/profile/data/models/user_profile_model.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthRemoteDataSource authRemoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile(String userId) async {
    try {
      AppLogger.i('Getting profile for user: $userId');
      final profile = await remoteDataSource.getProfile(userId);
      return Right(profile.toEntity());
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get profile',
        code: e.code?.toString() ?? 'GET_PROFILE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting profile', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getCurrentUserProfile() async {
    try {
      AppLogger.i('Getting current user profile');
      final user = await authRemoteDataSource.getCurrentUser();
      if (user == null) {
        return const Left(ServerFailure(
          message: 'User not authenticated',
          code: 'NOT_AUTHENTICATED',
        ));
      }
      final profile = await remoteDataSource.getProfile(user.id);
      return Right(profile.toEntity());
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get current user profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get current user profile',
        code: e.code?.toString() ?? 'GET_CURRENT_PROFILE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting current user profile', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> createProfile(
      UserProfileEntity profile) async {
    try {
      AppLogger.i('Creating profile for user: ${profile.userId}');
      final profileModel = UserProfileModel.fromEntity(profile);
      final createdProfile = await remoteDataSource.createProfile(profileModel);
      return Right(createdProfile.toEntity());
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to create profile',
        code: e.code?.toString() ?? 'CREATE_PROFILE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error creating profile', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
      UserProfileEntity profile) async {
    try {
      AppLogger.i('Updating profile for user: ${profile.userId}');
      final profileModel = UserProfileModel.fromEntity(profile);
      final updatedProfile = await remoteDataSource.updateProfile(profileModel);
      return Right(updatedProfile.toEntity());
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to update profile',
        code: e.code?.toString() ?? 'UPDATE_PROFILE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error updating profile', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfileFields({
    required String userId,
    String? bio,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? promptAnswer,
    String? promptId,
  }) async {
    try {
      AppLogger.i('Updating profile fields for user: $userId');

      // First, get the current profile
      final currentProfileResult = await getProfile(userId);

      return await currentProfileResult.fold(
        (failure) => Left(failure),
        (currentProfile) async {
          // Update with new values
          final updatedProfile = currentProfile.copyWith(
            bio: bio ?? currentProfile.bio,
            city: city ?? currentProfile.city,
            country: country ?? currentProfile.country,
            photoUrls: photoUrls ?? currentProfile.photoUrls,
            promptAnswer: promptAnswer ?? currentProfile.promptAnswer,
            promptId: promptId ?? currentProfile.promptId,
          );

          return await updateProfile(updatedProfile);
        },
      );
    } catch (e) {
      AppLogger.e('Unexpected error updating profile fields', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto({
    required String userId,
    required String filePath,
    int? position,
  }) async {
    try {
      AppLogger.i('Uploading photo for user: $userId');
      final url = await remoteDataSource.uploadPhoto(
        userId: userId,
        filePath: filePath,
        position: position,
      );
      return Right(url);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload photo', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to upload photo',
        code: e.code?.toString() ?? 'UPLOAD_PHOTO_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error uploading photo', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadMultiplePhotos({
    required String userId,
    required List<String> filePaths,
  }) async {
    try {
      AppLogger.i('Uploading ${filePaths.length} photos for user: $userId');
      final urls = await remoteDataSource.uploadMultiplePhotos(
        userId: userId,
        filePaths: filePaths,
      );
      return Right(urls);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload multiple photos', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to upload photos',
        code: e.code?.toString() ?? 'UPLOAD_PHOTOS_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error uploading photos', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      AppLogger.i('Deleting photo for user: $userId');
      await remoteDataSource.deletePhoto(
        userId: userId,
        photoUrl: photoUrl,
      );
      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete photo', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to delete photo',
        code: e.code?.toString() ?? 'DELETE_PHOTO_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error deleting photo', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reorderPhotos({
    required String userId,
    required List<String> photoUrls,
  }) async {
    try {
      AppLogger.i('Reordering photos for user: $userId');
      final profileResult = await getProfile(userId);

      return await profileResult.fold(
        (failure) => Left(failure),
        (profile) async {
          final updatedProfile = profile.copyWith(photoUrls: photoUrls);
          final result = await updateProfile(updatedProfile);
          return result.fold(
            (failure) => Left(failure),
            (_) => const Right(null),
          );
        },
      );
    } catch (e) {
      AppLogger.e('Unexpected error reordering photos', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DiscoveryPreferencesEntity>> getDiscoveryPreferences(
      String userId) async {
    try {
      AppLogger.i('Getting discovery preferences for user: $userId');
      final data = await remoteDataSource.getDiscoveryPreferences(userId);

      final preferences = DiscoveryPreferencesEntity(
        userId: data['userId'] ?? userId,
        minAge: data['minAge'] ?? 18,
        maxAge: data['maxAge'] ?? 100,
        maxDistanceKm: data['maxDistanceKm'] ?? 50,
        preferredGenders: data['preferredGenders'] != null
            ? List<String>.from(data['preferredGenders'])
            : [],
        minHeightCm: data['minHeightCm'] ?? 140,
        maxHeightCm: data['maxHeightCm'] ?? 220,
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        lastUpdated: data['lastUpdated'] != null
            ? DateTime.parse(data['lastUpdated'])
            : null,
      );

      return Right(preferences);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get discovery preferences', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get discovery preferences',
        code: e.code?.toString() ?? 'GET_PREFERENCES_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting discovery preferences', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DiscoveryPreferencesEntity>> updateDiscoveryPreferences(
      DiscoveryPreferencesEntity preferences) async {
    try {
      AppLogger.i('Updating discovery preferences for user: ${preferences.userId}');
      await remoteDataSource.updateDiscoveryPreferences(preferences);
      return Right(preferences);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update discovery preferences', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to update discovery preferences',
        code: e.code?.toString() ?? 'UPDATE_PREFERENCES_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error updating discovery preferences', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String userId) async {
    try {
      AppLogger.i('Deleting profile for user: $userId');
      await remoteDataSource.deleteProfile(userId);
      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to delete profile',
        code: e.code?.toString() ?? 'DELETE_PROFILE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error deleting profile', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
