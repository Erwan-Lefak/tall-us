import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

/// Use case for getting user profile
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  /// Get profile by user ID
  Future<Either<Failure, UserProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }

  /// Get current authenticated user's profile
  Future<Either<Failure, UserProfileEntity>> getCurrentUserProfile() async {
    return await repository.getCurrentUserProfile();
  }
}
