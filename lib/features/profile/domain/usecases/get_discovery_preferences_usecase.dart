import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

/// Use case for getting discovery preferences
class GetDiscoveryPreferencesUseCase {
  final ProfileRepository repository;

  GetDiscoveryPreferencesUseCase(this.repository);

  /// Get discovery preferences by user ID
  Future<Either<Failure, DiscoveryPreferencesEntity>> call(
      String userId) async {
    return await repository.getDiscoveryPreferences(userId);
  }
}
