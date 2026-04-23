import 'package:dartz/dartz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/match/data/datasources/match_remote_datasource.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/match/domain/repositories/match_repository.dart';

/// Implementation of MatchRepository
class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;

  MatchRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches(String userId) async {
    try {
      AppLogger.i('Getting matches for user: $userId');
      final matchesData = await remoteDataSource.getMatches(userId);

      final matches = matchesData.map((data) {
        return MatchEntity(
          id: data['\$id'] ?? data['id'] ?? '',
          user1Id: data['user1Id'] ?? '',
          user2Id: data['user2Id'] ?? '',
          createdAt: DateTime.parse(
              data['createdAt'] ?? DateTime.now().toIso8601String()),
          lastMessageId: data['lastMessageId'],
          lastMessageAt: data['lastMessageAt'] != null
              ? DateTime.parse(data['lastMessageAt'])
              : null,
          isRead: data['isRead'] ?? false,
        );
      }).toList();

      return Right(matches);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get matches', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get matches',
        code: e.code?.toString() ?? 'GET_MATCHES_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting matches', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchEntity>>> getUnreadMatches(
      String userId) async {
    try {
      AppLogger.i('Getting unread matches for user: $userId');
      final allMatchesResult = await getMatches(userId);

      return allMatchesResult.fold(
        (failure) => Left(failure),
        (matches) {
          final unreadMatches =
              matches.where((match) => !match.isRead).toList();
          return Right(unreadMatches);
        },
      );
    } catch (e) {
      AppLogger.e('Unexpected error getting unread matches', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatch(String matchId) async {
    try {
      AppLogger.i('Getting match: $matchId');
      // TODO: Implement getMatch in datasource
      throw UnimplementedError('getMatch');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get match', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get match',
        code: e.code?.toString() ?? 'GET_MATCH_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting match', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String matchId) async {
    try {
      AppLogger.i('Marking match as read: $matchId');
      await remoteDataSource.markAsRead(matchId);
      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to mark match as read', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to mark as read',
        code: e.code?.toString() ?? 'MARK_READ_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error marking match as read', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unmatch(String matchId, String userId) async {
    try {
      AppLogger.i('Unmatching: $matchId');
      await remoteDataSource.deleteMatch(matchId);
      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to unmatch', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to unmatch',
        code: e.code?.toString() ?? 'UNMATCH_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error unmatching', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMatchWithProfile(
    String matchId,
    String currentUserId,
  ) async {
    try {
      AppLogger.i('Getting match with profile: $matchId');
      final data = await remoteDataSource.getMatchWithProfile(
        matchId,
        currentUserId,
      );
      return Right(data);
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get match with profile', error: e);
      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Failed to get match',
        code: e.code?.toString() ?? 'GET_MATCH_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error getting match', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
