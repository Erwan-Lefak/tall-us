import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dartz/dartz.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart' as AppLogger;
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Remote datasource for height verification
class HeightVerificationRemoteDatasource {
  final Databases _databases;
  final Storage _storage;

  HeightVerificationRemoteDatasource({
    required Databases databases,
    required Storage storage,
  })  : _databases = databases,
        _storage = storage;

  /// Get verification status for a user
  Future<Either<Exception, HeightVerificationEntity?>> getVerificationStatus(
    String userId,
  ) async {
    try {
      AppLogger.AppLogger.i('Getting verification status for user: $userId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (documents.documents.isEmpty) {
        AppLogger.AppLogger.i('No verification found for user: $userId');
        return const Right(null);
      }

      // Get the most recent verification
      final latestDoc = documents.documents.first;
      final verification = _documentToVerification(latestDoc);

      AppLogger.AppLogger.i(
          'Verification status found: ${verification.status.name}');
      return Right(verification);
    } on AppwriteException catch (e) {
      AppLogger.AppLogger.e('Failed to get verification status', error: e);
      return Left(e);
    }
  }

  /// Submit a new verification request
  Future<Either<Exception, HeightVerificationEntity>> submitVerification({
    required String userId,
    required int claimedHeightCm,
    required String photoUrl,
  }) async {
    try {
      AppLogger.AppLogger.i('Submitting verification for user: $userId');

      final verificationId = 'verify_${DateTime.now().millisecondsSinceEpoch}';

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
        data: {
          'userId': userId,
          'claimedHeightCm': claimedHeightCm,
          'photoUrl': photoUrl,
          'status': 'submitted',
          'submittedAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          // User can read their own verification
          'read("user:$userId")',
          'update("user:$userId")',
          // Admins can read and update all verifications
          'read("role:admin")',
          'update("role:admin")',
        ],
      );

      final verification = _documentToVerification(document);

      AppLogger.AppLogger.i('Verification submitted successfully');
      return Right(verification);
    } on AppwriteException catch (e) {
      AppLogger.AppLogger.e('Failed to submit verification', error: e);
      return Left(e);
    }
  }

  /// Update verification status
  Future<Either<Exception, HeightVerificationEntity>> updateVerificationStatus({
    required String verificationId,
    required HeightVerificationStatus status,
    String? reviewNote,
    String? rejectionReason,
  }) async {
    try {
      AppLogger.AppLogger.i('Updating verification status: $verificationId');

      final updateData = <String, dynamic>{
        'status': status.name,
        'reviewedAt': DateTime.now().toIso8601String(),
      };

      if (reviewNote != null) {
        updateData['reviewNote'] = reviewNote;
      }

      if (rejectionReason != null) {
        updateData['rejectionReason'] = rejectionReason;
      }

      final document = await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
        data: updateData,
      );

      final verification = _documentToVerification(document);

      AppLogger.AppLogger.i('Verification status updated');
      return Right(verification);
    } on AppwriteException catch (e) {
      AppLogger.AppLogger.e('Failed to update verification status', error: e);
      return Left(e);
    }
  }

  /// Delete verification request
  Future<Either<Exception, void>> deleteVerification(
    String verificationId,
  ) async {
    try {
      AppLogger.AppLogger.i('Deleting verification: $verificationId');

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
      );

      AppLogger.AppLogger.i('Verification deleted successfully');
      return const Right(null);
    } on AppwriteException catch (e) {
      AppLogger.AppLogger.e('Failed to delete verification', error: e);
      return Left(e);
    }
  }

  /// Get all pending verifications
  Future<Either<Exception, List<HeightVerificationEntity>>>
      getPendingVerifications() async {
    try {
      AppLogger.AppLogger.i('Getting pending verifications');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        queries: [
          Query.equal('status', 'submitted'),
          Query.equal('status', 'underReview'),
        ],
      );

      final verifications =
          documents.documents.map(_documentToVerification).toList();

      AppLogger.AppLogger.i(
          'Found ${verifications.length} pending verifications');
      return Right(verifications);
    } on AppwriteException catch (e) {
      AppLogger.AppLogger.e('Failed to get pending verifications', error: e);
      return Left(e);
    }
  }

  /// Convert Appwrite document to HeightVerificationEntity
  HeightVerificationEntity _documentToVerification(Document document) {
    final data = document.data;

    return HeightVerificationEntity(
      id: document.$id,
      userId: data['userId'] as String,
      claimedHeightCm: data['claimedHeightCm'] as int,
      photoUrl: data['photoUrl'] as String?,
      status: HeightVerificationStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => HeightVerificationStatus.pending,
      ),
      submittedAt: data['submittedAt'] != null
          ? DateTime.parse(data['submittedAt'] as String)
          : null,
      reviewedAt: data['reviewedAt'] != null
          ? DateTime.parse(data['reviewedAt'] as String)
          : null,
      reviewNote: data['reviewNote'] as String?,
      rejectionReason: data['rejectionReason'] as String?,
    );
  }
}
