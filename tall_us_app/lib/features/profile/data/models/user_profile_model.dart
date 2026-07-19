import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Model for UserProfile with JSON serialization
/// Matches Appwrite `profiles` collection schema exactly
class UserProfileModel {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String gender;
  final int heightCm;
  final String birthday;
  final String city;
  final String countryCode;
  final List<String> photos;
  final String? avatarUrl;
  final String lookingFor;
  final List<String> hobbies;
  final bool onboardingCompleted;
  final bool heightVerified;
  final String? spotifyPlaylistUrl;

  const UserProfileModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    required this.gender,
    required this.heightCm,
    required this.birthday,
    required this.city,
    required this.countryCode,
    this.photos = const [],
    this.avatarUrl,
    required this.lookingFor,
    this.hobbies = const [],
    this.onboardingCompleted = false,
    this.heightVerified = false,
    this.spotifyPlaylistUrl,
  });

  /// Create from JSON (Appwrite document data)
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? json['display_name'] ?? '',
      bio: json['bio'],
      gender: json['gender'] ?? '',
      heightCm: json['height'] ?? json['height_cm'] ?? json['heightCm'] ?? 0,
      birthday: json['birthday'] ?? '',
      city: json['city'] ?? '',
      countryCode: json['countryCode'] ?? json['country_code'] ?? json['country'] ?? '',
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : (json['photo_urls'] != null ? List<String>.from(json['photo_urls']) : []),
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      lookingFor: json['lookingFor'] ?? json['looking_for'] ?? 'relationship',
      hobbies: json['hobbies'] is List
          ? List<String>.from(json['hobbies'])
          : const [],
      onboardingCompleted: json['onboardingCompleted'] ?? false,
      heightVerified: json['heightVerified'] ?? false,
      spotifyPlaylistUrl: json['spotifyPlaylistUrl'],
    );
  }

  /// Convert to JSON (keys matching Appwrite collection schema exactly)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      'gender': gender,
      'height': heightCm,
      'birthday': birthday,
      'city': city,
      'countryCode': countryCode,
      if (photos.isNotEmpty) 'photos': photos,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'lookingFor': lookingFor,
      'hobbies': hobbies,
      'onboardingCompleted': onboardingCompleted,
      'heightVerified': heightVerified,
      if (spotifyPlaylistUrl != null) 'spotifyPlaylistUrl': spotifyPlaylistUrl,
    };
  }

  /// Convert to Entity
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      userId: userId,
      displayName: displayName,
      bio: bio,
      gender: gender,
      heightCm: heightCm,
      birthday: DateTime.tryParse(birthday) ?? DateTime(2000, 1, 1),
      city: city,
      country: countryCode,
      photoUrls: photos,
      avatarUrl: avatarUrl,
      lookingFor: lookingFor,
      hobbies: hobbies,
      onboardingCompleted: onboardingCompleted,
      heightVerified: heightVerified,
      spotifyPlaylistUrl: spotifyPlaylistUrl,
    );
  }

  /// Create from Entity
  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      id: entity.id,
      userId: entity.userId,
      displayName: entity.displayName,
      bio: entity.bio,
      gender: entity.gender,
      heightCm: entity.heightCm,
      birthday: entity.birthday.toIso8601String(),
      city: entity.city,
      countryCode: entity.country,
      photos: entity.photoUrls,
      avatarUrl: entity.avatarUrl,
      lookingFor: entity.lookingFor,
      hobbies: entity.hobbies,
      onboardingCompleted: entity.onboardingCompleted,
      heightVerified: entity.heightVerified,
      spotifyPlaylistUrl: entity.spotifyPlaylistUrl,
    );
  }
}
