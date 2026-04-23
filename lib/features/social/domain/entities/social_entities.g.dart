// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialEventImpl _$$SocialEventImplFromJson(Map<String, dynamic> json) =>
    _$SocialEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      attendees: (json['attendees'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxAttendees: (json['maxAttendees'] as num).toInt(),
      hostId: json['hostId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SocialEventImplToJson(_$SocialEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'dateTime': instance.dateTime.toIso8601String(),
      'attendees': instance.attendees,
      'maxAttendees': instance.maxAttendees,
      'hostId': instance.hostId,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$SocialGroupImpl _$$SocialGroupImplFromJson(Map<String, dynamic> json) =>
    _$SocialGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxMembers: (json['maxMembers'] as num).toInt(),
      hostId: json['hostId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SocialGroupImplToJson(_$SocialGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'members': instance.members,
      'maxMembers': instance.maxMembers,
      'hostId': instance.hostId,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$PhotoMetadataImpl _$$PhotoMetadataImplFromJson(Map<String, dynamic> json) =>
    _$PhotoMetadataImpl(
      photoId: json['photoId'] as String,
      url: json['url'] as String,
      caption: json['caption'] as String?,
      displayOrder: (json['displayOrder'] as num).toInt(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      matchCount: (json['matchCount'] as num?)?.toInt() ?? 0,
      smartScore: (json['smartScore'] as num?)?.toDouble() ?? 50.0,
      lastScoreUpdate: json['lastScoreUpdate'] == null
          ? null
          : DateTime.parse(json['lastScoreUpdate'] as String),
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$$PhotoMetadataImplToJson(_$PhotoMetadataImpl instance) =>
    <String, dynamic>{
      'photoId': instance.photoId,
      'url': instance.url,
      'caption': instance.caption,
      'displayOrder': instance.displayOrder,
      'likeCount': instance.likeCount,
      'viewCount': instance.viewCount,
      'matchCount': instance.matchCount,
      'smartScore': instance.smartScore,
      'lastScoreUpdate': instance.lastScoreUpdate?.toIso8601String(),
      'isVerified': instance.isVerified,
    };

_$UserProfileExtendedImpl _$$UserProfileExtendedImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileExtendedImpl(
      userId: json['userId'] as String,
      jobTitle: json['jobTitle'] as String?,
      company: json['company'] as String?,
      school: json['school'] as String?,
      degree: json['degree'] as String?,
      drinkingPreference: json['drinkingPreference'] as String?,
      smokingPreference: json['smokingPreference'] as String?,
      workoutFrequency: json['workoutFrequency'] as String?,
      genders: (json['genders'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pronouns: json['pronouns'] as String?,
      zodiacSign: json['zodiacSign'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoMetadata.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      friendIds: (json['friendIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileExtendedImplToJson(
        _$UserProfileExtendedImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'jobTitle': instance.jobTitle,
      'company': instance.company,
      'school': instance.school,
      'degree': instance.degree,
      'drinkingPreference': instance.drinkingPreference,
      'smokingPreference': instance.smokingPreference,
      'workoutFrequency': instance.workoutFrequency,
      'genders': instance.genders,
      'pronouns': instance.pronouns,
      'zodiacSign': instance.zodiacSign,
      'photos': instance.photos,
      'friendIds': instance.friendIds,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TopPickScoreImpl _$$TopPickScoreImplFromJson(Map<String, dynamic> json) =>
    _$TopPickScoreImpl(
      profileId: json['profileId'] as String,
      compatibilityScore: (json['compatibilityScore'] as num).toDouble(),
      matchReasons: (json['matchReasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$TopPickScoreImplToJson(_$TopPickScoreImpl instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'compatibilityScore': instance.compatibilityScore,
      'matchReasons': instance.matchReasons,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };

_$LikeRecordImpl _$$LikeRecordImplFromJson(Map<String, dynamic> json) =>
    _$LikeRecordImpl(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      likedAt: DateTime.parse(json['likedAt'] as String),
      isSeen: json['isSeen'] as bool? ?? false,
    );

Map<String, dynamic> _$$LikeRecordImplToJson(_$LikeRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'likedAt': instance.likedAt.toIso8601String(),
      'isSeen': instance.isSeen,
    };
