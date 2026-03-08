import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/storage/data/datasources/storage_remote_datasource.dart';
import 'package:tall_us/features/storage/presentation/providers/upload_notifier.dart';

/// Provider for StorageRemoteDataSource
final storageRemoteDataSourceProvider = Provider<StorageRemoteDataSource>((ref) {
  final storage = Storage(ref.read(appwriteClientProvider));
  return StorageRemoteDataSource(storage: storage);
});

/// Provider for UploadNotifier
final uploadNotifierProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  final dataSource = ref.read(storageRemoteDataSourceProvider);
  return UploadNotifier(dataSource);
});
