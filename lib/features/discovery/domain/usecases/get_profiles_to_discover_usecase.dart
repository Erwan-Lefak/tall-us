import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/discovery/domain/repositories/discovery_repository.dart';

/// Use case for getting profiles to discover
class GetProfilesToDiscoverUseCase {
  final DiscoveryRepository repository;

  GetProfilesToDiscoverUseCase(this.repository);

  Future<Either<Failure, List<UserProfileEntity>>> call({
    required String userId,
    required int minAge,
    required int maxAge,
    required int minHeightCm,
    required int maxHeightCm,
    required List<String> preferredGenders,
    required int maxDistanceKm,
    required String userCity,
    required String userCountry,
    int limit = 20,
  }) async {
    return await repository.getProfilesToDiscover(
      userId: userId,
      minAge: minAge,
      maxAge: maxAge,
      minHeightCm: minHeightCm,
      maxHeightCm: maxHeightCm,
      preferredGenders: preferredGenders,
      maxDistanceKm: maxDistanceKm,
      userCity: userCity,
      userCountry: userCountry,
      limit: limit,
    );
  }
}
