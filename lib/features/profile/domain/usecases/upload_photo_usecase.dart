import 'package:dartz/dartz.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/features/profile/domain/repositories/profile_repository.dart';

/// Use case for uploading profile photos
class UploadPhotoUseCase {
  final ProfileRepository repository;

  UploadPhotoUseCase(this.repository);

  /// Upload a single photo and return its URL
  Future<Either<Failure, String>> call({
    required String userId,
    required String filePath,
    int? position,
  }) async {
    return await repository.uploadPhoto(
      userId: userId,
      filePath: filePath,
      position: position,
    );
  }

  /// Upload multiple photos
  Future<Either<Failure, List<String>>> uploadMultiple({
    required String userId,
    required List<String> filePaths,
  }) async {
    return await repository.uploadMultiplePhotos(
      userId: userId,
      filePaths: filePaths,
    );
  }

  /// Delete a photo
  Future<Either<Failure, void>> deletePhoto({
    required String userId,
    required String photoUrl,
  }) async {
    return await repository.deletePhoto(
      userId: userId,
      photoUrl: photoUrl,
    );
  }

  /// Reorder photos
  Future<Either<Failure, void>> reorderPhotos({
    required String userId,
    required List<String> photoUrls,
  }) async {
    return await repository.reorderPhotos(
      userId: userId,
      photoUrls: photoUrls,
    );
  }
}
