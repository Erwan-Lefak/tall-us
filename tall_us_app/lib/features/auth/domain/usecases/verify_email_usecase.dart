import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Use case for verifying email with callback params
class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  /// Verify email using userId and secret from Appwrite callback
  Future<Either<Failure, bool>> call({
    required String userId,
    required String secret,
  }) async {
    return await repository.verifyEmail(userId: userId, secret: secret);
  }
}
