import 'package:equatable/equatable.dart';

/// Entity representing user's discovery/matching preferences
class DiscoveryPreferencesEntity extends Equatable {
  final String userId;
  final int minAge;
  final int maxAge;
  final int minHeightCm;
  final int maxHeightCm;
  final List<String> preferredGenders;
  final int maxDistanceKm;
  final String city;
  final String country;
  final DateTime? lastUpdated;

  const DiscoveryPreferencesEntity({
    required this.userId,
    this.minAge = 18,
    this.maxAge = 100,
    this.minHeightCm = 140,
    this.maxHeightCm = 220,
    this.preferredGenders = const [],
    this.maxDistanceKm = 50,
    required this.city,
    required this.country,
    this.lastUpdated,
  });

  /// Check if age matches preference
  bool matchesAge(int age) {
    return age >= minAge && age <= maxAge;
  }

  /// Check if height matches preference
  bool matchesHeight(int heightCm) {
    return heightCm >= minHeightCm && heightCm <= maxHeightCm;
  }

  /// Check if gender matches preference
  bool matchesGender(String gender) {
    return preferredGenders.contains(gender);
  }

  /// Check if distance matches preference
  bool matchesDistance(int distanceKm) {
    return distanceKm <= maxDistanceKm;
  }

  /// Get default preferences based on user's age and height
  factory DiscoveryPreferencesEntity.defaults({
    required String userId,
    required int userAge,
    required int userHeight,
    required String userGender,
    required String city,
    required String country,
  }) {
    // Calculate reasonable defaults
    final minAge = (userAge - 5).clamp(18, 100);
    final maxAge = (userAge + 5).clamp(18, 100);

    // Height preferences: people typically prefer someone within 10cm
    final minHeightCm = userHeight - 10;
    final maxHeightCm = userHeight + 10;

    // Gender preference: typically prefer opposite gender
    final preferredGenders = userGender == 'homme' ? ['femme'] : ['homme'];

    return DiscoveryPreferencesEntity(
      userId: userId,
      minAge: minAge,
      maxAge: maxAge,
      minHeightCm: minHeightCm,
      maxHeightCm: maxHeightCm,
      preferredGenders: preferredGenders,
      maxDistanceKm: 50,
      city: city,
      country: country,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        userId,
        minAge,
        maxAge,
        minHeightCm,
        maxHeightCm,
        preferredGenders,
        maxDistanceKm,
        city,
        country,
        lastUpdated,
      ];

  DiscoveryPreferencesEntity copyWith({
    String? userId,
    int? minAge,
    int? maxAge,
    int? minHeightCm,
    int? maxHeightCm,
    List<String>? preferredGenders,
    int? maxDistanceKm,
    String? city,
    String? country,
    DateTime? lastUpdated,
  }) {
    return DiscoveryPreferencesEntity(
      userId: userId ?? this.userId,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minHeightCm: minHeightCm ?? this.minHeightCm,
      maxHeightCm: maxHeightCm ?? this.maxHeightCm,
      preferredGenders: preferredGenders ?? this.preferredGenders,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      city: city ?? this.city,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'minAge': minAge,
      'maxAge': maxAge,
      'minHeightCm': minHeightCm,
      'maxHeightCm': maxHeightCm,
      'preferredGenders': preferredGenders,
      'maxDistanceKm': maxDistanceKm,
      'city': city,
      'country': country,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create from Map
  factory DiscoveryPreferencesEntity.fromMap(Map<String, dynamic> map) {
    return DiscoveryPreferencesEntity(
      userId: map['userId'] as String,
      minAge: map['minAge'] as int? ?? 18,
      maxAge: map['maxAge'] as int? ?? 100,
      minHeightCm: map['minHeightCm'] as int? ?? 140,
      maxHeightCm: map['maxHeightCm'] as int? ?? 220,
      preferredGenders: map['preferredGenders'] != null
          ? List<String>.from(map['preferredGenders'] as List)
          : [],
      maxDistanceKm: map['maxDistanceKm'] as int? ?? 50,
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'] as String)
          : null,
    );
  }
}
