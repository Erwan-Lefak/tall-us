import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication State
///
/// Represents the current authentication state of the app
@freezed
class AuthState with _$AuthState {
  /// Initial state - checking authentication status
  const factory AuthState.initial() = _Initial;

  /// Loading state - operation in progress
  const factory AuthState.loading() = _Loading;

  /// Authenticated state - user is logged in
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;

  /// Unauthenticated state - user is logged out
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Error state - operation failed
  const factory AuthState.error(String message) = _Error;
}

extension AuthStateX on AuthState {
  bool get isAuthenticated => maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );

  bool get isLoading => maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

  UserEntity? get user => maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      );
}
