import 'package:dartz/dartz.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/discovery/data/datasources/discovery_remote_datasource.dart';
import 'package:tall_us/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Implementation of discovery repository
class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryRemoteDataSource remoteDataSource;

  DiscoveryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<UserProfileEntity>>> getProfilesToDiscover({
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
    try {
      AppLogger.i('Fetching profiles to discover');

      final profiles = await remoteDataSource.getProfilesToDiscover(
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

      AppLogger.i('Found ${profiles.length} profiles to discover');
      return Right(profiles);
    } catch (e) {
      AppLogger.e('Failed to fetch profiles to discover', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
