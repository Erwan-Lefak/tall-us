import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/match/domain/repositories/match_repository.dart';

class GetMatchesUseCase {
  final MatchRepository repository;

  GetMatchesUseCase(this.repository);

  Future<Either<Failure, List<MatchEntity>>> call(String userId) async {
    return await repository.getMatches(userId);
  }

  Future<Either<Failure, List<MatchEntity>>> getUnreadMatches(
      String userId) async {
    return await repository.getUnreadMatches(userId);
  }
}
