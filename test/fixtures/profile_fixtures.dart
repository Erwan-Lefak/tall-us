import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';

/// Test fixtures for user profiles
///
/// Provides reusable test data for profiles across all tests
class ProfileFixtures {
  /// Default test profile with all fields populated
  static UserProfileEntity get defaultProfile {
    final now = DateTime.now();
    return UserProfileEntity(
      id: 'profile_test_001',
      userId: 'user_test_001',
      displayName: 'Jean Dupont',
      bio: 'Amateur de randonnée et de bonne cuisine 🥾',
      gender: 'homme',
      sexualOrientation: 'hétéro',
      heightCm: 185,
      birthday: DateTime(1990, 5, 15),
      city: 'Paris',
      country: 'France',
      photoUrls: [
        'https://example.com/photos/jean1.jpg',
        'https://example.com/photos/jean2.jpg',
      ],
      prompts: const [
        UserPrompt(
          promptId: 'height_stories_high',
          promptText: 'Mon plus grand avantage :',
          answer: 'Je vois tout au dessus de la foule !',
          displayOrder: 0,
        ),
        UserPrompt(
          promptId: 'ideal_date',
          promptText: 'Mon date idéal :',
          answer: 'Un restaurant en haut de la Tour Eiffel',
          displayOrder: 1,
        ),
      ],
      jobTitle: 'Ingénieur Logiciel',
      company: 'TechCorp',
      school: 'École Polytechnique',
      instagramUsername: '@jeandupont',
      topArtists: ['Daft Punk', 'Justice', 'M83'],
      anthemSongId: 'spotify:track:123',
      heightVerified: true,
      idVerified: false,
      genderIdentity: 'Homme',
      orientations: const ['Hétéro'],
      age: 33,
      createdAt: now.subtract(const Duration(days: 30)),
      profileViews: 150,
      interests: const ['Randonnée', 'Cuisine', 'Technologie', 'Voyage'],
    );
  }

  /// Minimal profile with only required fields
  static UserProfileEntity get minimalProfile {
    return UserProfileEntity(
      id: 'profile_minimal_001',
      userId: 'user_minimal_001',
      displayName: 'Test User',
      gender: 'autre',
      heightCm: 170,
      birthday: DateTime(2000, 1, 1),
      city: 'Lyon',
      country: 'France',
    );
  }

  /// Female profile for testing
  static UserProfileEntity get femaleProfile {
    final now = DateTime.now();
    return UserProfileEntity(
      id: 'profile_female_001',
      userId: 'user_female_001',
      displayName: 'Marie Martin',
      bio: 'Journaliste passionnée de mode et de voyage ✈️',
      gender: 'femme',
      sexualOrientation: 'hétéro',
      heightCm: 178,
      birthday: DateTime(1992, 8, 22),
      city: 'Lyon',
      country: 'France',
      photoUrls: [
        'https://example.com/photos/marie1.jpg',
        'https://example.com/photos/marie2.jpg',
        'https://example.com/photos/marie3.jpg',
      ],
      prompts: const [
        UserPrompt(
          promptId: 'height_stories_high',
          promptText: 'Mon plus grand avantage :',
          answer: 'Je peux atteindre les meilleures étagères du magasin !',
          displayOrder: 0,
        ),
      ],
      jobTitle: 'Journaliste',
      company: 'France Media',
      school: 'Sorbonne',
      heightVerified: true,
      idVerified: true,
      genderIdentity: 'Femme',
      orientations: const ['Hétéro'],
      age: 31,
      createdAt: now.subtract(const Duration(days: 15)),
      profileViews: 320,
      interests: const ['Mode', 'Voyage', 'Littérature', 'Photographie'],
    );
  }

  /// Very tall male profile (195cm+)
  static UserProfileEntity get tallMaleProfile {
    return UserProfileEntity(
      id: 'profile_tall_male_001',
      userId: 'user_tall_male_001',
      displayName: 'Pierre LeGrand',
      bio: '2m00 de bonheur ! 🏀',
      gender: 'homme',
      sexualOrientation: 'hétéro',
      heightCm: 200,
      birthday: DateTime(1988, 3, 10),
      city: 'Marseille',
      country: 'France',
      photoUrls: ['https://example.com/photos/pierre1.jpg'],
      heightVerified: true,
      idVerified: false,
      genderIdentity: 'Homme',
      orientations: const ['Hétéro'],
      age: 36,
      createdAt: DateTime.now(),
      interests: const ['Basketball', 'Handball', 'Fitness'],
    );
  }

