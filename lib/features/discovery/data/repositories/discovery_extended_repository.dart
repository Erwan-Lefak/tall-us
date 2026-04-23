import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Extended Discovery Repository Interface
abstract class DiscoveryExtendedRepository {
  // ==================== Likes ====================

  /// Record a like
  Future<LikeRecord> recordLike(LikeRecord like);

  /// Get users who liked the current user
  Future<List<UserProfileEntity>> getWhoLikedMe(String userId, {int limit});

  /// Check if user has been seen in "who likes you"
  Future<void> markLikeAsSeen(String likeId);

  // ==================== Top Picks ====================

  /// Calculate and get top picks for a user
  Future<List<TopPickScore>> getTopPicks(String userId, {int limit});

  /// Save top pick score
  Future<void> saveTopPickScore(TopPickScore score);

  // ==================== Photo Interactions ====================

  /// Like a photo
  Future<void> likePhoto(String photoId, String userId);

  /// Unlike a photo
  Future<void> unlikePhoto(String photoId, String userId);

  /// Update photo view count
  Future<void> incrementPhotoViews(String photoId);

  /// Update photo match count
  Future<void> incrementPhotoMatches(String photoId);

  /// Get photo metadata
  Future<PhotoMetadata> getPhotoMetadata(String photoId);

  /// Update photo smart score
  Future<void> updatePhotoSmartScore(String photoId, double newScore);
}

/// Appwrite implementation of Extended Discovery Repository
class DiscoveryExtendedRepositoryImpl implements DiscoveryExtendedRepository {
  final Databases _databases;

  DiscoveryExtendedRepositoryImpl({
    required Databases databases,
  }) : _databases = databases;

  @override
  Future<LikeRecord> recordLike(LikeRecord like) async {
    try {
      AppLogger.i('Recording like: ${like.fromUserId} -> ${like.toUserId}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.likesCollection,
        documentId: like.id,
        data: {
          'fromUserId': like.fromUserId,
          'toUserId': like.toUserId,
          'likedAt': like.likedAt.toIso8601String(),
          'isSeen': like.isSeen,
        },
      );

      AppLogger.i('Like recorded successfully: ${document.$id}');
      return like.copyWith(id: document.$id);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to record like', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<UserProfileEntity>> getWhoLikedMe(String userId,
      {int limit = 20}) async {
    try {
      AppLogger.i('Fetching users who liked $userId (limit: $limit)');

      // Get like records where toUserId == current userId
      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.likesCollection,
        queries: [
          Query.equal('toUserId', userId),
          Query.orderDesc('likedAt'),
          Query.limit(limit),
        ],
      );

      // Extract fromUserIds and fetch their profiles
      final fromUserIds = documents.documents
          .map((doc) => doc.data['fromUserId'] as String)
          .toSet()
          .toList();

      if (fromUserIds.isEmpty) {
        AppLogger.i('No users found who liked $userId');
        return [];
      }

      // Fetch profiles
      final profilesDocuments = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        queries: fromUserIds.map((id) => Query.equal('userId', id)).toList(),
      );

      final profiles = profilesDocuments.documents.map((doc) {
        final data = doc.data;
        return UserProfileEntity(
          id: doc.$id,
          userId: data['userId'] ?? '',
          displayName: data['displayName'] ?? '',
          gender: data['gender'] ?? 'unknown',
          heightCm: data['heightCm'] ?? 170,
          birthday: data['birthday'] != null
              ? DateTime.parse(data['birthday'])
              : DateTime.now(),
          city: data['city'] ?? '',
          country: data['countryCode'] ?? '',
          photoUrls: List<String>.from(data['photoUrls'] ?? []),
          bio: data['bio'],
        );
      }).toList();

      AppLogger.i('Retrieved ${profiles.length} users who liked $userId');
      return profiles;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch users who liked me',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> markLikeAsSeen(String likeId) async {
    try {
      AppLogger.i('Marking like $likeId as seen');

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.likesCollection,
        documentId: likeId,
        data: {'isSeen': true},
      );

      AppLogger.i('Like marked as seen');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to mark like as seen',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TopPickScore>> getTopPicks(String userId,
      {int limit = 10}) async {
    try {
      AppLogger.i('Calculating top picks for user $userId');

      // Get cached scores first
      final cachedDocuments = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.topPicksCollection,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('compatibilityScore'),
          Query.limit(limit),
        ],
      );

