import 'package:equatable/equatable.dart';

/// Entity representing a complete user profile
class UserProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String gender;
  final String? sexualOrientation;
  final int heightCm;
  final DateTime birthday;
  final String city;
  final String country;
  final List<String> photoUrls;
  final String? promptAnswer;
  final String? promptId;
  final bool heightVerified;
  final int? age;

  const UserProfileEntity({
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

  /// Calculate age from birthday
  int calculateAge() {
    if (age != null) return age!;
    final today = DateTime.now();
    int calculatedAge = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  /// Get height in feet and inches
  String getHeightInFeetInches() {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet'$inches\"";
  }

  /// Check if profile is complete (has minimum required info)
  bool isComplete() {
    return bio != null &&
        bio!.isNotEmpty &&
        photoUrls.isNotEmpty &&
        promptAnswer != null &&
        promptAnswer!.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        bio,
        gender,
        sexualOrientation,
        heightCm,
        birthday,
        city,
        country,
        photoUrls,
        promptAnswer,
        promptId,
        heightVerified,
        age,
      ];

  UserProfileEntity copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? bio,
    String? gender,
    String? sexualOrientation,
    int? heightCm,
    DateTime? birthday,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? promptAnswer,
    String? promptId,
    bool? heightVerified,
    int? age,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      sexualOrientation: sexualOrientation ?? this.sexualOrientation,
      heightCm: heightCm ?? this.heightCm,
      birthday: birthday ?? this.birthday,
      city: city ?? this.city,
      country: country ?? this.country,
      photoUrls: photoUrls ?? this.photoUrls,
      promptAnswer: promptAnswer ?? this.promptAnswer,
      promptId: promptId ?? this.promptId,
      heightVerified: heightVerified ?? this.heightVerified,
      age: age ?? this.age,
    );
  }

  /// Create from Map (for Appwrite documents)
  factory UserProfileEntity.fromMap(Map<String, dynamic> map) {
    // Parse photoUrls
    List<String> photoUrls = [];
    if (map['photoUrls'] != null) {
      if (map['photoUrls'] is List) {
        photoUrls = List<String>.from(map['photoUrls'] as List);
      }
    }

    // Parse birthday
    DateTime birthday;
    if (map['birthday'] is String) {
      birthday = DateTime.parse(map['birthday'] as String);
    } else if (map['birthday'] is DateTime) {
      birthday = map['birthday'] as DateTime;
    } else {
      birthday = DateTime.now(); // Fallback
    }

    return UserProfileEntity(
      id: map['\$id'] ?? map['id'] ?? '',
      userId: map['userId'] ?? map['user_id'] ?? '',
      displayName: map['displayName'] ?? map['display_name'] ?? '',
      bio: map['bio'],
      gender: map['gender'] ?? 'other',
      sexualOrientation: map['sexualOrientation'] ?? map['sexual_orientation'],
      heightCm: map['heightCm'] ?? map['height_cm'] ?? 0,
      birthday: birthday,
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      photoUrls: photoUrls,
      promptAnswer: map['promptAnswer'] ?? map['prompt_answer'],
      promptId: map['promptId'] ?? map['prompt_id'],
      heightVerified: map['heightVerified'] ?? map['height_verified'] ?? false,
      age: map['age'],
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'gender': gender,
      'sexualOrientation': sexualOrientation,
      'heightCm': heightCm,
      'birthday': birthday.toIso8601String(),
      'city': city,
      'country': country,
      'photoUrls': photoUrls,
      'promptAnswer': promptAnswer,
      'promptId': promptId,
      'heightVerified': heightVerified,
      'age': age,
    };
  }
}
