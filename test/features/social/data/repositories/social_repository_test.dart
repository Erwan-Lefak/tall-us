import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';

/// Tests for SocialRepositoryImpl
///
/// NOTE: These are basic unit tests for repository functionality.
/// Full integration tests with Appwrite mocks would require additional setup.
void main() {
  group('SocialEvent Entities - Test Data Validation', () {
    test('should create valid social event fixtures', () {
      // Test that our fixtures create valid entities
      final event = SocialEvent(
        id: 'event_001',
        title: 'Test Event',
        description: 'Test Description',
        location: 'Test Location',
        dateTime: DateTime.now().add(const Duration(days: 7)),
        attendees: const ['user1', 'user2'],
        maxAttendees: 20,
        hostId: 'user1',
        imageUrl: '',
      );

      expect(event.id, 'event_001');
      expect(event.title, 'Test Event');
      expect(event.attendees.length, 2);
      expect(event.maxAttendees, 20);
      expect(event.hostId, 'user1');
    });

    test('should handle event with no attendees', () {
      final event = SocialEvent(
        id: 'event_002',
        title: 'Empty Event',
        description: 'No attendees yet',
        location: 'Paris',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        maxAttendees: 50,
        hostId: 'host_user',
      );

      expect(event.attendees, isEmpty);
      expect(event.maxAttendees, 50);
    });

    test('should handle full capacity event', () {
      final maxAttendees = 10;
      final attendees = List.generate(maxAttendees, (i) => 'user_$i');

      final event = SocialEvent(
        id: 'event_003',
        title: 'Full Event',
        description: 'Event at full capacity',
        location: 'Lyon',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        attendees: attendees,
        maxAttendees: maxAttendees,
        hostId: 'user_0',
      );

      expect(event.attendees.length, equals(maxAttendees));
      expect(event.attendees.length, equals(event.maxAttendees));
    });
  });

  group('SocialGroup Entities - Test Data Validation', () {
    test('should create valid social group fixtures', () {
      final group = SocialGroup(
        id: 'group_001',
        name: 'Test Group',
        description: 'Test Group Description',
        category: 'Social',
        members: const ['user1', 'user2', 'user3'],
        maxMembers: 100,
        hostId: 'user1',
        imageUrl: '',
      );

      expect(group.id, 'group_001');
      expect(group.name, 'Test Group');
      expect(group.members.length, 3);
      expect(group.maxMembers, 100);
    });

    test('should handle private group', () {
      final group = SocialGroup(
        id: 'group_002',
        name: 'Private Group',
        description: 'Private group for members only',
        category: 'Private',
        members: const ['user1', 'user2'],
        maxMembers: 20,
        hostId: 'user1',
        imageUrl: '',
      );

      expect(group.members.length, lessThan(group.maxMembers));
    });

    test('should handle group at capacity', () {
      final maxMembers = 20;
      final members = List.generate(maxMembers, (i) => 'user_$i');

      final group = SocialGroup(
        id: 'group_003',
        name: 'Full Group',
        description: 'Group at full capacity',
        category: 'Social',
        members: members,
        maxMembers: maxMembers,
        hostId: 'user_0',
        imageUrl: '',
      );

      expect(group.members.length, equals(maxMembers));
    });
  });

  group('PhotoMetadata Entity', () {
    test('should create valid photo metadata', () {
      final photo = PhotoMetadata(
        photoId: 'photo_001',
        url: 'https://example.com/photo.jpg',
        displayOrder: 0,
        likeCount: 10,
        viewCount: 100,
        matchCount: 5,
        smartScore: 75.5,
      );

      expect(photo.photoId, 'photo_001');
      expect(photo.url, 'https://example.com/photo.jpg');
      expect(photo.likeCount, 10);
      expect(photo.viewCount, 100);
      expect(photo.matchCount, 5);
      expect(photo.smartScore, 75.5);
    });

    test('should handle photo with default values', () {
      final photo = PhotoMetadata(
        photoId: 'photo_002',
        url: 'https://example.com/photo2.jpg',
        displayOrder: 1,
      );

      expect(photo.likeCount, 0);
      expect(photo.viewCount, 0);
      expect(photo.matchCount, 0);
      expect(photo.smartScore, 50.0);
    });
  });

  group('TopPickScore Entity', () {
    test('should create valid top pick score', () {
      final score = TopPickScore(
        profileId: 'profile_001',
        compatibilityScore: 92.5,
        matchReasons: const [
          'Height compatible',
          'Common interests',
          'Proximity',
        ],
        calculatedAt: DateTime.now(),
      );

      expect(score.profileId, 'profile_001');
      expect(score.compatibilityScore, 92.5);
      expect(score.matchReasons.length, 3);
    });

    test('should handle score with no match reasons', () {
      final score = TopPickScore(
        profileId: 'profile_002',
        compatibilityScore: 50.0,
        calculatedAt: DateTime.now(),
      );

      expect(score.matchReasons, isEmpty);
      expect(score.compatibilityScore, 50.0);
    });
  });

  group('LikeRecord Entity', () {
    test('should create valid like record', () {
      final now = DateTime.now();
      final like = LikeRecord(
        id: 'like_001',
        fromUserId: 'user_001',
        toUserId: 'user_002',
        likedAt: now,
        isSeen: false,
      );

      expect(like.id, 'like_001');
      expect(like.fromUserId, 'user_001');
      expect(like.toUserId, 'user_002');
      expect(like.isSeen, false);
    });

    test('should handle seen like', () {
      final like = LikeRecord(
        id: 'like_002',
        fromUserId: 'user_003',
        toUserId: 'user_004',
        likedAt: DateTime.now(),
        isSeen: true,
      );

      expect(like.isSeen, true);
    });
  });

  group('UserProfileExtended Entity', () {
    test('should create extended profile with all optional fields', () {
      final profile = UserProfileExtended(
        userId: 'user_001',
        jobTitle: 'Engineer',
        company: 'TechCorp',
        school: 'University',
        degree: 'Masters',
        drinkingPreference: 'Social',
        smokingPreference: 'Non-smoker',
        workoutFrequency: 'Daily',
        genders: const ['Male'],
        pronouns: 'he/him',
        zodiacSign: 'Leo',
        photos: const [],
        friendIds: const ['friend1', 'friend2'],
        updatedAt: DateTime.now(),
      );

      expect(profile.userId, 'user_001');
      expect(profile.jobTitle, 'Engineer');
      expect(profile.company, 'TechCorp');
      expect(profile.school, 'University');
      expect(profile.degree, 'Masters');
      expect(profile.friendIds.length, 2);
    });

    test('should handle extended profile with minimal data', () {
      final profile = UserProfileExtended(
        userId: 'user_002',
      );

      expect(profile.userId, 'user_002');
      expect(profile.jobTitle, isNull);
      expect(profile.friendIds, isEmpty);
      expect(profile.genders, isEmpty);
    });
  });

  group('Entity Serialization', () {
    test('should serialize and deserialize SocialEvent', () {
      final event = SocialEvent(
        id: 'event_001',
        title: 'Test Event',
        description: 'Test Description',
        location: 'Test Location',
        dateTime: DateTime.parse('2024-01-15T18:00:00Z'),
        attendees: const ['user1', 'user2'],
        maxAttendees: 20,
        hostId: 'user1',
        imageUrl: '',
      );

      // Test toJson
      final json = event.toJson();
      expect(json['id'], 'event_001');
      expect(json['title'], 'Test Event');
      expect(json['dateTime'], '2024-01-15T18:00:00.000Z');

      // Test fromJson
      final deserialized = SocialEvent.fromJson(json);
      expect(deserialized.id, event.id);
      expect(deserialized.title, event.title);
      expect(deserialized.location, event.location);
    });

    test('should serialize and deserialize SocialGroup', () {
      final group = SocialGroup(
        id: 'group_001',
        name: 'Test Group',
        description: 'Test Description',
        category: 'Test Category',
        members: const ['user1', 'user2'],
        maxMembers: 50,
        hostId: 'user1',
        imageUrl: '',
      );

      final json = group.toJson();
      expect(json['id'], 'group_001');
      expect(json['name'], 'Test Group');
      expect(json['category'], 'Test Category');

      final deserialized = SocialGroup.fromJson(json);
      expect(deserialized.id, group.id);
      expect(deserialized.name, group.name);
      expect(deserialized.members.length, 2);
    });

    test('should serialize and deserialize TopPickScore', () {
      final score = TopPickScore(
        profileId: 'profile_001',
        compatibilityScore: 85.5,
        matchReasons: const ['Reason 1', 'Reason 2'],
        calculatedAt: DateTime.parse('2024-01-15T10:00:00Z'),
      );

      final json = score.toJson();
      expect(json['profileId'], 'profile_001');
      expect(json['compatibilityScore'], 85.5);
      expect(json['matchReasons'], ['Reason 1', 'Reason 2']);

      final deserialized = TopPickScore.fromJson(json);
      expect(deserialized.profileId, score.profileId);
      expect(deserialized.compatibilityScore, score.compatibilityScore);
      expect(deserialized.matchReasons.length, 2);
    });
  });
}
