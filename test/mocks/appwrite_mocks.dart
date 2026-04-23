import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';

/// Mock for Appwrite Databases
///
/// Used for testing database operations (list, get, create, update, delete)
class MockDatabases extends Mock implements Databases {}

/// Mock for Appwrite Realtime
///
/// Used for testing realtime subscriptions
class MockRealtime extends Mock implements Realtime {}

/// Mock for Appwrite Storage
///
/// Used for testing file operations (upload, download, delete, get preview)
class MockStorage extends Mock implements Storage {}

/// Mock for Appwrite Account
///
/// Used for testing authentication operations
class MockAccount extends Mock implements Account {}

/// Mock for Appwrite Functions
///
/// Used for testing server-side function calls
class MockFunctions extends Mock implements Functions {}

/// Mock helper for Appwrite document responses
class MockDocumentHelper {
  /// Create a mock document response
  static Map<String, dynamic> createDocument({
    required String id,
    required String collectionId,
    required String databaseId,
    required Map<String, dynamic> data,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? permissions,
  }) {
    return {
      '\$id': id,
      '\$collectionId': collectionId,
      '\$databaseId': databaseId,
      '\$createdAt': createdAt ?? DateTime.now().toIso8601String(),
      '\$updatedAt': updatedAt ?? DateTime.now().toIso8601String(),
      '\$permissions': permissions ?? [],
      ...data,
    };
  }

  /// Create a mock document list response
  static Map<String, dynamic> createDocumentList({
    required List<Map<String, dynamic>> documents,
    String? nextCursor,
    int total = 0,
  }) {
    return {
      'documents': documents,
      'total': total,
      if (nextCursor != null) 'nextCursor': nextCursor,
    };
  }

  /// Create a mock user response
  static Map<String, dynamic> createUser({
    required String id,
    required String email,
    required String name,
    String? phone,
    String? avatar,
    String? createdAt,
    String? updatedAt,
    List<String>? labels,
    bool preferred = false,
  }) {
    return {
      '\$id': id,
      'email': email,
      'name': name,
      'registration': DateTime.now().toIso8601String(),
      'accessed': DateTime.now().toIso8601String(),
      if (phone != null) 'phone': phone,
      if (avatar != null) 'avatar': avatar,
      '\$createdAt': createdAt ?? DateTime.now().toIso8601String(),
      '\$updatedAt': updatedAt ?? DateTime.now().toIso8601String(),
      'labels': labels ?? [],
      'preferred': preferred,
    };
  }

  /// Create a mock session response
  static Map<String, dynamic> createSession({
    required String id,
    required String userId,
    required String createdAt,
    required String updatedAt,
    required String expire,
  }) {
    return {
      '\$id': id,
      'userId': userId,
      '\$createdAt': createdAt,
      '\$updatedAt': updatedAt,
      'expire': expire,
      'provider': 'email',
      'providerUid': userId,
    };
  }

  /// Create a mock file response
  static Map<String, dynamic> createFile({
    required String id,
    required String bucketId,
    required String createdAt,
    required String updatedAt,
    required String name,
    required int size,
    String? mimeType,
    String? ownerId,
  }) {
    return {
      '\$id': id,
      'bucketId': bucketId,
      '\$createdAt': createdAt,
      '\$updatedAt': updatedAt,
      'name': name,
      'size': size,
      if (mimeType != null) 'mimeType': mimeType,
      if (ownerId != null) 'ownerId': ownerId,
      'props': {
        'size': size,
        'mimeType': mimeType ?? 'application/octet-stream',
      },
    };
  }
}

/// Mock helper for Appwrite errors
class MockAppwriteError {
  /// Create a mock Appwrite exception
  static Exception createException({
    required String message,
    required int code,
    required String type,
    int? responseCode,
  }) {
    return Exception(
      'AppwriteException: $message (code: $code, type: $type${responseCode != null ? ", response: $responseCode" : ""})',
    );
  }

  /// Create a generic document not found error
  static Exception documentNotFound(String documentId) {
    return createException(
      message: 'Document with id $documentId not found',
      code: 404,
      type: 'document_not_found',
      responseCode: 404,
    );
  }

  /// Create a generic collection not found error
  static Exception collectionNotFound(String collectionId) {
    return createException(
      message: 'Collection with id $collectionId not found',
      code: 404,
      type: 'collection_not_found',
      responseCode: 404,
    );
  }

  /// Create an unauthorized error
  static Exception unauthorized() {
    return createException(
      message: 'User is not authorized',
      code: 401,
      type: 'unauthorized',
      responseCode: 401,
    );
  }

  /// Create a validation error
  static Exception validation(String field, String message) {
    return createException(
      message: 'Validation failed for field $field: $message',
      code: 400,
      type: 'validation_error',
      responseCode: 400,
    );
  }

  /// Create a network error
  static Exception network() {
    return createException(
      message: 'Network request failed',
      code: 0,
      type: 'network_error',
    );
  }

  /// Create a quota exceeded error
  static Exception quotaExceeded(String resource) {
    return createException(
      message: '$resource quota exceeded',
      code: 429,
      type: 'quota_exceeded',
      responseCode: 429,
    );
  }
}
