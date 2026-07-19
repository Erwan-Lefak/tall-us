import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/profile/data/models/user_profile_model.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';

/// Remote data source for profile operations using Appwrite
class ProfileRemoteDataSource {
  final Databases _databases;
  final Storage _storage;

  ProfileRemoteDataSource({
    required Databases databases,
    required Storage storage,
  })  : _databases = databases,
        _storage = storage;

  /// Get user profile by user ID (queries by userId field, not document ID)
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      AppLogger.i('Fetching profile for user: $userId');

      // Query by userId field since registration creates profiles with ID.unique()
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        queries: [
          Query.equal('userId', [userId]),
          Query.limit(1),
        ],
      );

      if (result.documents.isEmpty) {
        throw AppwriteException(
          'Profile not found for user: $userId',
          404,
          'document_not_found',
        );
      }

      final document = result.documents.first;
      AppLogger.i('Profile fetched successfully (docId: ${document.$id})');
      return UserProfileModel.fromJson(document.data);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch profile', error: e);
      rethrow;
    }
  }

  /// Get current user's profile (from authenticated session)
  Future<UserProfileModel> getCurrentUserProfile() async {
    try {
      // For now, we'll use the account get to get the user ID
      // Then fetch the profile
      // This will be called with user ID from auth state
      throw UnimplementedError('Use getProfile with userId from auth state');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch current user profile', error: e);
      rethrow;
    }
  }

  /// Create new user profile
  Future<UserProfileModel> createProfile(UserProfileModel profile) async {
    try {
      AppLogger.i('Creating profile for user: ${profile.userId}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: profile.userId, // Use userId as document ID
        data: profile.toJson(),
      );

      AppLogger.i('Profile created successfully');
      return UserProfileModel.fromJson(document.data);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create profile', error: e);
      rethrow;
    }
  }

  /// Update user profile (uses document ID, not userId)
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    try {
      AppLogger.i('Updating profile for user: ${profile.userId} (docId: ${profile.id})');

      final document = await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: profile.id,
        data: profile.toJson(),
      );

      AppLogger.i('Profile updated successfully');
      return UserProfileModel.fromJson(document.data);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update profile', error: e);
      rethrow;
    }
  }

  /// Upload a photo to storage from file path (mobile only)
  Future<String> uploadPhoto({
    required String userId,
    required String filePath,
    int? position,
  }) async {
    try {
      AppLogger.i('Uploading photo for user: $userId');

      final file = File(filePath);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      final fileData = await file.readAsBytes();
      return await _uploadPhotoBytes(userId: userId, bytes: fileData, filename: fileName);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload photo', error: e);
      rethrow;
    }
  }

  /// Upload a photo from raw bytes (works on web + mobile)
  Future<String> uploadPhotoBytes({
    required String userId,
    required List<int> bytes,
    required String filename,
  }) async {
    try {
      return await _uploadPhotoBytes(userId: userId, bytes: bytes, filename: filename);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload photo bytes', error: e);
      rethrow;
    }
  }

  /// Internal: upload bytes to Appwrite storage
  Future<String> _uploadPhotoBytes({
    required String userId,
    required List<int> bytes,
    required String filename,
  }) async {
    AppLogger.i('Uploading photo for user: $userId');

    final inputFile = InputFile.fromBytes(
      bytes: bytes,
      filename: filename,
    );

    final result = await _storage.createFile(
      bucketId: AppwriteConfig.photosBucketId,
      fileId: ID.unique(),
      file: inputFile,
      permissions: [
        // Photos must be publicly viewable (img tags use unauthenticated GET).
        Permission.read(Role.any()),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );

    final fileUrl = '${AppwriteConfig.endpoint}/storage/buckets/${AppwriteConfig.photosBucketId}/files/${result.$id}/view?project=${AppwriteConfig.projectId}';

    AppLogger.i('Photo uploaded successfully: $fileUrl');
    return fileUrl;
  }

  /// Upload multiple photos
  Future<List<String>> uploadMultiplePhotos({
    required String userId,
    required List<String> filePaths,
  }) async {
    try {
      AppLogger.i('Uploading ${filePaths.length} photos for user: $userId');

      final urls = <String>[];
      for (var i = 0; i < filePaths.length; i++) {
        final url = await uploadPhoto(
          userId: userId,
          filePath: filePaths[i],
          position: i,
        );
        urls.add(url);
      }

      AppLogger.i('All photos uploaded successfully');
      return urls;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload multiple photos', error: e);
      rethrow;
    }
  }

  /// Delete a photo from storage
  Future<void> deletePhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      AppLogger.i('Deleting photo: $photoUrl');

      // Extract file ID from URL
      final fileId = photoUrl.split('/')[7].split('?')[0];

      await _storage.deleteFile(
        bucketId: AppwriteConfig.photosBucketId,
        fileId: fileId,
      );

      AppLogger.i('Photo deleted successfully');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete photo', error: e);
      rethrow;
    }
  }

  /// Get discovery preferences
  Future<Map<String, dynamic>> getDiscoveryPreferences(String userId) async {
    try {
      AppLogger.i('Fetching discovery preferences for user: $userId');

      final document = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.preferencesCollection,
        documentId: userId,
      );

      AppLogger.i('Discovery preferences fetched successfully');
      return document.data;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch discovery preferences', error: e);
      rethrow;
    }
  }

  /// Update discovery preferences
  Future<Map<String, dynamic>> updateDiscoveryPreferences(
      DiscoveryPreferencesEntity preferences) async {
    try {
      AppLogger.i('Updating discovery preferences for user: ${preferences.userId}');

      final data = {
        'userId': preferences.userId,
        'minAge': preferences.minAge,
        'maxAge': preferences.maxAge,
        'maxDistanceKm': preferences.maxDistanceKm,
        'preferredGenders': preferences.preferredGenders,
        'minHeightCm': preferences.minHeightCm,
        'maxHeightCm': preferences.maxHeightCm,
        'city': preferences.city,
        'country': preferences.country,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final document = await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.preferencesCollection,
        documentId: preferences.userId,
        data: data,
      );

      AppLogger.i('Discovery preferences updated successfully');
      return document.data;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update discovery preferences', error: e);
      rethrow;
    }
  }

  /// Create discovery preferences (first-time save). Uses userId as doc id.
  Future<Map<String, dynamic>> createDiscoveryPreferences(
      DiscoveryPreferencesEntity preferences) async {
    try {
      AppLogger.i(
          'Creating discovery preferences for user: ${preferences.userId}');

      final data = {
        'userId': preferences.userId,
        'minAge': preferences.minAge,
        'maxAge': preferences.maxAge,
        'maxDistanceKm': preferences.maxDistanceKm,
        'preferredGenders': preferences.preferredGenders,
        'minHeightCm': preferences.minHeightCm,
        'maxHeightCm': preferences.maxHeightCm,
        'city': preferences.city,
        'country': preferences.country,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.preferencesCollection,
        documentId: preferences.userId,
        data: data,
      );

      AppLogger.i('Discovery preferences created successfully');
      return document.data;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create discovery preferences', error: e);
      rethrow;
    }
  }

  /// Create-or-update discovery preferences (robust first-time save).
  Future<void> saveDiscoveryPreferences(
      DiscoveryPreferencesEntity preferences) async {
    try {
      await createDiscoveryPreferences(preferences);
    } catch (_) {
      // Document already exists -> fall back to update.
      await updateDiscoveryPreferences(preferences);
    }
  }

  /// Delete user profile
  Future<void> deleteProfile(String userId) async {
    try {
      AppLogger.i('Deleting profile for user: $userId');

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: userId,
      );

      AppLogger.i('Profile deleted successfully');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete profile', error: e);
      rethrow;
    }
  }
}

/// Provider for ProfileRemoteDataSource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final databases = ref.watch(databasesProvider);
  final storage = ref.watch(storageProvider);
  return ProfileRemoteDataSource(databases: databases, storage: storage);
});
