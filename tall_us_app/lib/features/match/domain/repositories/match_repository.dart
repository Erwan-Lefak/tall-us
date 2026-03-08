import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';

/// Repository interface for match operations
abstract class MatchRepository {
  /// Get all matches for a user
  Future<Either<Failure, List<MatchEntity>>> getMatches(String userId);

  /// Get unread matches
  Future<Either<Failure, List<MatchEntity>>> getUnreadMatches(String userId);

  /// Get a specific match
  Future<Either<Failure, MatchEntity>> getMatch(String matchId);

  /// Mark match as read
  Future<Either<Failure, void>> markAsRead(String matchId);

  /// Unmatch (remove a match)
  Future<Either<Failure, void>> unmatch(String matchId, String userId);

  /// Get match with profile information
  Future<Either<Failure, Map<String, dynamic>>> getMatchWithProfile(
    String matchId,
    String currentUserId,
  );
}
