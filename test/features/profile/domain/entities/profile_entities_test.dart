import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';

/// Tests pour les entités du profil utilisateur
///
/// Teste la sérialisation, désérialisation, les méthodes utilitaires
/// et les méthodes copyWith des entités du domaine profile.
void main() {
  group('UserPrompt', () {
    const testPrompt = UserPrompt(
      promptId: 'prompt1',
      promptText: 'Ma meilleure histoire de grande personne :',
      answer: 'Je peux atteindre les étagères du haut !',
      displayOrder: 0,
    );

    test('should create UserPrompt with all fields', () {
      expect(testPrompt.promptId, 'prompt1');
      expect(testPrompt.promptText, contains('histoire'));
      expect(testPrompt.answer, contains('étagères'));
      expect(testPrompt.displayOrder, 0);
    });

    test('should copyWith correctly', () {
      final updated = testPrompt.copyWith(
        answer: 'Nouvelle réponse',
        displayOrder: 1,
      );

      expect(updated.promptId, testPrompt.promptId); // unchanged
      expect(updated.promptText, testPrompt.promptText); // unchanged
      expect(updated.answer, 'Nouvelle réponse');
      expect(updated.displayOrder, 1);
    });

    test('should have correct props for equality', () {
      const prompt1 = UserPrompt(
        promptId: 'p1',
        promptText: 'Test',
        answer: 'Answer',
        displayOrder: 0,
      );

      const prompt2 = UserPrompt(
        promptId: 'p1',
        promptText: 'Test',
        answer: 'Answer',
        displayOrder: 0,
      );

      expect(prompt1, equals(prompt2));
    });
  });

  group('PromptEntity', () {
    const testEntity = PromptEntity(
      id: 'height_stories_high',
      text: 'Ma meilleure histoire de grande personne :',
      category: 'height_experience',
      popularity: 95,
    );

    test('should create PromptEntity correctly', () {
      expect(testEntity.id, 'height_stories_high');
      expect(testEntity.text, contains('histoire'));
      expect(testEntity.category, 'height_experience');
      expect(testEntity.popularity, 95);
    });

    test('should have default popularity', () {
      const entity = PromptEntity(
        id: 'test',
        text: 'Test prompt',
        category: 'test',
      );

      expect(entity.popularity, 0);
    });

    test('should have correct props for equality', () {
      const entity1 = PromptEntity(
        id: 'test',
        text: 'Test',
        category: 'test',
        popularity: 50,
      );

      const entity2 = PromptEntity(
        id: 'test',
        text: 'Test',
        category: 'test',
        popularity: 50,
      );

      expect(entity1, equals(entity2));
    });
  });

  group('TallPrompts', () {
    test('should have predefined prompts', () {
      expect(TallPrompts.allPrompts.isNotEmpty, true);
      expect(TallPrompts.allPrompts.length, greaterThan(10));
    });

    test('should have height experience prompts', () {
      final heightPrompts = TallPrompts.getByCategory('height_experience');
      expect(heightPrompts.isNotEmpty, true);
      expect(heightPrompts.first.category, 'height_experience');
    });

    test('should have dating prompts', () {
      final datingPrompts = TallPrompts.getByCategory('dating');
      expect(datingPrompts.isNotEmpty, true);
      expect(datingPrompts.first.category, 'dating');
    });

    test('should have lifestyle prompts', () {
      final lifestylePrompts = TallPrompts.getByCategory('lifestyle');
      expect(lifestylePrompts.isNotEmpty, true);
    });

    test('should have personality prompts', () {
      final personalityPrompts = TallPrompts.getByCategory('personality');
      expect(personalityPrompts.isNotEmpty, true);
    });

    test('should get popular prompts', () {
      final popular = TallPrompts.getPopular(limit: 3);
      expect(popular.length, lessThanOrEqualTo(3));

      // Should be sorted by popularity (descending)
      for (int i = 0; i < popular.length - 1; i++) {
        expect(popular[i].popularity,
            greaterThanOrEqualTo(popular[i + 1].popularity));
      }
    });

    test('should get random prompts', () {
      final random1 = TallPrompts.getRandom(count: 3);
      final random2 = TallPrompts.getRandom(count: 3);

      expect(random1.length, 3);
      expect(random2.length, 3);

      // Might be different (random)
      // But we can't guarantee they're different in tests
    });

    test('should have tall-specific content', () {
      final hasTallContent = TallPrompts.allPrompts.any(
        (p) =>
            p.text.toLowerCase().contains('grand') ||
            p.text.toLowerCase().contains('taille') ||
            p.text.toLowerCase().contains('haut'),
      );

      expect(hasTallContent, true);
    });
  });

  group('UserProfileEntity', () {
    final testBirthday = DateTime.parse('1990-05-15');
    final testCreatedAt = DateTime.parse('2024-01-01T00:00:00Z');

    final testProfile = UserProfileEntity(
      id: 'profile123',
      userId: 'user123',
      displayName: 'Jean Dupont',
      bio: 'Amateur de randonnée et de bonne cuisine',
      gender: 'homme',
      sexualOrientation: 'hétéro',
      heightCm: 185,
      birthday: testBirthday,
      city: 'Paris',
      country: 'France',
      photoUrls: [
        'https://example.com/photo1.jpg',
        'https://example.com/photo2.jpg',
      ],
      prompts: const [
        UserPrompt(
          promptId: 'p1',
          promptText: 'Mon plus grand avantage :',
          answer: 'Je vois tout au dessus de la foule !',
          displayOrder: 0,
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
      orientations: ['Hétéro'],
      age: 33,
      createdAt: testCreatedAt,
      profileViews: 150,
      interests: ['Randonnée', 'Cuisine', 'Technologie', 'Voyage'],
    );

    test('should create UserProfileEntity with all fields', () {
      expect(testProfile.id, 'profile123');
      expect(testProfile.userId, 'user123');
      expect(testProfile.displayName, 'Jean Dupont');
      expect(testProfile.heightCm, 185);
      expect(testProfile.city, 'Paris');
      expect(testProfile.photoUrls.length, 2);
    });

    test('should calculate age correctly', () {
      // For a birthday on 1990-05-15, in 2024 the age should be 33
      final calculatedAge = testProfile.calculateAge();
      expect(calculatedAge, greaterThanOrEqualTo(33));
      expect(calculatedAge, lessThanOrEqualTo(34));
    });

    test('should use provided age if available', () {
      expect(testProfile.age, 33);
      expect(testProfile.calculateAge(), testProfile.age);
    });

    test('should convert height to feet and inches', () {
      final feetInches = testProfile.getHeightInFeetInches();
      // 185cm ≈ 6'1"
      expect(feetInches, contains("'"));
      expect(feetInches, contains('"'));
    });

    test('should check if profile is complete', () {
      final complete = testProfile.isComplete();
      expect(complete, true);
    });

    test('should identify incomplete profile', () {
      final incomplete = testProfile.copyWith(
        bio: null,
        photoUrls: const [],
        prompts: const [],
      );

      expect(incomplete.isComplete(), false);
    });

    test('should calculate completion percentage', () {
      final percentage = testProfile.getCompletionPercentage();
      expect(percentage, greaterThan(0.0));
      expect(percentage, lessThanOrEqualTo(1.0));
    });

    test('should have high completion for filled profile', () {
      final percentage = testProfile.getCompletionPercentage();
      expect(percentage, greaterThan(0.5)); // At least 50%
    });

    test('should copyWith and update fields', () {
      final updated = testProfile.copyWith(
        bio: 'Nouvelle bio',
        jobTitle: 'Senior Engineer',
        heightVerified: false,
      );

      expect(updated.bio, 'Nouvelle bio');
      expect(updated.jobTitle, 'Senior Engineer');
      expect(updated.heightVerified, false);
      expect(updated.displayName, testProfile.displayName); // unchanged
    });

    test('should convert to map', () {
      final map = testProfile.toMap();

      expect(map['id'], testProfile.id);
      expect(map['userId'], testProfile.userId);
      expect(map['displayName'], testProfile.displayName);
      expect(map['heightCm'], testProfile.heightCm);
      expect(map['photoUrls'], isA<List>());
      expect(map['prompts'], isA<List>());
    });

    test('should create from map', () {
      final map = testProfile.toMap();
      final fromMap = UserProfileEntity.fromMap(map);

      expect(fromMap.id, testProfile.id);
      expect(fromMap.userId, testProfile.userId);
      expect(fromMap.displayName, testProfile.displayName);
      expect(fromMap.heightCm, testProfile.heightCm);
    });

    test('should handle verification status', () {
      expect(testProfile.heightVerified, true);
      expect(testProfile.idVerified, false);

      final fullyVerified = testProfile.copyWith(idVerified: true);
      expect(fullyVerified.heightVerified, true);
      expect(fullyVerified.idVerified, true);
    });

    test('should have social connections', () {
      expect(testProfile.instagramUsername, isNotNull);
      expect(testProfile.topArtists, isNotEmpty);
      expect(testProfile.anthemSongId, isNotNull);
    });

    test('should have gender and orientation', () {
      expect(testProfile.genderIdentity, 'Homme');
      expect(testProfile.orientations, contains('Hétéro'));
    });

    test('should have interests', () {
      expect(testProfile.interests, contains('Randonnée'));
      expect(testProfile.interests, contains('Cuisine'));
      expect(testProfile.interests.length, 4);
    });

    test('should track profile views', () {
      expect(testProfile.profileViews, 150);

      final withMoreViews = testProfile.copyWith(profileViews: 200);
      expect(withMoreViews.profileViews, 200);
    });

    test('should handle minimal profile', () {
      final minimal = UserProfileEntity(
        id: 'minimal',
        userId: 'user',
        displayName: 'Test User',
        gender: 'other',
        heightCm: 170,
        birthday: DateTime(2000, 1, 1),
        city: 'Paris',
        country: 'France',
      );

      expect(minimal.bio, isNull);
      expect(minimal.photoUrls, isEmpty);
      expect(minimal.prompts, isEmpty);
      expect(minimal.isComplete(), false);
    });
  });

  group('DiscoveryPreferencesEntity', () {
    final testLastUpdated = DateTime.parse('2024-01-15T10:00:00Z');

    final testPreferences = DiscoveryPreferencesEntity(
      userId: 'user123',
      minAge: 25,
      maxAge: 40,
      minHeightCm: 170,
      maxHeightCm: 195,
      preferredGenders: const ['femme'],
      maxDistanceKm: 50,
      city: 'Paris',
      country: 'France',
      lastUpdated: testLastUpdated,
    );

    test('should create with all fields', () {
      expect(testPreferences.userId, 'user123');
      expect(testPreferences.minAge, 25);
      expect(testPreferences.maxAge, 40);
      expect(testPreferences.minHeightCm, 170);
      expect(testPreferences.maxHeightCm, 195);
      expect(testPreferences.preferredGenders, ['femme']);
      expect(testPreferences.maxDistanceKm, 50);
    });

    test('should check age matching', () {
      expect(testPreferences.matchesAge(30), true); // Within range
      expect(testPreferences.matchesAge(25), true); // At min
      expect(testPreferences.matchesAge(40), true); // At max
      expect(testPreferences.matchesAge(24), false); // Below min
      expect(testPreferences.matchesAge(41), false); // Above max
    });

    test('should check height matching', () {
      expect(testPreferences.matchesHeight(180), true); // Within range
      expect(testPreferences.matchesHeight(170), true); // At min
      expect(testPreferences.matchesHeight(195), true); // At max
      expect(testPreferences.matchesHeight(169), false); // Below min
      expect(testPreferences.matchesHeight(196), false); // Above max
    });

    test('should check gender matching', () {
      expect(testPreferences.matchesGender('femme'), true);
      expect(testPreferences.matchesGender('homme'), false);
      expect(testPreferences.matchesGender('non-binaire'), false);
    });

    test('should check distance matching', () {
      expect(testPreferences.matchesDistance(30), true); // Within range
      expect(testPreferences.matchesDistance(50), true); // At max
      expect(testPreferences.matchesDistance(51), false); // Above max
    });

    test('should match all criteria', () {
      // A profile that matches all preferences
      final matchesAge = testPreferences.matchesAge(28);
      final matchesHeight = testPreferences.matchesHeight(175);
      final matchesGender = testPreferences.matchesGender('femme');
      final matchesDistance = testPreferences.matchesDistance(20);

      expect(matchesAge && matchesHeight && matchesGender && matchesDistance,
          true);
    });

    test('should copyWith and update fields', () {
      final updated = testPreferences.copyWith(
        minAge: 20,
        maxAge: 35,
        preferredGenders: ['femme', 'non-binaire'],
      );

      expect(updated.minAge, 20);
      expect(updated.maxAge, 35);
      expect(updated.preferredGenders.length, 2);
      expect(updated.city, testPreferences.city); // unchanged
    });

    test('should convert to map', () {
      final map = testPreferences.toMap();

      expect(map['userId'], testPreferences.userId);
      expect(map['minAge'], testPreferences.minAge);
      expect(map['maxAge'], testPreferences.maxAge);
      expect(map['preferredGenders'], isA<List>());
    });

    test('should create from map', () {
      final map = testPreferences.toMap();
      final fromMap = DiscoveryPreferencesEntity.fromMap(map);

      expect(fromMap.userId, testPreferences.userId);
      expect(fromMap.minAge, testPreferences.minAge);
      expect(fromMap.maxAge, testPreferences.maxAge);
    });

    test('should create default preferences', () {
      final defaults = DiscoveryPreferencesEntity.defaults(
        userId: 'user456',
        userAge: 30,
        userHeight: 180,
        userGender: 'homme',
        city: 'Lyon',
        country: 'France',
      );

      expect(defaults.userId, 'user456');
      expect(defaults.minAge, 25); // 30 - 5
      expect(defaults.maxAge, 35); // 30 + 5
      expect(defaults.minHeightCm, 170); // 180 - 10
      expect(defaults.maxHeightCm, 190); // 180 + 10
      expect(defaults.preferredGenders, ['femme']); // Opposite of homme
      expect(defaults.maxDistanceKm, 50);
      expect(defaults.city, 'Lyon');
      expect(defaults.country, 'France');
      expect(defaults.lastUpdated, isNotNull);
    });

    test('should clamp age limits in defaults', () {
      // Test with age 20 (minimum should be clamped to 18)
      final defaults = DiscoveryPreferencesEntity.defaults(
        userId: 'user',
        userAge: 20,
        userHeight: 170,
        userGender: 'femme',
        city: 'Paris',
        country: 'France',
      );

      expect(defaults.minAge, 18); // Clamped to minimum
      expect(defaults.maxAge, 25); // 20 + 5
    });

    test('should handle multiple preferred genders', () {
      final preferences = testPreferences.copyWith(
        preferredGenders: ['femme', 'non-binaire', 'autre'],
      );

      expect(preferences.matchesGender('femme'), true);
      expect(preferences.matchesGender('non-binaire'), true);
      expect(preferences.matchesGender('autre'), true);
      expect(preferences.matchesGender('homme'), false);
    });

    test('should handle empty preferred genders', () {
      final preferences = testPreferences.copyWith(
        preferredGenders: const [],
      );

      expect(preferences.matchesGender('homme'), false);
      expect(preferences.matchesGender('femme'), false);
    });
  });
}
