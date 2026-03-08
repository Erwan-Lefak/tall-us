import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state.freezed.dart';

/// State for photo upload
@freezed
class UploadState with _$UploadState {
  const factory UploadState.initial() = _Initial;
  const factory UploadState.uploading(double progress) = _Uploading;
  const factory UploadState.success(String url) = _Success;
  const factory UploadState.error(String message) = _Error;
}
