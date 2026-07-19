import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/verification/data/datasources/height_verification_remote_datasource.dart';
import 'package:tall_us/features/verification/data/repositories/height_verification_repository_impl.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Datasource for the verifications collection.
final heightVerificationDataSourceProvider =
    Provider<HeightVerificationRemoteDatasource>((ref) {
  return HeightVerificationRemoteDatasource(
    databases: ref.watch(databasesProvider),
    storage: ref.watch(storageProvider),
  );
});

/// Repository wiring the datasource into DI.
final heightVerificationRepositoryProvider =
    Provider<HeightVerificationRepositoryImpl>((ref) {
  return HeightVerificationRepositoryImpl(
    remoteDatasource: ref.watch(heightVerificationDataSourceProvider),
  );
});

/// Current user's height-verification status (their most recent verification
/// document, or null if none). Auto-disposes when no longer listened.
final heightVerificationStatusProvider =
    FutureProvider.autoDispose<HeightVerificationEntity?>((ref) async {
  final userId = ref.watch(authenticatedUserProvider)?.id;
  if (userId == null) return null;

  final result =
      await ref.watch(heightVerificationRepositoryProvider).getVerificationStatus(userId);
  return result.fold(
    (failure) => null,
    (verification) => verification,
  );
});