  /// Tall female profile (175cm+)
  static UserProfileEntity get tallFemaleProfile {
    return UserProfileEntity(
      id: 'profile_tall_female_001',
      userId: 'user_tall_female_001',
      displayName: 'Sophie Velue',
      bio: 'Modèle et actrice 🎬',
      gender: 'femme',
      sexualOrientation: 'bisexuelle',
      heightCm: 183,
      birthday: DateTime(1995, 11, 5),
      city: 'Paris',
      country: 'France',
      photoUrls: [
        'https://example.com/photos/sophie1.jpg',
        'https://example.com/photos/sophie2.jpg',
      ],
      heightVerified: true,
      idVerified: true,
      genderIdentity: 'Femme',
      orientations: const ['Hétéro', 'Bisexuelle'],
      age: 28,
      createdAt: DateTime.now(),
      interests: const ['Mode', 'Cinéma', 'Théâtre', 'Art'],
    );
  }

  /// Profile without verification
  static UserProfileEntity get unverifiedProfile {
    return UserProfileEntity(
      id: 'profile_unverified_001',
      userId: 'user_unverified_001',
      displayName: 'Utilisateur Test',
      gender: 'homme',
      heightCm: 180,
      birthday: DateTime(1995, 1, 1),
      city: 'Bordeaux',
      country: 'France',
      photoUrls: ['https://example.com/photos/test1.jpg'],
      heightVerified: false,
      idVerified: false,
      genderIdentity: 'Homme',
      orientations: const ['Hétéro'],
      age: 29,
      createdAt: DateTime.now(),
    );
  }

  /// Multiple profiles for testing lists and pagination
  static List<UserProfileEntity> get multipleProfiles => [
    defaultProfile,
    femaleProfile,
    tallMaleProfile,
    tallFemaleProfile,
    unverifiedProfile,
  ];

  /// Profile matching specific discovery preferences
  static UserProfileEntity get matchingProfile {
    return UserProfileEntity(
      id: 'profile_matching_001',
      userId: 'user_matching_001',
      displayName: 'Lucie Bernard',
      bio: 'Architecte passionnée d\'art moderne 🎨',
      gender: 'femme',
      sexualOrientation: 'hétéro',
      heightCm: 176,
      birthday: DateTime(1991, 7, 8),
      city: 'Paris',
      country: 'France',
      photoUrls: ['https://example.com/photos/lucie1.jpg'],
      prompts: const [
        UserPrompt(
          promptId: 'ideal_date',
          promptText: 'Mon date idéal :',
          answer: 'Exposition au Centre Pompidou',
          displayOrder: 0,
        ),
      ],
      jobTitle: 'Architecte',
      company: 'Agence Architecture Paris',
      heightVerified: true,
      idVerified: true,
      genderIdentity: 'Femme',
      orientations: const ['Hétéro'],
      age: 32,
      createdAt: DateTime.now(),
      interests: const ['Architecture', 'Art', 'Design', 'Voyage'],
    );
  }

  /// Test discovery preferences
  static DiscoveryPreferencesEntity get testDiscoveryPreferences {
    return DiscoveryPreferencesEntity(
      userId: 'user_test_001',
      minAge: 25,
      maxAge: 40,
      minHeightCm: 170,
      maxHeightCm: 195,
      preferredGenders: const ['femme'],
      maxDistanceKm: 50,
      city: 'Paris',
      country: 'France',
      lastUpdated: DateTime.now(),
    );
  }

  /// Discovery preferences with wide range
  static DiscoveryPreferencesEntity get wideDiscoveryPreferences {
    return DiscoveryPreferencesEntity(
      userId: 'user_test_001',
      minAge: 18,
      maxAge: 50,
      minHeightCm: 150,
      maxHeightCm: 220,
      preferredGenders: const ['femme', 'homme', 'non-binaire'],
      maxDistanceKm: 100,
      city: 'Paris',
      country: 'France',
      lastUpdated: DateTime.now(),
    );
  }
}
