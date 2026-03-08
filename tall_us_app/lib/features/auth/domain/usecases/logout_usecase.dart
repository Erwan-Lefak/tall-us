import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Logout Use Case
///
/// Business logic for user logout
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Execute logout
  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}
