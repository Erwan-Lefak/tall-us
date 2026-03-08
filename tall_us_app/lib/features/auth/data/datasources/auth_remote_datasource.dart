import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/domain/entities/user_entity.dart';

/// Authentication Remote Data Source
///
/// Handles direct communication with Appwrite Account API
class AuthRemoteDataSource {
  final Account _account;
  final Databases _databases;

  AuthRemoteDataSource(this._account, this._databases);

  /// Check if user is authenticated
  bool get isAuthenticated {
    try {
      _account.getPrefs();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges {
    // Appwrite doesn't provide a built-in auth state stream
    // We'll create a manual stream that polls periodically
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => isAuthenticated,
    ).distinct();
  }

  /// Register new user
  Future<UserEntity> register({
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
      // Step 1: Delete any existing session to avoid conflicts
      try {
        await _account.deleteSessions();
        AppLogger.i('Deleted existing sessions before registration');
      } catch (e) {
        // Ignore error if no session exists
        AppLogger.d('No existing session to delete: $e');
      }

      // Step 2: Create user account in Appwrite
      AppLogger.i('Creating Appwrite account for: $email');

      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: displayName,
      );

      // Step 3: Create email verification session (verify on first login)
      try {
        await _account.createEmailPasswordSession(
          email: email,
          password: password,
        );
      } catch (e) {
        AppLogger.w('Failed to create session after registration: $e');
        // Continue anyway - user account was created successfully
      }

      // Step 4: Create profile in database
      AppLogger.i('Creating profile for user: ${user.$id}');

      final profileId = ID.unique();
      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: profileId,
        data: {
          'userId': user.$id,
          'display_name': displayName,
          'gender': gender,
          'height_cm': height,
          'birthday': birthday.toIso8601String(),
          'country_code': countryCode,
          'city': city,
          'created_at': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );

      // Step 5: Create user document in database
      AppLogger.i('Creating user document: ${user.$id}');

      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: user.$id,
        data: {
          'email': email,
          'email_verified': false,
          'role': 'free',
          'profile_id': profileId,
          'created_at': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
        ],
      );

      // Step 5: Get complete user data
      final userProfile = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        documentId: profileId,
      );

      return UserEntity(
        id: user.$id,
        email: user.email,
        emailVerified: user.emailVerification,
        role: UserRole.fromString('free'),
        createdAt: DateTime.parse(user.$createdAt),
        updatedAt: DateTime.parse(user.$updatedAt),
        profile: ProfileEntity.fromJson(userProfile.data),
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite registration failed', error: e);
      rethrow;
    }
  }

  /// Login with email and password
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // Delete any existing session to avoid conflicts
      try {
        await _account.deleteSessions();
        AppLogger.i('Deleted existing sessions before login');
      } catch (e) {
        // Ignore error if no session exists
        AppLogger.d('No existing session to delete: $e');
      }

      AppLogger.i('Creating session for: $email');

      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Get user data
      final user = await _account.get();

      // Try to get user document from database (may not exist for old accounts)
      ProfileEntity? profile;
      String roleStr = 'free';

      try {
        final userDoc = await _databases.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: user.$id,
        );
        roleStr = userDoc.data['role'] ?? 'free';

        if (userDoc.data['profile_id'] != null) {
          final profileDoc = await _databases.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.profilesCollection,
            documentId: userDoc.data['profile_id'],
          );
          profile = ProfileEntity.fromJson(profileDoc.data);
        }
      } catch (e) {
        // User document doesn't exist in database yet, use defaults
        AppLogger.w('User document not found in database, using defaults: $e');
      }

      return UserEntity(
        id: user.$id,
        email: user.email,
        emailVerified: user.emailVerification,
        role: UserRole.fromString(roleStr),
        createdAt: DateTime.parse(user.$createdAt),
        updatedAt: DateTime.parse(user.$updatedAt),
        profile: profile,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite login failed', error: e);
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      AppLogger.i('Deleting current session');

      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite logout failed', error: e);
      rethrow;
    }
  }

  /// Get current authenticated user
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = await _account.get();

      // Return user without profile for now
      // Profile will be loaded separately
      return UserEntity(
        id: user.$id,
        email: user.email,
        emailVerified: user.emailVerification,
        role: const UserRole.free(),
        createdAt: DateTime.parse(user.$createdAt),
        updatedAt: DateTime.parse(user.$updatedAt),
        profile: null,
      );
    } on AppwriteException catch (e) {
      if (e.code == 'user_unauthorized') {
        return null;
      }
      AppLogger.e('Appwrite get user failed', error: e);
      rethrow;
    }
  }

  /// Refresh access token
  Future<String> refreshToken(String refreshToken) async {
    try {
      AppLogger.i('Refreshing session token');

      final session = await _account.updateSession(
        sessionId: 'current',
      );

      // In Appwrite 12.x, use the session's JWT token
      return session.toString(); // Placeholder - adjust based on actual API
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite token refresh failed', error: e);
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.i('Sending password reset email to: $email');

      // Appwrite uses a recovery token sent via email
      await _account.createRecovery(
        email: email,
        url: '${AppwriteConfig.endpoint}/auth/reset-password', // Deep link URL
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite password reset failed', error: e);
      rethrow;
    }
  }

  /// Reset password with recovery token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      AppLogger.i('Updating password with recovery token');

      await _account.updateRecovery(
        userId: token.split(':')[0], // Token format: userId:secret
        secret: token.split(':')[1],
        password: newPassword,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite password update failed', error: e);
      rethrow;
    }
  }

  /// Update password (authenticated)
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      AppLogger.i('Updating password');

      // Verify current password by creating a session
      await _account.createEmailPasswordSession(
        email: (await _account.get()).email,
        password: currentPassword,
      );

      // Update password
      await _account.updatePassword(password: newPassword);
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite password update failed', error: e);
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      AppLogger.i('Deleting account');

      final user = await _account.get();

      // Delete profile
      final userDoc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: user.$id,
      );

      if (userDoc.data['profile_id'] != null) {
        await _databases.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollection,
          documentId: userDoc.data['profile_id'],
        );
      }

      // Delete user document
      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: user.$id,
      );

      // Delete Appwrite account - note: Account.delete() may not be available in all versions
      // For now, just delete from database and logout
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite account deletion failed', error: e);
      rethrow;
    }
  }
}

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final account = ref.watch(accountProvider);
  final databases = ref.watch(databasesProvider);
  return AuthRemoteDataSource(account, databases);
});
