import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/storage/data/datasources/storage_remote_datasource.dart';
import 'package:tall_us/features/storage/presentation/providers/upload_state.dart';

/// Notifier for photo uploads
class UploadNotifier extends StateNotifier<UploadState> {
  final StorageRemoteDataSource dataSource;

  UploadNotifier(this.dataSource) : super(const UploadState.initial());

  /// Upload a single photo
  Future<void> uploadPhoto({
    required File file,
    required String userId,
    String bucketId = 'tall-us-photos',
  }) async {
    state = UploadState.uploading(0.0);

    try {
      AppLogger.i('Starting photo upload...');

      final url = await dataSource.uploadPhoto(
        file: file,
        userId: userId,
        bucketId: bucketId,
      );

      AppLogger.i('Photo uploaded successfully: $url');

      state = UploadState.success(url);
    } catch (e) {
      AppLogger.e('Failed to upload photo', error: e);
      state = UploadState.error(e.toString());
    }
  }

  /// Upload multiple photos
  Future<void> uploadMultiplePhotos({
    required List<File> files,
    required String userId,
    String bucketId = 'tall-us-photos',
  }) async {
    state = UploadState.uploading(0.0);

    try {
      AppLogger.i('Starting multiple photo upload (${files.length} files)...');

      final urls = await dataSource.uploadMultiplePhotos(
        files: files,
        userId: userId,
        bucketId: bucketId,
      );

      if (urls.isEmpty) {
        state = const UploadState.error('No photos could be uploaded');
      } else if (urls.length < files.length) {
        // Some photos failed
        state = UploadState.success(urls.first); // Return first successful URL
        AppLogger.w('Only ${urls.length}/${files.length} photos uploaded');
      } else {
        // All photos uploaded
        state = UploadState.success(urls.first); // Return first URL
      }
    } catch (e) {
      AppLogger.e('Failed to upload photos', error: e);
      state = UploadState.error(e.toString());
    }
  }

  /// Reset state
  void reset() {
    state = const UploadState.initial();
  }
}
