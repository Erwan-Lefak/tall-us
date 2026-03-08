import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/profile/data/models/user_profile_model.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Remote data source for swipe operations using Appwrite
class SwipeRemoteDataSource {
  final Databases _databases;

  SwipeRemoteDataSource({
    required Databases databases,
  }) : _databases = databases;

  /// Create a swipe record
  Future<Map<String, dynamic>> createSwipe({
    required String swiperId,
    required String targetId,
    required String action,
  }) async {
    try {
      AppLogger.i('Creating swipe: $swiperId -> $targetId ($action)');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        documentId: ID.unique(),
        data: {
          'fromUserId': swiperId, // Adapter pour la collection existante
          'toUserId': targetId,   // Adapter pour la collection existante
          'action': action,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      AppLogger.i('Swipe created successfully');
      return document.data;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create swipe', error: e);
      rethrow;
    }
  }

  /// Get profiles for discovery (with filters applied)
  Future<List<UserProfileEntity>> getDiscoveryProfiles({
    required String userId,
    required int minAge,
    required int maxAge,
    required int maxDistance,
    String? preferredGender,
    int? minHeight,
    int? maxHeight,
    bool onlyShowVerified = false,
    int limit = 20,
  }) async {
    try {
      AppLogger.i('Fetching discovery profiles for user: $userId');

      // Query profiles collection with filters
      // Note: This is a simplified query. In production, you'd use:
      // - Appwrite Functions for complex geo-queries
      // - Proper pagination
      // - Caching for performance

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        queries: [
          Query.notEqual('userId', userId), // Exclude current user
          if (preferredGender != null) Query.equal('gender', preferredGender),
          Query.limit(limit),
        ],
      );

      // Convert to entities and apply additional filters
      final profiles = <UserProfileEntity>[];
      for (var doc in documents.documents) {
        final profile = UserProfileModel.fromJson(doc.data).toEntity();

        // Apply filters that can't be done in Appwrite query
        if (_matchesFilters(profile, minAge, maxAge, minHeight, maxHeight, onlyShowVerified)) {
          profiles.add(profile);
        }
      }

      AppLogger.i('Found ${profiles.length} discovery profiles');
      return profiles;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch discovery profiles', error: e);
      rethrow;
    }
  }

  /// Check if user has already swiped on target
  Future<bool> hasSwiped({
    required String swiperId,
    required String targetId,
  }) async {
    try {
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        queries: [
          Query.equal('fromUserId', swiperId),
          Query.equal('toUserId', targetId),
          Query.limit(1),
        ],
      );

      return documents.documents.isNotEmpty;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to check swipe status', error: e);
      rethrow;
    }
  }

  /// Get user's recent swipes (for rewind functionality)
  Future<List<Map<String, dynamic>>> getRecentSwipes(String userId, {int limit = 10}) async {
    try {
      AppLogger.i('Fetching recent swipes for user: $userId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        queries: [
          Query.equal('fromUserId', userId),
          Query.orderDesc('createdAt'),
          Query.limit(limit),
        ],
      );

      AppLogger.i('Found ${documents.documents.length} recent swipes');
      return documents.documents.map((doc) => doc.data).toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch recent swipes', error: e);
      rethrow;
    }
  }

  /// Delete a swipe (for rewind)
  Future<void> deleteSwipe(String swipeId) async {
    try {
      AppLogger.i('Deleting swipe: $swipeId');

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        documentId: swipeId,
      );

      AppLogger.i('Swipe deleted successfully');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete swipe', error: e);
      rethrow;
    }
  }

  /// Apply client-side filters to profile
  bool _matchesFilters(
    UserProfileEntity profile,
    int minAge,
    int maxAge,
    int? minHeight,
    int? maxHeight,
    bool onlyShowVerified,
  ) {
    // Age filter
    final age = profile.calculateAge();
    if (age < minAge || age > maxAge) return false;

    // Height filter
    if (minHeight != null && profile.heightCm < minHeight) return false;
    if (maxHeight != null && profile.heightCm > maxHeight) return false;

    // Verification filter
    if (onlyShowVerified && !profile.heightVerified) return false;

    // Must have photos
    if (profile.photoUrls.isEmpty) return false;

    return true;
  }
}
