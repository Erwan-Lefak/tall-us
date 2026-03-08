import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Refresh Token Use Case
///
/// Business logic for refreshing access token
class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  /// Execute token refresh
  Future<Either<Failure, String>> call(String refreshToken) async {
    if (refreshToken.isEmpty) {
      return Left(const ValidationFailure(
        message: 'Refresh token is required',
        code: 'TOKEN_REQUIRED',
      ));
    }

    return await _repository.refreshToken(refreshToken);
  }
}
