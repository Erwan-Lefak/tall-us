import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Model for UserProfile with JSON serialization
class UserProfileModel {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String gender;
  final String? sexualOrientation;
  final int heightCm;
  final String birthday;
  final String city;
  final String country;
  final List<String> photoUrls;
  final String? promptAnswer;
  final String? promptId;
  final bool heightVerified;
  final int? age;

  const UserProfileModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    required this.gender,
    this.sexualOrientation,
    required this.heightCm,
    required this.birthday,
    required this.city,
    required this.country,
    this.photoUrls = const [],
    this.promptAnswer,
    this.promptId,
    this.heightVerified = false,
    this.age,
  });

  /// Create from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['\$id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      displayName: json['display_name'] ?? json['displayName'] ?? '',
      bio: json['bio'],
      gender: json['gender'] ?? '',
      sexualOrientation:
          json['sexual_orientation'] ?? json['sexualOrientation'],
      heightCm: json['height_cm'] ?? json['heightCm'] ?? 0,
      birthday: json['birthday'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      photoUrls: json['photo_urls'] != null
          ? List<String>.from(json['photo_urls'])
          : (json['photoUrls'] != null
              ? List<String>.from(json['photoUrls'])
              : []),
      promptAnswer: json['prompt_answer'] ?? json['promptAnswer'],
      promptId: json['prompt_id'] ?? json['promptId'],
      heightVerified:
          json['height_verified'] ?? json['heightVerified'] ?? false,
      age: json['age'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'display_name': displayName,
      'bio': bio,
      'gender': gender,
      if (sexualOrientation != null) 'sexual_orientation': sexualOrientation,
      'height_cm': heightCm,
      'birthday': birthday,
      'city': city,
      'country': country,
      'photo_urls': photoUrls,
      if (promptAnswer != null) 'prompt_answer': promptAnswer,
      if (promptId != null) 'prompt_id': promptId,
      'height_verified': heightVerified,
      if (age != null) 'age': age,
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
      sexualOrientation: sexualOrientation,
      heightCm: heightCm,
      birthday: DateTime.parse(birthday),
      city: city,
      country: country,
      photoUrls: photoUrls,
      // TODO: Convert prompts from JSON when stored in DB
      prompts: const [],
      heightVerified: heightVerified,
      age: age,
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
      sexualOrientation: entity.sexualOrientation,
      heightCm: entity.heightCm,
      birthday: entity.birthday.toIso8601String(),
      city: entity.city,
      country: entity.country,
      photoUrls: entity.photoUrls,
      // TODO: Serialize prompts to JSON when storing in DB
      heightVerified: entity.heightVerified,
      age: entity.age,
    );
  }
}
