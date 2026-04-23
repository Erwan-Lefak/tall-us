import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_entities.freezed.dart';
part 'social_entities.g.dart';

/// Social Event entity
@freezed
class SocialEvent with _$SocialEvent {
  const factory SocialEvent({
    required String id,
    required String title,
    required String description,
    required String location,
    required DateTime dateTime,
    @Default([]) List<String> attendees,
    required int maxAttendees,
    required String hostId,
    @Default('') String imageUrl,
    DateTime? createdAt,
  }) = _SocialEvent;

  factory SocialEvent.fromJson(Map<String, dynamic> json) =>
      _$SocialEventFromJson(json);
}

/// Social Group entity
@freezed
class SocialGroup with _$SocialGroup {
  const factory SocialGroup({
    required String id,
    required String name,
    required String description,
    required String category,
    @Default([]) List<String> members,
    required int maxMembers,
    required String hostId,
    @Default('') String imageUrl,
    DateTime? createdAt,
  }) = _SocialGroup;

  factory SocialGroup.fromJson(Map<String, dynamic> json) =>
      _$SocialGroupFromJson(json);
}

/// Photo metadata entity
@freezed
class PhotoMetadata with _$PhotoMetadata {
  const factory PhotoMetadata({
    required String photoId,
    required String url,
    String? caption,
    required int displayOrder,
    @Default(0) int likeCount,
    @Default(0) int viewCount,
    @Default(0) int matchCount,
    @Default(50.0) double smartScore,
    DateTime? lastScoreUpdate,
    bool? isVerified,
  }) = _PhotoMetadata;

  factory PhotoMetadata.fromJson(Map<String, dynamic> json) =>
      _$PhotoMetadataFromJson(json);
}

/// User extended profile with new fields
@freezed
class UserProfileExtended with _$UserProfileExtended {
  const factory UserProfileExtended({
    required String userId,
    // Job & Education
    String? jobTitle,
    String? company,
    String? school,
    String? degree,
    // Lifestyle
    String? drinkingPreference,
    String? smokingPreference,
    String? workoutFrequency,
    // Identity
    @Default([]) List<String> genders,
    String? pronouns,
    String? zodiacSign,
    // Photos metadata
    @Default([]) List<PhotoMetadata> photos,
    // Social connections
    @Default([]) List<String> friendIds,
    DateTime? updatedAt,
  }) = _UserProfileExtended;

  factory UserProfileExtended.fromJson(Map<String, dynamic> json) =>
      _$UserProfileExtendedFromJson(json);
}

/// Top Pick score entity
@freezed
class TopPickScore with _$TopPickScore {
  const factory TopPickScore({
    required String profileId,
    required double compatibilityScore,
    @Default([]) List<String> matchReasons,
    required DateTime calculatedAt,
  }) = _TopPickScore;

  factory TopPickScore.fromJson(Map<String, dynamic> json) =>
      _$TopPickScoreFromJson(json);
}

/// Like record entity
@freezed
class LikeRecord with _$LikeRecord {
  const factory LikeRecord({
    required String id,
    required String fromUserId,
    required String toUserId,
    required DateTime likedAt,
    @Default(false) bool isSeen,
  }) = _LikeRecord;

  factory LikeRecord.fromJson(Map<String, dynamic> json) =>
      _$LikeRecordFromJson(json);
}
