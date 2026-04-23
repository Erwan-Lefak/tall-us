import 'package:equatable/equatable.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';

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

  // Prompts system (NEW - replaces single prompt)
  final List<UserPrompt> prompts;

  // Work & Education (NEW)
  final String? jobTitle;
  final String? company;
  final String? school;

  // Social connections (NEW)
  final String? instagramUsername;
  final List<String>? topArtists; // Spotify integration
  final String? anthemSongId;

  // Verification (NEW)
  final bool heightVerified;
  final bool idVerified;

  // Gender & Orientation (ENHANCED)
  final String? genderIdentity; // Homme, Femme, Non-binaire, etc.
  final List<String>? orientations; // Hétéro, Gay, Bi, etc.

  // Stats (NEW)
  final int? age;
  final DateTime? createdAt;
  final int? profileViews;

  // Interests (NEW)
  final List<String> interests;

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
    this.prompts = const [],
    this.jobTitle,
    this.company,
    this.school,
    this.instagramUsername,
    this.topArtists,
    this.anthemSongId,
    this.heightVerified = false,
    this.idVerified = false,
    this.genderIdentity,
    this.orientations,
    this.age,
    this.createdAt,
    this.profileViews,
    this.interests = const [],
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
        prompts.isNotEmpty;
  }

  /// Check completion percentage
  double getCompletionPercentage() {
    int completed = 0;
    int total = 10;

    if (bio != null && bio!.isNotEmpty) completed++;
    if (photoUrls.length >= 3) completed++;
    if (prompts.isNotEmpty) completed++;
    if (jobTitle != null) completed++;
    if (company != null) completed++;
    if (school != null) completed++;
    if (interests.isNotEmpty) completed++;
    if (instagramUsername != null) completed++;
    if (heightVerified) completed++;
    if (idVerified) completed++;

    return completed / total;
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
        prompts,
        jobTitle,
        company,
        school,
        instagramUsername,
        topArtists,
        anthemSongId,
        heightVerified,
        idVerified,
        genderIdentity,
        orientations,
        age,
        createdAt,
        profileViews,
        interests,
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
    List<UserPrompt>? prompts,
    String? jobTitle,
    String? company,
    String? school,
    String? instagramUsername,
    List<String>? topArtists,
    String? anthemSongId,
    bool? heightVerified,
    bool? idVerified,
    String? genderIdentity,
    List<String>? orientations,
    int? age,
    DateTime? createdAt,
    int? profileViews,
    List<String>? interests,
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
      prompts: prompts ?? this.prompts,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      school: school ?? this.school,
      instagramUsername: instagramUsername ?? this.instagramUsername,
      topArtists: topArtists ?? this.topArtists,
      anthemSongId: anthemSongId ?? this.anthemSongId,
      heightVerified: heightVerified ?? this.heightVerified,
      idVerified: idVerified ?? this.idVerified,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      orientations: orientations ?? this.orientations,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      profileViews: profileViews ?? this.profileViews,
      interests: interests ?? this.interests,
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

    // Parse prompts (NEW)
    List<UserPrompt> prompts = [];
    if (map['prompts'] != null && map['prompts'] is List) {
      prompts = (map['prompts'] as List)
          .map((p) => UserPrompt(
                promptId: p['promptId'] ?? '',
                promptText: p['promptText'] ?? '',
                answer: p['answer'] ?? '',
                displayOrder: p['displayOrder'] ?? 0,
              ))
          .toList();
    }

    // Parse interests (NEW)
    List<String> interests = [];
    if (map['interests'] != null && map['interests'] is List) {
      interests = List<String>.from(map['interests'] as List);
    }

    // Parse orientations (NEW)
    List<String>? orientations;
    if (map['orientations'] != null && map['orientations'] is List) {
      orientations = List<String>.from(map['orientations'] as List);
    }

    // Parse topArtists (NEW)
    List<String>? topArtists;
    if (map['topArtists'] != null && map['topArtists'] is List) {
      topArtists = List<String>.from(map['topArtists'] as List);
    }

    // Parse createdAt (NEW)
    DateTime? createdAt;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is String) {
        createdAt = DateTime.parse(map['createdAt'] as String);
      } else if (map['createdAt'] is DateTime) {
        createdAt = map['createdAt'] as DateTime;
      }
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
      prompts: prompts,
      jobTitle: map['jobTitle'] ?? map['job_title'],
      company: map['company'],
      school: map['school'],
      instagramUsername: map['instagramUsername'] ?? map['instagram_username'],
      topArtists: topArtists,
      anthemSongId: map['anthemSongId'] ?? map['anthem_song_id'],
      heightVerified: map['heightVerified'] ?? map['height_verified'] ?? false,
      idVerified: map['idVerified'] ?? map['id_verified'] ?? false,
      genderIdentity: map['genderIdentity'] ?? map['gender_identity'],
      orientations: orientations,
      age: map['age'],
      createdAt: createdAt,
      profileViews: map['profileViews'] ?? map['profile_views'],
      interests: interests,
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
      'prompts': prompts
          .map((p) => {
                'promptId': p.promptId,
                'promptText': p.promptText,
                'answer': p.answer,
                'displayOrder': p.displayOrder,
              })
          .toList(),
      'jobTitle': jobTitle,
      'company': company,
      'school': school,
      'instagramUsername': instagramUsername,
      'topArtists': topArtists,
      'anthemSongId': anthemSongId,
      'heightVerified': heightVerified,
      'idVerified': idVerified,
      'genderIdentity': genderIdentity,
      'orientations': orientations,
      'age': age,
      'createdAt': createdAt?.toIso8601String(),
      'profileViews': profileViews,
      'interests': interests,
    };
  }
}
