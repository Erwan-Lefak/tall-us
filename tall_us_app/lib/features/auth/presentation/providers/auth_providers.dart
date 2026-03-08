import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tall_us/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';
import 'package:tall_us/features/auth/domain/repositories/auth_repository.dart';
import 'package:tall_us/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/login_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/register_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_notifier.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_state.dart';

// ============================================================================
// Repository Provider
// ============================================================================

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// ============================================================================
// Use Case Providers
// ============================================================================

/// Provider for LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provider for RegisterUseCase
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

/// Provider for LogoutUseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Provider for GetCurrentUserUseCase
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

/// Provider for RefreshTokenUseCase
final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RefreshTokenUseCase(repository);
});

/// Provider for SendPasswordResetEmailUseCase
final sendPasswordResetEmailUseCaseProvider =
    Provider<SendPasswordResetEmailUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SendPasswordResetEmailUseCase(repository);
});

/// Provider for ResetPasswordUseCase
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(repository);
});

/// Provider for UpdatePasswordUseCase
final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdatePasswordUseCase(repository);
});

/// Provider for DeleteAccountUseCase
final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return DeleteAccountUseCase(repository);
});

// ============================================================================
// Notifier Provider
// ============================================================================

/// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    refreshTokenUseCase: ref.watch(refreshTokenUseCaseProvider),
    sendPasswordResetEmailUseCase: ref.watch(sendPasswordResetEmailUseCaseProvider),
    resetPasswordUseCase: ref.watch(resetPasswordUseCaseProvider),
    updatePasswordUseCase: ref.watch(updatePasswordUseCaseProvider),
    deleteAccountUseCase: ref.watch(deleteAccountUseCaseProvider),
  );
});

// ============================================================================
// Convenience Providers
// ============================================================================

/// Provider for current auth state (convenience)
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});

/// Provider for authenticated user (convenience)
/// Returns null if user is not authenticated
final authenticatedUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

/// Provider for authentication status (convenience)
/// Returns true if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
});

/// Provider for loading status (convenience)
/// Returns true if auth operation is in progress
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});
