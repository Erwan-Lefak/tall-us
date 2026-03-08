import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Send Password Reset Email Use Case
///
/// Business logic for sending password reset email
class SendPasswordResetEmailUseCase {
  final AuthRepository _repository;

  SendPasswordResetEmailUseCase(this._repository);

  /// Execute send password reset email
  Future<Either<Failure, void>> call(String email) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      return Left(const ValidationFailure(
        message: 'Invalid email format',
        code: 'INVALID_EMAIL',
      ));
    }

    return await _repository.sendPasswordResetEmail(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
