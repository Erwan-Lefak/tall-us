import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// User Entity
///
/// Core business object representing a user in the system
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required bool emailVerified,
    required UserRole role,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    ProfileEntity? profile,
  }) = _UserEntity;

  const UserEntity._();

  // Getters
  bool get isDeleted => deletedAt != null;
  bool get isPremium => role == UserRole.premium;
  bool get isAdmin => role == UserRole.admin;
  bool get isFree => role == UserRole.free;
}

/// User Role Enum
@freezed
class UserRole with _$UserRole {
  const factory UserRole.free() = _Free;
  const factory UserRole.premium() = _Premium;
  const factory UserRole.admin() = _Admin;

  const UserRole._();

  factory UserRole.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'free':
        return const UserRole.free();
      case 'premium':
        return const UserRole.premium();
      case 'admin':
        return const UserRole.admin();
      default:
        throw ArgumentError('Invalid role: $value');
    }
  }
}

/// Profile Entity (simplified, will be in profile feature)
@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String id,
    required String userId,
    required String displayName,
    required String gender,
    required int heightCm,
    required DateTime birthday,
    required String countryCode,
    required String city,
    String? bio,
    String? occupation,
  }) = _ProfileEntity;

  const ProfileEntity._();

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['\$id'] ?? json['id'],
      userId: json['user_id'],
      displayName: json['display_name'],
      gender: json['gender'],
      heightCm: json['height_cm'],
      birthday: DateTime.parse(json['birthday']),
      countryCode: json['country_code'],
      city: json['city'],
      bio: json['bio'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'display_name': displayName,
      'gender': gender,
      'height_cm': heightCm,
      'birthday': birthday.toIso8601String(),
      'country_code': countryCode,
      'city': city,
      if (bio != null) 'bio': bio,
      if (occupation != null) 'occupation': occupation,
    };
  }
}
