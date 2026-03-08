import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Remote data source for discovery operations
class DiscoveryRemoteDataSource {
  final Databases _databases;

  DiscoveryRemoteDataSource(this._databases);

  /// Get profiles to discover from Appwrite
  Future<List<UserProfileEntity>> getProfilesToDiscover({
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
      AppLogger.i('Querying profiles from Appwrite');

      // Build queries for filtering
      final queries = <String>[];

      // Only get profiles with photos
      queries.add('attribute.exists("photoUrls")');
      queries.add('attribute.size("photoUrls", 1, ">")');

      // Only get completed profiles
      queries.add('attribute.exists("displayName")');
      queries.add('attribute.exists("birthday")');
      queries.add('attribute.exists("heightCm")');

      // Exclude current user
      queries.add('attribute.notEqual("\$id", "$userId")');

      // Filter by gender if preferences specified
      if (preferredGenders.isNotEmpty) {
        final genderQuery = preferredGenders.map((g) => 'gender="$g"').join(' || ');
        queries.add('($genderQuery)');
      }

      // Query profiles from Appwrite
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.profilesCollection,
        queries: queries,
      );

      AppLogger.i('Retrieved ${result.documents.length} raw profiles');

      // Convert and filter profiles
      final profiles = <UserProfileEntity>[];

      for (final doc in result.documents) {
        try {
          final profile = UserProfileEntity.fromMap(doc.data);

          // Apply additional filters that can't be done in Appwrite query
          final age = profile.calculateAge();

          // Age filter
          if (age < minAge || age > maxAge) {
            continue;
          }

          // Height filter
          if (profile.heightCm < minHeightCm || profile.heightCm > maxHeightCm) {
            continue;
          }

          // Gender filter (double-check)
          if (preferredGenders.isNotEmpty &&
              !preferredGenders.contains(profile.gender)) {
            continue;
          }

          profiles.add(profile);
        } catch (e) {
          AppLogger.w('Failed to parse profile: ${e.toString()}');
          continue;
        }
      }

      AppLogger.i('Filtered to ${profiles.length} valid profiles');

      // Shuffle and limit results
      profiles.shuffle();
      if (profiles.length > limit) {
        return profiles.sublist(0, limit);
      }

      return profiles;
    } on AppwriteException catch (e) {
      AppLogger.e('Appwrite error fetching profiles', error: e);
      rethrow;
    } catch (e) {
      AppLogger.e('Error fetching profiles', error: e);
      rethrow;
    }
  }
}
