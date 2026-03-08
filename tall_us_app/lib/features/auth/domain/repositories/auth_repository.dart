import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';

/// Authentication Repository Interface
///
/// Defines contract for authentication operations
abstract class AuthRepository {
  /// Register new user with email and password
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String displayName,
    required String gender,
    required int height,
    required DateTime birthday,
    required String countryCode,
    required String city,
  });

  /// Login with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Refresh access token
  Future<Either<Failure, String>> refreshToken(String refreshToken);

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update password
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete account
  Future<Either<Failure, void>> deleteAccount();

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges;
}
