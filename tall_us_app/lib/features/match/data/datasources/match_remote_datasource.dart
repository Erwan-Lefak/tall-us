import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';

/// Remote data source for match operations using Appwrite
class MatchRemoteDataSource {
  final Databases _databases;

  MatchRemoteDataSource({
    required Databases databases,
  }) : _databases = databases;

  /// Create a match between two users
  Future<MatchEntity> createMatch({
    required String user1Id,
    required String user2Id,
  }) async {
    try {
      AppLogger.i('Creating match: $user1Id + $user2Id');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        documentId: ID.unique(),
        data: {
          'user1Id': user1Id,
          'user2Id': user2Id,
          'createdAt': DateTime.now().toIso8601String(),
          'isRead': false,
        },
        permissions: [
          Permission.read(Role.user(user1Id)),
          Permission.read(Role.user(user2Id)),
          Permission.update(Role.user(user1Id)),
          Permission.update(Role.user(user2Id)),
        ],
      );

      AppLogger.i('Match created successfully: ${document.$id}');

      return MatchEntity(
        id: document.$id,
        user1Id: user1Id,
        user2Id: user2Id,
        createdAt: DateTime.parse(document.$createdAt),
        isRead: false,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create match', error: e);
      rethrow;
    }
  }

  /// Check if a match exists between two users
  Future<bool> matchExists(String user1Id, String user2Id) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        queries: [
          Query.or([
            Query.and([
              Query.equal('user1Id', user1Id),
              Query.equal('user2Id', user2Id),
            ]),
            Query.and([
              Query.equal('user1Id', user2Id),
              Query.equal('user2Id', user1Id),
            ]),
          ]),
          Query.limit(1),
        ],
      );

      return result.documents.isNotEmpty;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to check match existence', error: e);
      return false;
    }
  }

  /// Get all matches for a user
  Future<List<Map<String, dynamic>>> getMatches(String userId) async {
    try {
      AppLogger.i('Fetching matches for user: $userId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        queries: [
          Query.equal('user1Id', userId),
          Query.or([
            Query.equal('user1Id', userId),
            Query.equal('user2Id', userId),
          ]),
          Query.orderDesc('createdAt'),
        ],
      );

      AppLogger.i('Found ${documents.documents.length} matches');
      return documents.documents.map((doc) => doc.data).toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch matches', error: e);
      rethrow;
    }
  }

  /// Get match with profile information
  Future<Map<String, dynamic>> getMatchWithProfile(
    String matchId,
    String currentUserId,
  ) async {
    try {
      AppLogger.i('Fetching match with profile: $matchId');

      // Get match document
      final matchDoc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        documentId: matchId,
      );

      // Get other user's ID
      final otherUserId = matchDoc.data['user1Id'] == currentUserId
          ? matchDoc.data['user2Id']
          : matchDoc.data['user1Id'];

      // Get other user's profile
      final profileDoc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: otherUserId,
      );

      AppLogger.i('Match with profile fetched successfully');

      return {
        'match': matchDoc.data,
        'profile': profileDoc.data,
        'otherUserId': otherUserId,
      };
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch match with profile', error: e);
      rethrow;
    }
  }

  /// Mark match as read
  Future<void> markAsRead(String matchId) async {
    try {
      AppLogger.i('Marking match as read: $matchId');

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        documentId: matchId,
        data: {'isRead': true},
      );

      AppLogger.i('Match marked as read');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to mark match as read', error: e);
      rethrow;
    }
  }

  /// Delete match (unmatch)
  Future<void> deleteMatch(String matchId) async {
    try {
      AppLogger.i('Deleting match: $matchId');

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.matchesCollection,
        documentId: matchId,
      );

      AppLogger.i('Match deleted successfully');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete match', error: e);
      rethrow;
    }
  }
}
