import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Use case for sending email verification
class SendEmailVerificationUseCase {
  final AuthRepository repository;

  SendEmailVerificationUseCase(this.repository);

  /// Send verification email to the currently logged-in user
  Future<Either<Failure, void>> call() async {
    return await repository.sendEmailVerification();
  }

  /// Send verification with temp session (after registration)
  Future<Either<Failure, void>> withTempSession({
    required String email,
    required String password,
  }) async {
    return await repository.sendVerificationWithTempSession(
      email: email,
      password: password,
    );
  }
}
