import 'package:dartz/dartz.dart';
import 'package:tall_us/core/error/failures.dart';
import 'package:tall_us/core/utils/logger.dart' as AppLogger;
import 'package:tall_us/features/verification/data/datasources/height_verification_remote_datasource.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';
import 'package:tall_us/features/verification/domain/repositories/height_verification_repository.dart';

/// Height verification repository implementation
class HeightVerificationRepositoryImpl implements HeightVerificationRepository {
  final HeightVerificationRemoteDatasource remoteDatasource;

  HeightVerificationRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, HeightVerificationEntity?>> getVerificationStatus(
    String userId,
  ) async {
    try {
      final result = await remoteDatasource.getVerificationStatus(userId);
      return result.fold(
        (error) => Left(ServerFailure(error.toString())),
        (verification) => Right(verification),
      );
    } catch (e) {
      AppLogger.AppLogger.e('Error getting verification status', error: e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeightVerificationEntity>> submitVerification({
    required String userId,
    required int claimedHeightCm,
    required String photoUrl,
  }) async {
    try {
      final result = await remoteDatasource.submitVerification(
        userId: userId,
        claimedHeightCm: claimedHeightCm,
        photoUrl: photoUrl,
      );
      return result.fold(
        (error) => Left(ServerFailure(error.toString())),
        (verification) => Right(verification),
      );
    } catch (e) {
      AppLogger.AppLogger.e('Error submitting verification', error: e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HeightVerificationEntity>> updateVerificationStatus({
    required String verificationId,
    required HeightVerificationStatus status,
    String? reviewNote,
    String? rejectionReason,
  }) async {
    try {
      final result = await remoteDatasource.updateVerificationStatus(
        verificationId: verificationId,
        status: status,
        reviewNote: reviewNote,
        rejectionReason: rejectionReason,
      );
      return result.fold(
        (error) => Left(ServerFailure(error.toString())),
        (verification) => Right(verification),
      );
    } catch (e) {
      AppLogger.AppLogger.e('Error updating verification status', error: e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVerification(
    String verificationId,
  ) async {
    try {
      final result = await remoteDatasource.deleteVerification(verificationId);
      return result.fold(
        (error) => Left(ServerFailure(error.toString())),
        (_) => const Right(null),
      );
    } catch (e) {
      AppLogger.AppLogger.e('Error deleting verification', error: e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HeightVerificationEntity>>>
      getPendingVerifications() async {
    try {
      final result = await remoteDatasource.getPendingVerifications();
      return result.fold(
        (error) => Left(ServerFailure(error.toString())),
        (verifications) => Right(verifications),
      );
    } catch (e) {
      AppLogger.AppLogger.e('Error getting pending verifications', error: e);
      return Left(UnknownFailure(e.toString()));
    }
  }
}
