import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';

/// Remote data source for file storage operations
class StorageRemoteDataSource {
  final Storage _storage;

  StorageRemoteDataSource({required Storage storage}) : _storage = storage;

  /// Upload a photo file
  Future<String> uploadPhoto({
    required File file,
    required String userId,
    required String bucketId,
  }) async {
    try {
      AppLogger.i('Uploading photo for user: $userId');

      // Generate unique filename
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}';

      // Get file extension
      final extension = file.path.split('.').last.toLowerCase();

      // Upload file
      final fileResponse = await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path, filename: '$fileName.$extension'),
        permissions: [
          Permission.read(Role.user(userId)),
          // Public read for profile photos
          Permission.read(Role.any()),
        ],
      );

      // Get file preview URL
      final url = _storage.getFilePreview(
        bucketId: bucketId,
        fileId: fileResponse.$id,
      );

      // Convert to string (URL toString() returns the full URL)
      final previewUrl = url.toString();

      AppLogger.i('Photo uploaded successfully: ${fileResponse.$id}');
      AppLogger.i('Preview URL: $previewUrl');

      return previewUrl;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to upload photo', error: e);
      rethrow;
    }
  }

  /// Upload multiple photos
  Future<List<String>> uploadMultiplePhotos({
    required List<File> files,
    required String userId,
    String bucketId = AppwriteConfig.photosBucketId,
  }) async {
    AppLogger.i('Uploading ${files.length} photos for user: $userId');

    final urls = <String>[];

    for (final file in files) {
      try {
        final url = await uploadPhoto(
          file: file,
          userId: userId,
          bucketId: bucketId,
        );
        urls.add(url);
      } catch (e) {
        AppLogger.e('Failed to upload one photo', error: e);
        // Continue with other photos
      }
    }

    AppLogger.i('Successfully uploaded ${urls.length}/${files.length} photos');

    return urls;
  }

  /// Delete a photo
  Future<void> deletePhoto({
    required String fileId,
    required String bucketId,
  }) async {
    try {
      await _storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId,
      );

      AppLogger.i('Photo deleted successfully: $fileId');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to delete photo', error: e);
      rethrow;
    }
  }

  /// Get file preview URL
  String getFilePreviewUrl({
    required String fileId,
    String bucketId = AppwriteConfig.photosBucketId,
  }) {
    final url = _storage.getFilePreview(
      bucketId: bucketId,
      fileId: fileId,
    );

    return url.toString();
  }
}
