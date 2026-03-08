import 'package:dartz/dartz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';

/// Auth Repository Implementation
///
/// Implements AuthRepository using Appwrite
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  
  AuthRepositoryImpl(this._remoteDataSource);

  @override
  bool get isAuthenticated => _remoteDataSource.isAuthenticated;

  @override
  Stream<bool> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String displayName,
    required String gender,
    required int height,
    required DateTime birthday,
    required String countryCode,
    required String city,
  }) async {
    try {
      AppLogger.i('Registering user: $email');

      final user = await _remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
        gender: gender,
        height: height,
        birthday: birthday,
        countryCode: countryCode,
        city: city,
      );

      return Right(user);
    } on AppwriteException catch (e) {
      AppLogger.e('Registration failed', error: e);

      if (e.code?.toString() == 'user_already_exists') {
        return Left(AuthFailure.emailAlreadyExists());
      }

      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Registration failed',
        code: e.code?.toString() ?? 'REGISTRATION_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error during registration', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('Logging in user: $email');

      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      return Right(user);
    } on AppwriteException catch (e) {
      AppLogger.e('Login failed', error: e);
      AppLogger.e('Appwrite error code: ${e.code}, message: ${e.message}, type: ${e.type}');

      if (e.code?.toString() == 'user_invalid_credentials') {
        return Left(AuthFailure.wrongCredentials());
      }

      if (e.code?.toString() == 'user_email_not_verified') {
        return Left(AuthFailure.emailNotVerified());
      }

      // Inclure le code d'erreur dans le message pour le traducteur
      final errorMessage = '${e.message?.toString() ?? 'Login failed'} [${e.code?.toString() ?? 'LOGIN_ERROR'}]';
      return Left(ServerFailure(
        message: errorMessage,
        code: e.code?.toString() ?? 'LOGIN_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error during login', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      AppLogger.i('Logging out user');

      await _remoteDataSource.logout();

      return const Right(null);
    } catch (e) {
      AppLogger.e('Logout failed', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();

      if (user == null) {
        return Left(AuthFailure.userNotFound());
      }

      return Right(user);
    } catch (e) {
      AppLogger.e('Failed to get current user', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      AppLogger.i('Refreshing token');

      final accessToken = await _remoteDataSource.refreshToken(refreshToken);

      return Right(accessToken);
    } catch (e) {
      AppLogger.e('Token refresh failed', error: e);
      return Left(AuthFailure.sessionExpired());
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.i('Sending password reset email to: $email');

      await _remoteDataSource.sendPasswordResetEmail(email);

      return const Right(null);
    } catch (e) {
      AppLogger.e('Failed to send password reset email', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      AppLogger.i('Resetting password');

      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      return const Right(null);
    } catch (e) {
      AppLogger.e('Password reset failed', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      AppLogger.i('Updating password');

      await _remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.e('Password update failed', error: e);

      if (e.code?.toString() == 'user_invalid_credentials') {
        return Left(AuthFailure.wrongCredentials());
      }

      return Left(ServerFailure(
        message: e.message?.toString() ?? 'Password update failed',
        code: e.code?.toString() ?? 'PASSWORD_UPDATE_ERROR',
      ));
    } catch (e) {
      AppLogger.e('Unexpected error during password update', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      AppLogger.i('Deleting account');

      await _remoteDataSource.deleteAccount();

      return const Right(null);
    } catch (e) {
      AppLogger.e('Account deletion failed', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});
