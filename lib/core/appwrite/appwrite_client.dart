import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'appwrite_config.dart';

/// Appwrite Client Provider
///
/// Singleton instance of Appwrite client configured for Tall Us
class AppwriteClient {
  static Client? _client;
  static Account? _account;
  static Databases? _databases;
  static Storage? _storage;
  static Realtime? _realtime;

  /// Get singleton client instance
  static Client get client {
    _client ??= Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);
    return _client!;
  }

  /// Get Account API
  static Account get account {
    _account ??= Account(client);
    return _account!;
  }

  /// Get Databases API
  static Databases get databases {
    _databases ??= Databases(client);
    return _databases!;
  }

  /// Get Storage API
  static Storage get storage {
    _storage ??= Storage(client);
    return _storage!;
  }

  /// Get Realtime API
  static Realtime get realtime {
    _realtime ??= Realtime(client);
    return _realtime!;
  }

  /// Reset all instances (for testing)
  static void reset() {
    _client = null;
    _account = null;
    _databases = null;
    _storage = null;
    _realtime = null;
  }
}

/// Riverpod provider for Appwrite Client
///
/// Usage:
/// ```dart
/// final client = ref.watch(appwriteClientProvider);
/// final account = ref.watch(accountProvider);
/// ```

final appwriteClientProvider = Provider<Client>((ref) {
  return AppwriteClient.client;
});

final accountProvider = Provider<Account>((ref) {
  return AppwriteClient.account;
});

final databasesProvider = Provider<Databases>((ref) {
  return AppwriteClient.databases;
});

final storageProvider = Provider<Storage>((ref) {
  return AppwriteClient.storage;
});

final realtimeProvider = Provider<Realtime>((ref) {
  return AppwriteClient.realtime;
});
