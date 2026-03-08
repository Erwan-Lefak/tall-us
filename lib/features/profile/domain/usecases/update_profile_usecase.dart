import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  /// Update user profile
  Future<Either<Failure, UserProfileEntity>> call(UserProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }

  /// Update specific fields only
  Future<Either<Failure, UserProfileEntity>> updateFields({
    required String userId,
    String? bio,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? promptAnswer,
    String? promptId,
  }) async {
    return await repository.updateProfileFields(
      userId: userId,
      bio: bio,
      city: city,
      country: country,
      photoUrls: photoUrls,
      promptAnswer: promptAnswer,
      promptId: promptId,
    );
  }
}
