import 'package:equatable/equatable.dart';

/// Entity representing a complete user profile
/// Matches Appwrite `profiles` collection schema
class UserProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String gender;
  final int heightCm;
  final DateTime birthday;
  final String city;
  final String country; // Maps to countryCode in Appwrite
  final List<String> photoUrls; // Maps to photos[] in Appwrite
  final String? avatarUrl;
  final String lookingFor;
  final List<String> hobbies;
  final bool onboardingCompleted;
  // Kept for backward compat with swipe/verification features (not in Appwrite schema)
  final bool heightVerified;
  final String? spotifyPlaylistUrl;
  final String? promptAnswer;

  const UserProfileEntity({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    required this.gender,
    required this.heightCm,
    required this.birthday,
    required this.city,
    required this.country,
    this.photoUrls = const [],
    this.avatarUrl,
    this.lookingFor = 'relationship',
    this.hobbies = const [],
    this.onboardingCompleted = false,
    this.heightVerified = false,
    this.spotifyPlaylistUrl,
    this.promptAnswer,
  });

  /// Calculate age from birthday
  int calculateAge() {
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
    return onboardingCompleted ||
        (bio != null && bio!.isNotEmpty && photoUrls.isNotEmpty);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        bio,
        gender,
        heightCm,
        birthday,
        city,
        country,
        photoUrls,
        avatarUrl,
        lookingFor,
        hobbies,
        onboardingCompleted,
        heightVerified,
        spotifyPlaylistUrl,
        promptAnswer,
      ];

  UserProfileEntity copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? bio,
    String? gender,
    int? heightCm,
    DateTime? birthday,
    String? city,
    String? country,
    List<String>? photoUrls,
    String? avatarUrl,
    String? lookingFor,
    List<String>? hobbies,
    bool? onboardingCompleted,
    bool? heightVerified,
    String? spotifyPlaylistUrl,
    String? promptAnswer,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      birthday: birthday ?? this.birthday,
      city: city ?? this.city,
      country: country ?? this.country,
      photoUrls: photoUrls ?? this.photoUrls,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lookingFor: lookingFor ?? this.lookingFor,
      hobbies: hobbies ?? this.hobbies,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      heightVerified: heightVerified ?? this.heightVerified,
      spotifyPlaylistUrl: spotifyPlaylistUrl ?? this.spotifyPlaylistUrl,
      promptAnswer: promptAnswer ?? this.promptAnswer,
    );
  }

  /// Create from Map (for Appwrite documents)
  factory UserProfileEntity.fromMap(Map<String, dynamic> map) {
    // Parse photos
    List<String> photoUrls = [];
    if (map['photos'] is List) {
      photoUrls = List<String>.from(map['photos'] as List);
    } else if (map['photoUrls'] is List) {
      photoUrls = List<String>.from(map['photoUrls'] as List);
    }

    // Parse birthday
    DateTime birthday;
    if (map['birthday'] is String) {
      birthday = DateTime.parse(map['birthday'] as String);
    } else if (map['birthday'] is DateTime) {
      birthday = map['birthday'] as DateTime;
    } else {
      birthday = DateTime.now();
    }

    return UserProfileEntity(
      id: map['\$id'] ?? map['id'] ?? '',
      userId: map['userId'] ?? '',
      displayName: map['displayName'] ?? map['display_name'] ?? '',
      bio: map['bio'],
      gender: map['gender'] ?? 'other',
      heightCm: map['height'] ?? map['heightCm'] ?? map['height_cm'] ?? 0,
      birthday: birthday,
      city: map['city'] ?? '',
      country: map['countryCode'] ?? map['country_code'] ?? map['country'] ?? '',
      photoUrls: photoUrls,
      avatarUrl: map['avatarUrl'] ?? map['avatar_url'],
      lookingFor: map['lookingFor'] ?? map['looking_for'] ?? 'relationship',
      hobbies: map['hobbies'] is List
          ? List<String>.from(map['hobbies'] as List)
          : const [],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
      heightVerified: map['heightVerified'] ?? map['height_verified'] ?? false,
      spotifyPlaylistUrl: map['spotifyPlaylistUrl'],
      promptAnswer: map['promptAnswer'] ?? map['prompt_answer'],
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
      'height': heightCm,
      'birthday': birthday.toIso8601String(),
      'city': city,
      'countryCode': country,
      'photos': photoUrls,
      'avatarUrl': avatarUrl,
      'lookingFor': lookingFor,
      'hobbies': hobbies,
      'onboardingCompleted': onboardingCompleted,
      'heightVerified': heightVerified,
      if (spotifyPlaylistUrl != null) 'spotifyPlaylistUrl': spotifyPlaylistUrl,
    };
  }
}
