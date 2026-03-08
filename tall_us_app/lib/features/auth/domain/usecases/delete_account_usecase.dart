import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Delete Account Use Case
///
/// Business logic for deleting user account
class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  /// Execute account deletion
  Future<Either<Failure, void>> call() async {
    return await _repository.deleteAccount();
  }
}
