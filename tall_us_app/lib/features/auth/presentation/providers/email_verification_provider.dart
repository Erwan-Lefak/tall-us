import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tall_us/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:tall_us/features/auth/domain/usecases/verify_email_usecase.dart';

/// Email verification state
class EmailVerificationState {
  final bool isSending;
  final bool isSent;
  final bool isVerifying;
  final bool isVerified;
  final String? error;
  final int cooldownSeconds;

  const EmailVerificationState({
    this.isSending = false,
    this.isSent = false,
    this.isVerifying = false,
    this.isVerified = false,
    this.error,
    this.cooldownSeconds = 0,
  });

  EmailVerificationState copyWith({
    bool? isSending,
    bool? isSent,
    bool? isVerifying,
    bool? isVerified,
    String? error,
    int? cooldownSeconds,
  }) {
    return EmailVerificationState(
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      isVerifying: isVerifying ?? this.isVerifying,
      isVerified: isVerified ?? this.isVerified,
      error: error ?? this.error,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
    );
  }
}

/// Email verification notifier
class EmailVerificationNotifier extends StateNotifier<EmailVerificationState> {
  final SendEmailVerificationUseCase _sendVerificationUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;

  EmailVerificationNotifier({
    required SendEmailVerificationUseCase sendVerificationUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
  })  : _sendVerificationUseCase = sendVerificationUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        super(const EmailVerificationState());

  /// Send verification email
  Future<void> sendVerificationEmail() async {
    state = state.copyWith(isSending: true, error: null);

    final result = await _sendVerificationUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isSending: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(isSending: false, isSent: true);
        _startCooldown();
        AppLogger.i('Verification email sent');
      },
    );
  }

  /// Send verification with temp session (after registration)
  Future<void> sendWithTempSession({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSending: true, error: null);

    final result = await _sendVerificationUseCase.withTempSession(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isSending: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(isSending: false, isSent: true);
        _startCooldown();
        AppLogger.i('Verification email sent via temp session');
      },
    );
  }

  /// Verify email with callback parameters
  Future<void> verifyEmail({
    required String userId,
    required String secret,
  }) async {
    state = state.copyWith(isVerifying: true, error: null);

    final result = await _verifyEmailUseCase(userId: userId, secret: secret);

    result.fold(
      (failure) {
        state = state.copyWith(isVerifying: false, error: failure.message);
      },
      (verified) {
        state = state.copyWith(isVerifying: false, isVerified: verified);
        AppLogger.i('Email verified: $verified');
      },
    );
  }

  /// Start cooldown timer (60 seconds)
  void _startCooldown() {
    state = state.copyWith(cooldownSeconds: 60);
    _tickCooldown();
  }

  void _tickCooldown() async {
    while (state.cooldownSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      state = state.copyWith(cooldownSeconds: state.cooldownSeconds - 1);
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for email verification use cases
final sendEmailVerificationUseCaseProvider =
    Provider<SendEmailVerificationUseCase>((ref) {
  return SendEmailVerificationUseCase(ref.watch(authRepositoryProvider));
});

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  return VerifyEmailUseCase(ref.watch(authRepositoryProvider));
});

/// Provider for email verification notifier
final emailVerificationProvider =
    StateNotifierProvider<EmailVerificationNotifier, EmailVerificationState>(
        (ref) {
  return EmailVerificationNotifier(
    sendVerificationUseCase: ref.watch(sendEmailVerificationUseCaseProvider),
    verifyEmailUseCase: ref.watch(verifyEmailUseCaseProvider),
  );
});
