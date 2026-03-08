import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Get Current User Use Case
///
/// Business logic for retrieving current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute get current user
  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser();
  }
}
