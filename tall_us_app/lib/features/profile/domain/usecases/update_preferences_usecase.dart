import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

class UpdatePreferencesUseCase {
  final ProfileRepository repository;

  UpdatePreferencesUseCase(this.repository);

  Future<Either<Failure, DiscoveryPreferencesEntity>> call(DiscoveryPreferencesEntity preferences) async {
    return await repository.updateDiscoveryPreferences(preferences);
  }
}