      if (cachedDocuments.documents.isNotEmpty) {
        final scores = cachedDocuments.documents.map((doc) {
          final data = doc.data;
          return TopPickScore(
            profileId: data['profileId'] ?? '',
            compatibilityScore: (data['compatibilityScore'] as num).toDouble(),
            matchReasons: List<String>.from(data['matchReasons'] ?? []),
            calculatedAt: DateTime.parse(data['calculatedAt']),
          );
        }).toList();

        // Only use cached if less than 24 hours old
        if (scores.isNotEmpty) {
          final newestCalculatedAt = scores
              .map((s) => s.calculatedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);

          if (DateTime.now().difference(newestCalculatedAt).inHours < 24) {
            AppLogger.i('Using cached top picks scores');
            return scores;
          }
        }
      }

      // Cache miss or expired - return empty (calculation should be done server-side)
      AppLogger.i('No cached top picks scores found');
      return [];
    } catch (e, stackTrace) {
      AppLogger.e('Failed to get top picks', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> saveTopPickScore(TopPickScore score) async {
    try {
      AppLogger.i('Saving top pick score for ${score.profileId}');

      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.topPicksCollection,
        documentId:
            '${score.profileId}_${score.calculatedAt.millisecondsSinceEpoch}',
        data: {
          'userId': 'current_user_id', // Should be passed in
          'profileId': score.profileId,
          'compatibilityScore': score.compatibilityScore,
          'matchReasons': score.matchReasons,
          'calculatedAt': score.calculatedAt.toIso8601String(),
        },
      );

      AppLogger.i('Top pick score saved successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to save top pick score',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> likePhoto(String photoId, String userId) async {
    try {
      AppLogger.i('User $userId liking photo $photoId');

      // Get current photo metadata
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
      );

      final likeCount = (doc.data['likeCount'] as num? ?? 0).toInt() + 1;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
        data: {'likeCount': likeCount},
      );

      AppLogger.i('Photo liked successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to like photo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> unlikePhoto(String photoId, String userId) async {
    try {
      AppLogger.i('User $userId unliking photo $photoId');

      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
      );

      final likeCount = ((doc.data['likeCount'] as num? ?? 1).toInt() - 1)
          .clamp(0, double.infinity)
          .toInt();

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
        data: {'likeCount': likeCount},
      );

      AppLogger.i('Photo unliked successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to unlike photo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> incrementPhotoViews(String photoId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
      );

      final viewCount = (doc.data['viewCount'] as num? ?? 0).toInt() + 1;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
        data: {'viewCount': viewCount},
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to increment photo views',
          error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> incrementPhotoMatches(String photoId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
      );

      final matchCount = (doc.data['matchCount'] as num? ?? 0).toInt() + 1;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
        data: {'matchCount': matchCount},
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to increment photo matches',
          error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<PhotoMetadata> getPhotoMetadata(String photoId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
      );

      final data = doc.data;
      return PhotoMetadata(
        photoId: doc.$id,
        url: data['url'] ?? '',
        caption: data['caption'],
        displayOrder: data['displayOrder'] ?? 0,
        likeCount: (data['likeCount'] as num? ?? 0).toInt(),
        viewCount: (data['viewCount'] as num? ?? 0).toInt(),
        matchCount: (data['matchCount'] as num? ?? 0).toInt(),
        smartScore: (data['smartScore'] as num? ?? 50.0).toDouble(),
        lastScoreUpdate: data['lastScoreUpdate'] != null
            ? DateTime.parse(data['lastScoreUpdate'])
            : null,
        isVerified: data['isVerified'],
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to get photo metadata',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updatePhotoSmartScore(String photoId, double newScore) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.photosCollection,
        documentId: photoId,
        data: {
          'smartScore': newScore,
          'lastScoreUpdate': DateTime.now().toIso8601String(),
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update photo smart score',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
