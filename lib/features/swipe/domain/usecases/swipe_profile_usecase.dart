import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/domain/repositories/swipe_repository.dart';

/// Use case for swiping on a profile
class SwipeProfileUseCase {
  final SwipeRepository repository;

  SwipeProfileUseCase(this.repository);

  /// Swipe on a profile (like, pass, or super like)
  /// Returns the match if it's a mutual like, null otherwise
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

  /// Quick like
  Future<Either<Failure, MatchEntity?>> like({
    required String swiperId,
    required String targetId,
  }) async {
    return await call(
      swiperId: swiperId,
      targetId: targetId,
      action: SwipeAction.like,
    );
  }

  /// Quick pass
  Future<Either<Failure, void>> pass({
    required String swiperId,
    required String targetId,
  }) async {
    return await repository.swipe(
      swiperId: swiperId,
      targetId: targetId,
      action: SwipeAction.pass,
    );
  }

  /// Quick super like
  Future<Either<Failure, MatchEntity?>> superLike({
    required String swiperId,
    required String targetId,
  }) async {
    return await call(
      swiperId: swiperId,
      targetId: targetId,
      action: SwipeAction.superLike,
    );
  }
}
