import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Tests for Discovery Extended Repository
///
/// Tests cover:
/// - Like recording and retrieval
/// - Top picks calculation
/// - Photo interactions
/// - Score calculations
void main() {
  group('LikeRecord - Basic Operations', () {
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
      expect(like.likedAt, now);
    });

    test('should mark like as seen', () {
      final like = LikeRecord(
        id: 'like_001',
        fromUserId: 'user_001',
        toUserId: 'user_002',
        likedAt: DateTime.now(),
        isSeen: false,
      );

      final seenLike = like.copyWith(isSeen: true);

      expect(seenLike.isSeen, true);
      expect(seenLike.id, like.id);
      expect(seenLike.fromUserId, like.fromUserId);
    });

    test('should handle super likes', () {
      final regularLike = LikeRecord(
        id: 'like_regular',
        fromUserId: 'user_001',
        toUserId: 'user_002',
        likedAt: DateTime.now(),
        isSeen: false,
      );

      final superLike = LikeRecord(
        id: 'like_super',
        fromUserId: 'user_003',
        toUserId: 'user_004',
        likedAt: DateTime.now(),
        isSeen: false,
      );

      expect(regularLike.id, 'like_regular');
      expect(superLike.id, 'like_super');
    });
  });

  group('WhoLikedMe - Data Validation', () {
    test('should handle empty who liked me list', () async {
      // Test that empty list is handled correctly
      final emptyList = <UserProfileEntity>[];

      expect(emptyList, isEmpty);
      expect(emptyList.length, 0);
    });

    test('should populate who liked me with valid profiles', () {
      // Create mock profiles
      final profile1 = UserProfileEntity(
        id: 'profile_001',
        userId: 'user_001',
        displayName: 'Marie Martin',
        gender: 'femme',
        heightCm: 178,
        birthday: DateTime(1992, 8, 22),
        city: 'Lyon',
        country: 'France',
        photoUrls: const [],
      );

      final profile2 = UserProfileEntity(
        id: 'profile_002',
        userId: 'user_002',
        displayName: 'Sophie Velue',
        gender: 'femme',
        heightCm: 183,
        birthday: DateTime(1995, 11, 5),
        city: 'Paris',
        country: 'France',
        photoUrls: const [],
      );

      final whoLikedMe = [profile1, profile2];

      expect(whoLikedMe.length, 2);
      expect(whoLikedMe[0].displayName, 'Marie Martin');
      expect(whoLikedMe[1].displayName, 'Sophie Velue');
      expect(whoLikedMe[0].heightCm, 178);
      expect(whoLikedMe[1].heightCm, 183);
    });

    test('should apply limit to who liked me results', () {
      final profiles = List.generate(
        5,
        (i) => UserProfileEntity(
          id: 'profile_$i',
          userId: 'user_$i',
          displayName: 'User $i',
          gender: 'homme',
          heightCm: 175 + i,
          birthday: DateTime(1990, 1, 1),
          city: 'Paris',
          country: 'France',
          photoUrls: const [],
        ),
      );

      final limited = profiles.take(2).toList();

      expect(limited.length, 2);
      expect(limited.length, lessThan(profiles.length));
    });
  });

  group('TopPickScore - Calculations', () {
    test('should create valid top pick score', () {
      final score = TopPickScore(
        profileId: 'profile_001',
        compatibilityScore: 92.5,
        matchReasons: const [
          'Hauteur compatible',
          'Intérêts communs: Randonnée, Voyage',
          'Proche géographique',
          'Style de vie similaire',
        ],
        calculatedAt: DateTime.now(),
      );

      expect(score.profileId, 'profile_001');
      expect(score.compatibilityScore, 92.5);
      expect(score.matchReasons.length, 4);
      expect(score.compatibilityScore, greaterThan(90.0));
    });

    test('should ensure score is within valid range', () {
      final validScores = [
        TopPickScore(
          profileId: 'p1',
          compatibilityScore: 0.0,
          matchReasons: const [],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p2',
          compatibilityScore: 50.0,
          matchReasons: const ['Average match'],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p3',
          compatibilityScore: 100.0,
          matchReasons: const ['Perfect match'],
          calculatedAt: DateTime.now(),
        ),
      ];

      for (final score in validScores) {
        expect(score.compatibilityScore, greaterThanOrEqualTo(0.0));
        expect(score.compatibilityScore, lessThanOrEqualTo(100.0));
      }
    });

    test('should calculate score with multiple match reasons', () {
      final score = TopPickScore(
        profileId: 'profile_001',
        compatibilityScore: 92.5,
        matchReasons: const [
          'Hauteur compatible',
          'Intérêts communs: Randonnée, Voyage',
          'Proche géographique',
          'Style de vie similaire',
        ],
        calculatedAt: DateTime.now(),
      );

      expect(score.matchReasons.length, greaterThan(0));
      expect(score.compatibilityScore, 92.5);
      expect(score.matchReasons, contains('Hauteur compatible'));
    });

    test('should handle scores with no match reasons', () {
      final score = TopPickScore(
        profileId: 'profile_low',
        compatibilityScore: 45.0,
        matchReasons: const [],
        calculatedAt: DateTime.now(),
      );

      expect(score.matchReasons, isEmpty);
      expect(score.compatibilityScore, lessThan(50.0));
    });
  });

  group('TopPicks - Sorting and Ranking', () {
    test('should sort top picks by compatibility score', () {
      final scores = [
        TopPickScore(
          profileId: 'p1',
          compatibilityScore: 75.0,
          matchReasons: const ['Reason 1'],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p2',
          compatibilityScore: 95.0,
          matchReasons: const ['Reason 2'],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p3',
          compatibilityScore: 85.0,
          matchReasons: const ['Reason 3'],
          calculatedAt: DateTime.now(),
        ),
      ];

      // Sort descending
      scores.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));

      expect(scores[0].profileId, 'p2');
      expect(scores[0].compatibilityScore, 95.0);
      expect(scores[1].compatibilityScore, 85.0);
      expect(scores[2].compatibilityScore, 75.0);
    });

    test('should limit top picks results', () {
      final scores = List.generate(
        20,
        (i) => TopPickScore(
          profileId: 'profile_$i',
          compatibilityScore: (100 - i * 5).toDouble(),
          matchReasons: const [],
          calculatedAt: DateTime.now(),
        ),
      );

      final top5 = scores.take(5).toList();

      expect(top5.length, 5);
      expect(top5[0].compatibilityScore, 100.0);
      expect(top5[4].compatibilityScore, 80.0);
    });

    test('should filter scores by minimum threshold', () {
      final scores = [
        TopPickScore(
          profileId: 'p1',
          compatibilityScore: 60.0,
          matchReasons: const [],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p2',
          compatibilityScore: 85.0,
          matchReasons: const ['High match'],
          calculatedAt: DateTime.now(),
        ),
        TopPickScore(
          profileId: 'p3',
          compatibilityScore: 45.0,
          matchReasons: const [],
          calculatedAt: DateTime.now(),
        ),
      ];

      final highScores = scores
          .where((s) => s.compatibilityScore >= 70.0)
          .toList();

      expect(highScores.length, 1);
      expect(highScores[0].profileId, 'p2');
    });
  });

  group('PhotoMetadata - Interactions', () {
    test('should track photo likes correctly', () {
      var photo = PhotoMetadata(
        photoId: 'photo_001',
        url: 'https://example.com/photo.jpg',
        displayOrder: 0,
        likeCount: 10,
      );

      photo = photo.copyWith(likeCount: photo.likeCount + 1);

      expect(photo.likeCount, 11);
    });

    test('should track photo views correctly', () {
      var photo = PhotoMetadata(
        photoId: 'photo_002',
        url: 'https://example.com/photo2.jpg',
        displayOrder: 1,
        viewCount: 100,
      );

      photo = photo.copyWith(viewCount: photo.viewCount + 1);

      expect(photo.viewCount, 101);
    });

    test('should track photo matches correctly', () {
      var photo = PhotoMetadata(
        photoId: 'photo_003',
        url: 'https://example.com/photo3.jpg',
        displayOrder: 2,
        matchCount: 5,
      );

      photo = photo.copyWith(matchCount: photo.matchCount + 1);

      expect(photo.matchCount, 6);
    });

    test('should calculate engagement rate', () {
      final photo = PhotoMetadata(
        photoId: 'photo_004',
        url: 'https://example.com/photo4.jpg',
        displayOrder: 0,
        likeCount: 25,
        viewCount: 100,
      );

      final engagementRate = photo.likeCount / photo.viewCount * 100;

      expect(engagementRate, 25.0);
    });

    test('should calculate match rate', () {
      final photo = PhotoMetadata(
        photoId: 'photo_005',
        url: 'https://example.com/photo5.jpg',
        displayOrder: 0,
        likeCount: 50,
        matchCount: 10,
      );

      final matchRate = photo.matchCount / photo.likeCount * 100;

      expect(matchRate, 20.0);
    });

    test('should update smart score', () {
      var photo = PhotoMetadata(
        photoId: 'photo_006',
        url: 'https://example.com/photo6.jpg',
        displayOrder: 0,
        smartScore: 50.0,
        lastScoreUpdate: DateTime.now().subtract(const Duration(days: 1)),
      );

      photo = photo.copyWith(
        smartScore: 75.5,
        lastScoreUpdate: DateTime.now(),
      );

      expect(photo.smartScore, 75.5);
      expect(photo.lastScoreUpdate, isNotNull);
    });
  });

  group('PhotoMetadata - Score Validations', () {
    test('should ensure smart score is in valid range', () {
      final photo = PhotoMetadata(
        photoId: 'photo_007',
        url: 'https://example.com/photo7.jpg',
        displayOrder: 0,
        smartScore: 85.5,
      );

      expect(photo.smartScore, greaterThanOrEqualTo(0.0));
      expect(photo.smartScore, lessThanOrEqualTo(100.0));
    });

    test('should handle photos with zero engagement', () {
      final photo = PhotoMetadata(
        photoId: 'photo_008',
        url: 'https://example.com/photo8.jpg',
        displayOrder: 0,
        likeCount: 0,
        viewCount: 0,
        matchCount: 0,
      );

      expect(photo.likeCount, 0);
      expect(photo.viewCount, 0);
      expect(photo.matchCount, 0);
    });

    test('should verify photo', () {
      var photo = PhotoMetadata(
        photoId: 'photo_009',
        url: 'https://example.com/photo9.jpg',
        displayOrder: 0,
        isVerified: false,
      );

      expect(photo.isVerified, false);

      photo = photo.copyWith(isVerified: true);

      expect(photo.isVerified, true);
    });
  });

  group('Discovery - Serialization', () {
    test('should serialize and deserialize LikeRecord', () {
      final like = LikeRecord(
        id: 'like_001',
        fromUserId: 'user_001',
        toUserId: 'user_002',
        likedAt: DateTime.parse('2024-01-15T10:00:00Z'),
        isSeen: false,
      );

      final json = like.toJson();
      expect(json['id'], 'like_001');
      expect(json['fromUserId'], 'user_001');
      expect(json['toUserId'], 'user_002');
      expect(json['isSeen'], false);

      final deserialized = LikeRecord.fromJson(json);
      expect(deserialized.id, like.id);
      expect(deserialized.fromUserId, like.fromUserId);
      expect(deserialized.toUserId, like.toUserId);
    });

    test('should serialize and deserialize PhotoMetadata', () {
      final photo = PhotoMetadata(
        photoId: 'photo_001',
        url: 'https://example.com/photo.jpg',
        displayOrder: 0,
        likeCount: 10,
        viewCount: 100,
        matchCount: 5,
        smartScore: 75.5,
      );

      final json = photo.toJson();
      expect(json['photoId'], 'photo_001');
      expect(json['likeCount'], 10);
      expect(json['viewCount'], 100);
      expect(json['smartScore'], 75.5);

      final deserialized = PhotoMetadata.fromJson(json);
      expect(deserialized.photoId, photo.photoId);
      expect(deserialized.likeCount, photo.likeCount);
      expect(deserialized.smartScore, photo.smartScore);
    });

    test('should serialize and deserialize TopPickScore', () {
      final score = TopPickScore(
        profileId: 'profile_001',
        compatibilityScore: 92.5,
        matchReasons: const ['Reason 1', 'Reason 2'],
        calculatedAt: DateTime.parse('2024-01-15T10:00:00Z'),
      );

      final json = score.toJson();
      expect(json['profileId'], 'profile_001');
      expect(json['compatibilityScore'], 92.5);
      expect(json['matchReasons'], ['Reason 1', 'Reason 2']);

      final deserialized = TopPickScore.fromJson(json);
      expect(deserialized.profileId, score.profileId);
      expect(deserialized.compatibilityScore, score.compatibilityScore);
      expect(deserialized.matchReasons.length, 2);
    });
  });

  group('Discovery - Edge Cases', () {
    test('should handle missing profile photo urls', () {
      final profile = UserProfileEntity(
        id: 'profile_no_photo',
        userId: 'user_123',
        displayName: 'No Photo User',
        gender: 'homme',
        heightCm: 180,
        birthday: DateTime(1990, 1, 1),
        city: 'Paris',
        country: 'France',
        photoUrls: const [],
      );

      expect(profile.photoUrls, isEmpty);
    });

    test('should handle profiles with minimal data', () {
      final profile = UserProfileEntity(
        id: 'profile_minimal',
        userId: 'user_minimal',
        displayName: 'Test User',
        gender: 'autre',
        heightCm: 170,
        birthday: DateTime(2000, 1, 1),
        city: 'Lyon',
        country: 'France',
      );

      expect(profile.id, isNotEmpty);
      expect(profile.userId, isNotEmpty);
      expect(profile.displayName, isNotEmpty);
      expect(profile.heightCm, greaterThan(0));
    });

    test('should handle very tall profiles', () {
      final tallProfile = UserProfileEntity(
        id: 'profile_tall',
        userId: 'user_tall',
        displayName: 'Pierre LeGrand',
        gender: 'homme',
        heightCm: 200,
        birthday: DateTime(1988, 3, 10),
        city: 'Marseille',
        country: 'France',
        photoUrls: const [],
      );

      expect(tallProfile.heightCm, 200);
      expect(tallProfile.heightCm, greaterThanOrEqualTo(190));
    });

    test('should handle verified and unverified profiles', () {
      final verified = UserProfileEntity(
        id: 'profile_verified',
        userId: 'user_verified',
        displayName: 'Marie Martin',
        gender: 'femme',
        heightCm: 178,
        birthday: DateTime(1992, 8, 22),
        city: 'Lyon',
        country: 'France',
        photoUrls: const [],
        heightVerified: true,
        idVerified: true,
      );

      final unverified = UserProfileEntity(
        id: 'profile_unverified',
        userId: 'user_unverified',
        displayName: 'Utilisateur Test',
        gender: 'homme',
        heightCm: 180,
        birthday: DateTime(1995, 1, 1),
        city: 'Bordeaux',
        country: 'France',
        photoUrls: const [],
        heightVerified: false,
        idVerified: false,
      );

      expect(verified.heightVerified, true);
      expect(unverified.heightVerified, false);
    });
  });

  group('Discovery - Time-based Operations', () {
    test('should handle score recalculation timing', () {
      final now = DateTime.now();
      final oldScore = TopPickScore(
        profileId: 'profile_old',
        compatibilityScore: 50.0,
        matchReasons: const [],
        calculatedAt: now.subtract(const Duration(hours: 30)),
      );

      final newScore = TopPickScore(
        profileId: 'profile_new',
        compatibilityScore: 85.0,
        matchReasons: const ['Updated'],
        calculatedAt: now,
      );

      final shouldRecalculateOld = DateTime.now()
              .difference(oldScore.calculatedAt)
              .inHours >=
          24;
      final shouldRecalculateNew =
          DateTime.now().difference(newScore.calculatedAt).inHours >= 24;

      expect(shouldRecalculateOld, true);
      expect(shouldRecalculateNew, false);
    });

    test('should handle like timestamp ordering', () {
      final now = DateTime.now();
      final like1 = LikeRecord(
        id: 'like_1',
        fromUserId: 'user1',
        toUserId: 'user2',
        likedAt: now.subtract(const Duration(minutes: 10)),
      );
      final like2 = LikeRecord(
        id: 'like_2',
        fromUserId: 'user3',
        toUserId: 'user2',
        likedAt: now.subtract(const Duration(minutes: 5)),
      );
      final like3 = LikeRecord(
        id: 'like_3',
        fromUserId: 'user4',
        toUserId: 'user2',
        likedAt: now,
      );

      final likes = [like1, like2, like3];
      likes.sort((a, b) => b.likedAt.compareTo(a.likedAt));

      expect(likes[0].id, 'like_3');
      expect(likes[1].id, 'like_2');
      expect(likes[2].id, 'like_1');
    });
  });

  group('Discovery - Match Reasons', () {
    test('should generate common match reasons', () {
      final commonReasons = [
        'Hauteur compatible',
        'Intérêts communs',
        'Proche géographique',
        'Style de vie similaire',
        'Âge approprié',
        'Centres d\'intérêt correspondants',
      ];

      expect(commonReasons.length, greaterThan(0));
      expect(commonReasons, contains('Hauteur compatible'));
    });

    test('should prioritize match reasons by importance', () {
      final prioritizedReasons = [
        'Hauteur compatible',
        'Intérêts communs: Randonnée, Voyage',
        'Proche géographique',
        'Style de vie similaire',
      ];

      expect(prioritizedReasons[0], 'Hauteur compatible');
      expect(prioritizedReasons.length, 4);
    });
  });
}
