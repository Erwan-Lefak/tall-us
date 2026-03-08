import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Repository interface for discovery operations
abstract class DiscoveryRepository {
  /// Get profiles to discover based on user preferences
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
  });
}
