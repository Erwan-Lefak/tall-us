import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Update Password Use Case
///
/// Business logic for updating password (authenticated)
class UpdatePasswordUseCase {
  final AuthRepository _repository;

  UpdatePasswordUseCase(this._repository);

  /// Execute password update
  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Validate current password
    if (currentPassword.isEmpty) {
      return Left(const ValidationFailure(
        message: 'Current password is required',
        code: 'CURRENT_PASSWORD_REQUIRED',
      ));
    }

    // Validate new password strength
    final passwordValidation = _validatePassword(newPassword);
    if (passwordValidation != null) {
      return Left(passwordValidation);
    }

    // Check if new password is different from current
    if (currentPassword == newPassword) {
      return Left(const ValidationFailure(
        message: 'New password must be different from current password',
        code: 'PASSWORD_SAME_AS_CURRENT',
      ));
    }

    return await _repository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  ValidationFailure? _validatePassword(String password) {
    if (password.length < 8) {
      return const ValidationFailure(
        message: 'Password must be at least 8 characters',
        code: 'PASSWORD_TOO_SHORT',
      );
    }

    if (password.length > 100) {
      return const ValidationFailure(
        message: 'Password must be less than 100 characters',
        code: 'PASSWORD_TOO_LONG',
      );
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return const ValidationFailure(
        message: 'Password must contain at least one uppercase letter',
        code: 'PASSWORD_NO_UPPERCASE',
      );
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return const ValidationFailure(
        message: 'Password must contain at least one lowercase letter',
        code: 'PASSWORD_NO_LOWERCASE',
      );
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return const ValidationFailure(
        message: 'Password must contain at least one number',
        code: 'PASSWORD_NO_NUMBER',
      );
    }

    return null;
  }
}
