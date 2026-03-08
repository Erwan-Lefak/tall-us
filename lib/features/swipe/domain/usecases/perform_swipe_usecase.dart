import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/domain/repositories/swipe_repository.dart';

/// Use case for performing a swipe action
class PerformSwipeUseCase {
  final SwipeRepository repository;

  PerformSwipeUseCase(this.repository);

  /// Perform a swipe and potentially create a match
  /// Returns a MatchEntity if a match was created, null otherwise
  Future<Either<Failure, MatchEntity?>> call({
    required String swiperId,
    required String targetId,
    required SwipeAction action,
  }) async {
    return await repository.swipe(
      swiperId: swiperId,
      targetId: targetId,
      action: action,
    );
  }
}
