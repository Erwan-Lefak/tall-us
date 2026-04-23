import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/discovery/data/datasources/discovery_remote_datasource.dart';
import 'package:tall_us/features/discovery/data/repositories/discovery_repository_impl.dart';
import 'package:tall_us/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:tall_us/features/discovery/domain/usecases/get_profiles_to_discover_usecase.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_notifier.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_state.dart';

/// Provider for DiscoveryRemoteDataSource
final discoveryRemoteDataSourceProvider =
    Provider<DiscoveryRemoteDataSource>((ref) {
  final databases = Databases(ref.read(appwriteClientProvider));
  return DiscoveryRemoteDataSource(databases);
});

/// Provider for DiscoveryRepository
final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  final remoteDataSource = ref.read(discoveryRemoteDataSourceProvider);
  return DiscoveryRepositoryImpl(remoteDataSource);
});

/// Provider for GetProfilesToDiscoverUseCase
final getProfilesToDiscoverUseCaseProvider =
    Provider<GetProfilesToDiscoverUseCase>((ref) {
  final repository = ref.read(discoveryRepositoryProvider);
  return GetProfilesToDiscoverUseCase(repository);
});

/// Provider for DiscoveryNotifier
final discoveryNotifierProvider =
    StateNotifierProvider<DiscoveryNotifier, DiscoveryState>((ref) {
  final getProfilesUseCase = ref.read(getProfilesToDiscoverUseCaseProvider);
  return DiscoveryNotifier(getProfilesUseCase);
});
