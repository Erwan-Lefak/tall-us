import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';

/// Repository interface for swipe operations
abstract class SwipeRepository {
  /// Swipe on a profile
  /// Returns the match if it's a mutual like, null otherwise
  Future<Either<Failure, MatchEntity?>> swipe({
    required String swiperId,
    required String targetId,
    required SwipeAction action,
  });

  /// Get profiles to swipe on (discovery queue)
  Future<Either<Failure, List<UserProfileEntity>>> getDiscoveryProfiles({
    required String userId,
    required DiscoveryPreferencesEntity preferences,
    int limit = 20,
  });

  /// Check if user has already swiped on target
  Future<Either<Failure, bool>> hasSwiped({
    required String swiperId,
    required String targetId,
  });

  /// Get all swipes by user
  Future<Either<Failure, List<SwipeEntity>>> getUserSwipes(String userId);

  /// Rewind (undo last swipe)
  Future<Either<Failure, SwipeEntity>> rewind(String userId);
}
