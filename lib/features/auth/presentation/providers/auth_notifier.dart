import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/login_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/register_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_state.dart';

/// Authentication Notifier
///
/// Manages authentication state and handles auth operations
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _refreshTokenUseCase = refreshTokenUseCase,
        _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        super(const AuthState.initial()) {
    // Check authentication status on initialization
    checkAuthStatus();
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) {
        AppLogger.w('User not authenticated: ${failure.message}');
        state = const AuthState.unauthenticated();
      },
      (user) {
        AppLogger.i('User authenticated: ${user.email}');
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        // Afficher l'erreur complète dans la console pour le débogage
        AppLogger.e('Login failed: ${failure.message}',
            error: failure.toString());
        if (failure is ServerFailure) {
          AppLogger.e('Original error details', error: failure.toString());
        }
        state = AuthState.error(_getErrorMessage(failure));
      },
      (user) {
        AppLogger.i('Login successful: ${user.email}');
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required String gender,
    required int height,
    required DateTime birthday,
    required String countryCode,
    required String city,
  }) async {
    state = const AuthState.loading();

    final result = await _registerUseCase(
      email: email,
      password: password,
      displayName: displayName,
      gender: gender,
      height: height,
      birthday: birthday,
      countryCode: countryCode,
      city: city,
    );

    result.fold(
      (failure) {
        AppLogger.e('Registration failed: ${failure.message}');
        state = AuthState.error(_getErrorMessage(failure));
      },
      (user) {
        AppLogger.i('Registration successful: ${user.email}');
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Logout current user
  Future<void> logout() async {
    state = const AuthState.loading();

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        AppLogger.e('Logout failed: ${failure.message}');
        state = AuthState.error(_getErrorMessage(failure));
      },
      (_) {
        AppLogger.i('Logout successful');
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Refresh access token
  Future<void> refreshToken(String refreshToken) async {
    final result = await _refreshTokenUseCase(refreshToken);

    result.fold(
      (failure) {
        AppLogger.e('Token refresh failed: ${failure.message}');
        // If token refresh fails, logout the user
        state = const AuthState.unauthenticated();
      },
      (accessToken) {
        AppLogger.i('Token refresh successful');
        // Keep current state but update token internally
      },
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    final result = await _sendPasswordResetEmailUseCase(email);

    return result.fold(
      (failure) {
        AppLogger.e('Send password reset failed: ${failure.message}');
        return false;
      },
      (_) {
        AppLogger.i('Password reset email sent');
        return true;
      },
    );
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final result = await _resetPasswordUseCase(
      token: token,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) {
        AppLogger.e('Password reset failed: ${failure.message}');
        return false;
      },
      (_) {
        AppLogger.i('Password reset successful');
        return true;
      },
    );
  }

  /// Update password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _updatePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.fold(
      (failure) {
        AppLogger.e('Password update failed: ${failure.message}');
        state = AuthState.error(_getErrorMessage(failure));
        return false;
      },
      (_) {
        AppLogger.i('Password update successful');
        return true;
      },
    );
  }

  /// Delete account
  Future<void> deleteAccount() async {
    state = const AuthState.loading();

    final result = await _deleteAccountUseCase();

    result.fold(
      (failure) {
        AppLogger.e('Account deletion failed: ${failure.message}');
        state = AuthState.error(_getErrorMessage(failure));
      },
      (_) {
        AppLogger.i('Account deletion successful');
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Clear error state
  void clearError() {
    state.when(
      initial: () => state = const AuthState.initial(),
      loading: () => state = const AuthState.loading(),
      authenticated: (user) => state = AuthState.authenticated(user),
      unauthenticated: () => state = const AuthState.unauthenticated(),
      error: (_) => state = const AuthState.unauthenticated(),
    );
  }

  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (message) => _translateAppwriteError(message),
      network: (message) => message,
      cache: (message) => message,
      validation: (message) => message,
      auth: (message) => _translateAuthError(message),
      permission: (message) => message,
      payment: (message) => message,
      unknown: (message) => message,
    );
  }

  String _translateAppwriteError(String message) {
    // Extraire le code d'erreur s'il est présent dans le format "message [code]"
    String? errorCode;
    String actualMessage = message;
    final codeMatch = RegExp(r'\[([^\]]+)\]$').firstMatch(message);
    if (codeMatch != null) {
      errorCode = codeMatch.group(1);
      actualMessage = message.substring(0, codeMatch.start).trim();
    }

    // Traduction par code d'erreur Appwrite (plus fiable)
    final codeTranslations = {
      'user_invalid_credentials': 'Identifiants incorrects',
      'user_invalid_token': 'Jeton invalide',
      'user_email_not_verified': 'Veuillez vérifier votre adresse email',
      'user_not_found': 'Utilisateur introuvable',
      'user_already_exists': 'Cette adresse email est déjà utilisée',
      'user_password_too_weak': 'Le mot de passe est trop faible',
      'user_email_missing': 'L\'adresse email est manquante',
      'user_password_missing': 'Le mot de passe est manquant',
      'user_name_missing': 'Le nom est manquant',
      'general_session_active':
          'Une session est déjà active. Veuillez vous déconnecter d\'abord.',
      'general_unauthorized': 'Non autorisé',
      'general_forbidden': 'Accès refusé',
      'general_rate_limit_exceeded': 'Trop de tentatives. Réessayez plus tard.',
      'general_argument_invalid': 'Paramètre invalide',
      'general_unknown': 'Une erreur est survenue',
    };

    // Traduction par message d'erreur textuel
    final messageTranslations = {
      'Creation of session is prohibited when a session is active':
          'Une session est déjà active. Veuillez vous déconnecter d\'abord.',
      'Invalid credentials': 'Identifiants incorrects',
      'User not found': 'Utilisateur introuvable',
      'Invalid password': 'Mot de passe incorrect',
      'Email already exists': 'Cette adresse email est déjà utilisée',
      'Missing required parameter': 'Paramètre requis manquant',
      'Invalid token': 'Jeton invalide',
      'Session expired': 'La session a expiré',
      'Unauthorized': 'Non autorisé',
      'Access denied': 'Accès refusé',
      'Rate limit exceeded': 'Trop de tentatives. Réessayez plus tard.',
      'Invalid email': 'Adresse email invalide',
      'Invalid password': 'Mot de passe invalide',
      'Password too weak': 'Le mot de passe est trop faible',
      'Network error': 'Erreur réseau. Vérifiez votre connexion.',
      'general_unknown': 'Une erreur est survenue. Veuillez réessayer.',
    };

    // Chercher d'abord par code d'erreur
    if (errorCode != null && codeTranslations.containsKey(errorCode)) {
      return codeTranslations[errorCode]!;
    }

    // Chercher par traduction exacte du message
    if (messageTranslations.containsKey(actualMessage)) {
      return messageTranslations[actualMessage]!;
    }

    // Vérifier si le message contient une des chaînes connues
    for (var entry in messageTranslations.entries) {
      if (actualMessage.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    // Message par défaut
    return 'Une erreur est survenue. Veuillez réessayer.';
  }

  String _translateAuthError(String message) {
    final translations = {
      'Email already exists': 'Cette adresse email est déjà utilisée',
      'Invalid credentials': 'Identifiants incorrects',
      'User not found': 'Utilisateur introuvable',
      'Session expired': 'La session a expiré',
    };

    if (translations.containsKey(message)) {
      return translations[message]!;
    }

    for (var entry in translations.entries) {
      if (message.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return message;
  }
}
