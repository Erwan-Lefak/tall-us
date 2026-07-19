import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';

/// Remote data source for email verification using Appwrite
class EmailVerificationRemoteDataSource {
  final Account _account;

  EmailVerificationRemoteDataSource({required Account account})
      : _account = account;

  /// Send verification email to the currently logged-in user
  Future<void> sendVerificationEmail() async {
    try {
      AppLogger.i('Sending verification email');

      await _account.createVerification(
        url: '${AppwriteConfig.appUrl}/auth/verify-email',
      );

      AppLogger.i('Verification email sent successfully');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to send verification email', error: e);
      rethrow;
    }
  }

  /// Verify email with userId and secret from the callback URL
  Future<bool> verifyEmail({
    required String userId,
    required String secret,
  }) async {
    try {
      AppLogger.i('Verifying email for user: $userId');

      await _account.updateVerification(
        userId: userId,
        secret: secret,
      );

      AppLogger.i('Email verified successfully');
      return true;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to verify email', error: e);
      rethrow;
    }
  }

  /// Check if the current user's email is verified
  Future<bool> checkVerificationStatus() async {
    try {
      final user = await _account.get();
      return user.emailVerification;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to check verification status', error: e);
      rethrow;
    }
  }

  /// Create a temporary session, send verification, then delete session
  /// Used after registration when user isn't logged in yet
  Future<void> sendVerificationWithTempSession({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('Creating temp session for verification email');

      // Create temporary session
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Send verification email
      await _account.createVerification(
        url: '${AppwriteConfig.appUrl}/auth/verify-email',
      );

      AppLogger.i('Verification email sent, deleting temp session');

      // Delete the temporary session so user stays logged out
      await _account.deleteSession(sessionId: 'current');

      AppLogger.i('Temp session deleted');
    } on AppwriteException catch (e) {
      // Try to clean up session if something went wrong
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {}
      AppLogger.e('Failed to send verification with temp session', error: e);
      rethrow;
    }
  }
}
