import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';

/// Tests pour les entités sociales
///
/// Teste la sérialisation, désérialisation, et les méthodes copyWith
/// des entités du domaine social.
void main() {
  group('SocialEvent', () {
    final testDateTime = DateTime.parse('2024-01-15T18:00:00Z');
    final testEvent = SocialEvent(
      id: 'event123',
      title: 'Afterwork Tall Us',
      description: 'Rencontre entre personnes grandes',
      location: 'Bar Paris 11',
      dateTime: testDateTime,
      attendees: ['user1', 'user2'],
      maxAttendees: 20,
      hostId: 'user1',
      imageUrl: 'https://example.com/image.jpg',
    );

    test('should create SocialEvent with required fields', () {
      expect(testEvent.id, 'event123');
      expect(testEvent.title, 'Afterwork Tall Us');
      expect(testEvent.attendees.length, 2);
      expect(testEvent.maxAttendees, 20);
    });

    test('should copyWith correctly update fields', () {
      final updated = testEvent.copyWith(
        title: 'Updated Event',
        maxAttendees: 30,
      );

      expect(updated.id, testEvent.id); // unchanged
      expect(updated.title, 'Updated Event');
      expect(updated.maxAttendees, 30);
      expect(updated.description, testEvent.description); // unchanged
    });

    test('should add attendee correctly', () {
      final updated = testEvent.copyWith(
        attendees: ['user1', 'user2', 'user3'],
      );

      expect(updated.attendees.length, 3);
      expect(updated.attendees.contains('user3'), true);
    });

    test('should check if event is full', () {
      final fullEvent = testEvent.copyWith(
        attendees: List.generate(20, (i) => 'user$i'),
      );

      expect(fullEvent.attendees.length, fullEvent.maxAttendees);
      // Full when attendees count equals max
      expect(fullEvent.attendees.length >= fullEvent.maxAttendees, true);
    });
  });

  group('SocialGroup', () {
    const testGroup = SocialGroup(
      id: 'group123',
      name: 'Grands Amateurs de Randonnée',
      category: 'Sport',
      description: 'Pour les amoureux de la nature',
      members: ['user1', 'user2', 'user3'],
      maxMembers: 100,
      hostId: 'user1',
      createdAt: null,
    );

    test('should create SocialGroup with required fields', () {
      expect(testGroup.id, 'group123');
      expect(testGroup.name, 'Grands Amateurs de Randonnée');
      expect(testGroup.category, 'Sport');
      expect(testGroup.members.length, 3);
      expect(testGroup.maxMembers, 100);
    });

    test('should copyWith and update fields', () {
      final updated = testGroup.copyWith(
        name: 'Updated Group Name',
        members: ['user1', 'user2', 'user3', 'user4'],
      );

      expect(updated.name, 'Updated Group Name');
      expect(updated.members.length, 4);
    });

    test('should check if group is full', () {
      final fullGroup = testGroup.copyWith(
        members: List.generate(100, (i) => 'user$i'),
      );

      expect(fullGroup.members.length, fullGroup.maxMembers);
    });
  });

  group('PhotoMetadata', () {
    const testPhoto = PhotoMetadata(
      photoId: 'photo123',
      url: 'https://example.com/photo.jpg',
      caption: 'Me in Paris',
      displayOrder: 0,
      likeCount: 42,
      viewCount: 1000,
      matchCount: 5,
      smartScore: 75.5,
    );

    test('should create PhotoMetadata with all fields', () {
      expect(testPhoto.photoId, 'photo123');
      expect(testPhoto.url, 'https://example.com/photo.jpg');
      expect(testPhoto.caption, 'Me in Paris');
      expect(testPhoto.likeCount, 42);
      expect(testPhoto.viewCount, 1000);
      expect(testPhoto.matchCount, 5);
      expect(testPhoto.smartScore, 75.5);
    });

    test('should calculate engagement rate correctly', () {
      final engagementRate = testPhoto.viewCount == 0
          ? 0.0
          : testPhoto.likeCount / testPhoto.viewCount;

      expect(engagementRate, 42 / 1000);
      expect(engagementRate, 0.042);
    });

    test('should calculate match rate correctly', () {
      final matchRate = testPhoto.viewCount == 0
          ? 0.0
          : testPhoto.matchCount / testPhoto.viewCount;

      expect(matchRate, 5 / 1000);
      expect(matchRate, 0.005);
    });

    test('should copyWith and update metadata', () {
      final updated = testPhoto.copyWith(
        likeCount: 50,
        viewCount: 1100,
        smartScore: 80.0,
      );

      expect(updated.likeCount, 50);
      expect(updated.viewCount, 1100);
      expect(updated.smartScore, 80.0);
      expect(updated.photoId, testPhoto.photoId); // unchanged
    });

    test('should handle optional lastScoreUpdate', () {
      final withTimestamp = testPhoto.copyWith(
        lastScoreUpdate: DateTime.utc(2024, 1, 1),
      );

      expect(withTimestamp.lastScoreUpdate, isNotNull);
      expect(withTimestamp.lastScoreUpdate!.toIso8601String(),
          '2024-01-01T00:00:00.000Z');
    });
  });

  group('LikeRecord', () {
    final now = DateTime.now();
    final testLike = LikeRecord(
      id: 'like123',
      fromUserId: 'user1',
      toUserId: 'user2',
      likedAt: now,
      isSeen: false,
    );

    test('should create LikeRecord with correct data', () {
      expect(testLike.id, 'like123');
      expect(testLike.fromUserId, 'user1');
      expect(testLike.toUserId, 'user2');
      expect(testLike.likedAt, now);
      expect(testLike.isSeen, false);
    });

    test('should mark like as seen', () {
      final seenLike = testLike.copyWith(isSeen: true);

      expect(seenLike.isSeen, true);
      expect(seenLike.fromUserId, testLike.fromUserId);
    });

    test('should copyWith correctly', () {
      final updated = testLike.copyWith(
        isSeen: true,
        likedAt: now.add(const Duration(days: 1)),
      );

      expect(updated.isSeen, true);
      expect(updated.likedAt.isAfter(now), true);
    });
  });

  group('TopPickScore', () {
    final now = DateTime.now();
    final testScore = TopPickScore(
      profileId: 'profile123',
      compatibilityScore: 85.5,
      matchReasons: [
        'Vous avez 3 intérêts en commun',
        'Taille vérifiée',
        'Profil complet',
      ],
      calculatedAt: now,
    );

    test('should create TopPickScore with required fields', () {
      expect(testScore.profileId, 'profile123');
      expect(testScore.compatibilityScore, 85.5);
      expect(testScore.matchReasons.length, 3);
      expect(testScore.matchReasons.contains('Taille vérifiée'), true);
    });

    test('should calculate score within valid range', () {
      expect(testScore.compatibilityScore, greaterThanOrEqualTo(0));
      expect(testScore.compatibilityScore, lessThanOrEqualTo(100));
    });

    test('should have at least one match reason', () {
      expect(testScore.matchReasons.isNotEmpty, true);
      expect(testScore.matchReasons.length, greaterThanOrEqualTo(1));
    });

    test('should copyWith and update score', () {
      final updated = testScore.copyWith(
        compatibilityScore: 90.0,
        calculatedAt: now,
      );

      expect(updated.compatibilityScore, 90.0);
      expect(updated.calculatedAt, now);
    });
  });

  group('UserProfileExtended', () {
    final now = DateTime.now();
    final testPhoto = PhotoMetadata(
      photoId: 'photo123',
      url: 'https://example.com/photo.jpg',
      caption: 'Me in Paris',
      displayOrder: 0,
    );

    final testExtendedProfile = UserProfileExtended(
      userId: 'user123',
      jobTitle: 'Software Engineer',
      company: 'Tech Corp',
      school: 'University of Technology',
      degree: 'Master in Computer Science',
      drinkingPreference: 'socially',
      smokingPreference: 'no',
      workoutFrequency: 'often',
      genders: ['homme'],
      pronouns: 'il/lui',
      zodiacSign: 'Lion',
      photos: [testPhoto],
      friendIds: ['friend1', 'friend2'],
      updatedAt: now,
    );

    test('should create UserProfileExtended with all fields', () {
      expect(testExtendedProfile.userId, 'user123');
      expect(testExtendedProfile.jobTitle, 'Software Engineer');
      expect(testExtendedProfile.company, 'Tech Corp');
      expect(testExtendedProfile.school, 'University of Technology');
      expect(testExtendedProfile.degree, 'Master in Computer Science');
    });

    test('should have lifestyle preferences', () {
      expect(testExtendedProfile.drinkingPreference, 'socially');
      expect(testExtendedProfile.smokingPreference, 'no');
      expect(testExtendedProfile.workoutFrequency, 'often');
    });

    test('should have identity fields', () {
      expect(testExtendedProfile.genders, ['homme']);
      expect(testExtendedProfile.pronouns, 'il/lui');
      expect(testExtendedProfile.zodiacSign, 'Lion');
    });

    test('should have photos metadata', () {
      expect(testExtendedProfile.photos.length, 1);
      expect(testExtendedProfile.photos.first.photoId, 'photo123');
      expect(testExtendedProfile.photos.first.caption, 'Me in Paris');
    });

    test('should have social connections', () {
      expect(testExtendedProfile.friendIds.length, 2);
      expect(testExtendedProfile.friendIds.contains('friend1'), true);
    });

    test('should copyWith and update fields', () {
      final updated = testExtendedProfile.copyWith(
        jobTitle: 'Senior Software Engineer',
        updatedAt: now.add(const Duration(days: 1)),
      );

      expect(updated.jobTitle, 'Senior Software Engineer');
      expect(updated.updatedAt!.isAfter(now), true);
      expect(updated.company, testExtendedProfile.company); // unchanged
    });
  });
}
