import 'package:dartz/dartz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/match/data/datasources/match_remote_datasource.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/swipe/data/datasources/swipe_remote_datasource.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/domain/repositories/swipe_repository.dart';

/// Implementation of SwipeRepository
class SwipeRepositoryImpl implements SwipeRepository {
  final SwipeRemoteDataSource remoteDataSource;
  final Databases databases;
  final MatchRemoteDataSource matchDataSource;

  SwipeRepositoryImpl({
    required this.remoteDataSource,
    required this.databases,
    required this.matchDataSource,
  });

  @override
  Future<Either<Failure, MatchEntity?>> swipe({
    required String swiperId,
    required String targetId,
    required SwipeAction action,
  }) async {
    try {
      AppLogger.i('Processing swipe: $swiperId -> $targetId ($action)');

      // Create the swipe record
      await remoteDataSource.createSwipe(
        swiperId: swiperId,
        targetId: targetId,
        action: action.name,
      );

      // If it's a pass, no match possible
      if (action == SwipeAction.pass) {
        return const Right(null);
      }

      // Check if there's a mutual like/super like
      final match = await _checkForMatch(
        user1Id: swiperId,
        user2Id: targetId,
      );

      if (match != null && action == SwipeAction.superLike) {
        // Update match to indicate it was from a super like
        AppLogger.i('Super Like match created!');
      }

      return Right(match);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to process swipe', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to swipe',
        code: e.code?.toString() ?? 'SWIPE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error processing swipe', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProfileEntity>>> getDiscoveryProfiles({
    required String userId,
    required DiscoveryPreferencesEntity preferences,
    int limit = 20,
  }) async {
    try {
      AppLogger.i('Getting discovery profiles for user: $userId');

      final profiles = await remoteDataSource.getDiscoveryProfiles(
        userId: userId,
        minAge: preferences.minAge,
        maxAge: preferences.maxAge,
        maxDistance: preferences.maxDistanceKm,
        preferredGender: preferences.preferredGenders.isNotEmpty
            ? preferences.preferredGenders.first
            : null,
        minHeight: preferences.minHeightCm,
        maxHeight: preferences.maxHeightCm,
        onlyShowVerified:
            false, // Pas de propriété onlyShowVerified dans DiscoveryPreferencesEntity
        limit: limit,
      );

      return Right(profiles);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get discovery profiles', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get profiles',
        code: e.code?.toString() ?? 'GET_PROFILES_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting discovery profiles', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasSwiped({
    required String swiperId,
    required String targetId,
  }) async {
    try {
      final hasSwiped = await remoteDataSource.hasSwiped(
        swiperId: swiperId,
        targetId: targetId,
      );
      return Right(hasSwiped);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to check swipe status', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to check swipe',
        code: e.code?.toString() ?? 'CHECK_SWIPE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error checking swipe', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SwipeEntity>>> getUserSwipes(
      String userId) async {
    try {
      final swipesData = await remoteDataSource.getRecentSwipes(userId);

      final swipes = swipesData.map((data) {
        return SwipeEntity(
          id: data['\$id'] ?? data['id'] ?? '',
          swiperId: data['fromUserId'] ?? '', // Adapter pour fromUserId
          targetId: data['toUserId'] ?? '', // Adapter pour toUserId
          action: _parseSwipeAction(data['action'] ?? ''),
          createdAt: DateTime.parse(
              data['createdAt'] ?? DateTime.now().toIso8601String()),
        );
      }).toList();

      return Right(swipes);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get user swipes', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get swipes',
        code: e.code?.toString() ?? 'GET_SWIPES_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting user swipes', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SwipeEntity>> rewind(String userId) async {
    try {
      AppLogger.i('Processing rewind for user: $userId');

      // Get most recent swipe
      final swipesData =
          await remoteDataSource.getRecentSwipes(userId, limit: 1);

      if (swipesData.isEmpty) {
        return Left(const ValidationFailure(
          message: 'No swipe to rewind',
        ));
      }

      final lastSwipeData = swipesData.first;

      // Delete the swipe
      await remoteDataSource
          .deleteSwipe(lastSwipeData['id'] ?? lastSwipeData['\$id'] ?? '');

      // Return the deleted swipe
      final swipe = SwipeEntity(
        id: lastSwipeData['id'] ?? lastSwipeData['\$id'] ?? '',
        swiperId: lastSwipeData['fromUserId'] ?? '', // Adapter pour fromUserId
        targetId: lastSwipeData['toUserId'] ?? '', // Adapter pour toUserId
        action: _parseSwipeAction(lastSwipeData['action'] ?? ''),
        createdAt: DateTime.parse(
            lastSwipeData['createdAt'] ?? DateTime.now().toIso8601String()),
      );

      return Right(swipe);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to rewind swipe', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to rewind',
        code: e.code?.toString() ?? 'REWIND_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error rewinding swipe', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Check if two users have matched (mutual likes/super likes)
  Future<MatchEntity?> _checkForMatch({
    required String user1Id,
    required String user2Id,
  }) async {
    try {
      // Check if a match already exists
      final alreadyMatched =
          await matchDataSource.matchExists(user1Id, user2Id);
      if (alreadyMatched) {
        AppLogger.i('Match already exists between $user1Id and $user2Id');
        return null;
      }

      // Check if user2 has swiped on user1
      final documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        queries: [
          Query.equal('fromUserId', user2Id),
          Query.equal('toUserId', user1Id),
          Query.notEqual('action', 'pass'), // Must be like or superLike
        ],
      );

      if (documents.documents.isEmpty) {
        // No mutual swipe
        return null;
      }

      // Create match if mutual like detected
      AppLogger.i('🎉 Mutual like detected! Creating match...');

      final match = await matchDataSource.createMatch(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      AppLogger.i('✨ Match created successfully!');
      return match;
    } catch (e) {
      AppLogger.e('Error checking for match', error: e);
      return null;
    }
  }

  SwipeAction _parseSwipeAction(String action) {
    switch (action.toLowerCase()) {
      case 'like':
        return SwipeAction.like;
      case 'pass':
        return SwipeAction.pass;
      case 'superlike':
      case 'super_like':
        return SwipeAction.superLike;
      default:
        return SwipeAction.pass;
    }
  }
}
