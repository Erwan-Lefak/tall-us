import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Login Use Case
///
/// Business logic for user login
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute login with email and password
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      return Left(ValidationFailure(
        message: 'Invalid email format',
        code: 'INVALID_EMAIL',
      ));
    }

    // Validate password
    if (password.isEmpty) {
      return Left(ValidationFailure(
        message: 'Password is required',
        code: 'PASSWORD_REQUIRED',
      ));
    }

    // Call repository
    return await _repository.login(email: email, password: password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
