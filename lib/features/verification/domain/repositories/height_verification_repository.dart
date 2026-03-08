import 'package:dartz/dartz.dart';
import 'package:tall_us/core/error/failures.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Height verification repository interface
abstract class HeightVerificationRepository {
  /// Get current verification status for a user
  Future<Either<Failure, HeightVerificationEntity?>> getVerificationStatus(
    String userId,
  );

  /// Submit a new verification request
  Future<Either<Failure, HeightVerificationEntity>> submitVerification({
    required String userId,
    required int claimedHeightCm,
    required String photoUrl,
  });

  /// Update verification status (admin only)
  Future<Either<Failure, HeightVerificationEntity>> updateVerificationStatus({
    required String verificationId,
    required HeightVerificationStatus status,
    String? reviewNote,
    String? rejectionReason,
  });

  /// Delete verification request
  Future<Either<Failure, void>> deleteVerification(
    String verificationId,
  );

  /// Get all pending verifications (admin only)
  Future<Either<Failure, List<HeightVerificationEntity>>>
      getPendingVerifications();
}
