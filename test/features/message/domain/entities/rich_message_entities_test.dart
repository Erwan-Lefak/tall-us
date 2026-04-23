import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/message/domain/entities/rich_message_entities.dart';

/// Tests pour les entités de messagerie enrichie
///
/// Teste la sérialisation, désérialisation, et les méthodes copyWith
/// des entités du domaine message.
void main() {
  group('MessageType', () {
    test('should have all required message types', () {
      expect(MessageType.values.length, 9);
      expect(MessageType.values, contains(MessageType.text));
      expect(MessageType.values, contains(MessageType.image));
      expect(MessageType.values, contains(MessageType.gif));
      expect(MessageType.values, contains(MessageType.audio));
      expect(MessageType.values, contains(MessageType.video));
      expect(MessageType.values, contains(MessageType.reaction));
      expect(MessageType.values, contains(MessageType.reply));
      expect(MessageType.values, contains(MessageType.location));
      expect(MessageType.values, contains(MessageType.system));
    });

    test('should have correct JSON values', () {
      // The @JsonValue annotation ensures the enum values serialize correctly
      expect(MessageType.text.name, 'text');
      expect(MessageType.image.name, 'image');
      expect(MessageType.gif.name, 'gif');
      expect(MessageType.reaction.name, 'reaction');
    });
  });

  group('RichMessage', () {
    final testTimestamp = DateTime.parse('2024-01-15T18:30:00Z');
    final testMessage = RichMessage(
      id: 'msg123',
      senderId: 'user1',
      type: MessageType.text,
      content: 'Hello! How are you?',
      timestamp: testTimestamp,
      isSeen: false,
    );

    test('should create RichMessage with required fields', () {
      expect(testMessage.id, 'msg123');
      expect(testMessage.senderId, 'user1');
      expect(testMessage.type, MessageType.text);
      expect(testMessage.content, 'Hello! How are you?');
      expect(testMessage.timestamp, testTimestamp);
      expect(testMessage.isSeen, false);
    });

    test('should create text message', () {
      final textMsg = testMessage.copyWith(type: MessageType.text);
      expect(textMsg.type, MessageType.text);
      expect(textMsg.content, isNotNull);
    });

    test('should create image message', () {
      final imageMsg = testMessage.copyWith(
        type: MessageType.image,
        mediaUrl: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
      );

      expect(imageMsg.type, MessageType.image);
      expect(imageMsg.mediaUrl, 'https://example.com/image.jpg');
      expect(imageMsg.thumbnailUrl, 'https://example.com/thumb.jpg');
    });

    test('should create GIF message', () {
      final gifMsg = testMessage.copyWith(
        type: MessageType.gif,
        mediaUrl: 'https://giphy.com/gif.gif',
      );

      expect(gifMsg.type, MessageType.gif);
      expect(gifMsg.mediaUrl, 'https://giphy.com/gif.gif');
    });

    test('should create audio message', () {
      final audioMsg = testMessage.copyWith(
        type: MessageType.audio,
        mediaUrl: 'https://example.com/audio.mp3',
        metadata: {'duration': '30s'},
      );

      expect(audioMsg.type, MessageType.audio);
      expect(audioMsg.mediaUrl, 'https://example.com/audio.mp3');
      expect(audioMsg.metadata['duration'], '30s');
    });

    test('should create video message', () {
      final videoMsg = testMessage.copyWith(
        type: MessageType.video,
        mediaUrl: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/video_thumb.jpg',
      );

      expect(videoMsg.type, MessageType.video);
      expect(videoMsg.mediaUrl, 'https://example.com/video.mp4');
    });

    test('should create reply message', () {
      final replyMsg = testMessage.copyWith(
        type: MessageType.reply,
        content: 'I agree!',
        repliedToMessageId: 'msg122',
      );

      expect(replyMsg.type, MessageType.reply);
      expect(replyMsg.repliedToMessageId, 'msg122');
    });

    test('should create location message', () {
      final locationMsg = testMessage.copyWith(
        type: MessageType.location,
        metadata: {
          'latitude': '48.8566',
          'longitude': '2.3522',
          'placeName': 'Paris, France',
        },
      );

      expect(locationMsg.type, MessageType.location);
      expect(locationMsg.metadata['latitude'], '48.8566');
      expect(locationMsg.metadata['longitude'], '2.3522');
    });

    test('should create system message', () {
      final systemMsg = testMessage.copyWith(
        type: MessageType.system,
        content: 'User created a match',
      );

      expect(systemMsg.type, MessageType.system);
      expect(systemMsg.content, 'User created a match');
    });

    test('should mark as seen', () {
      final seen = testMessage.copyWith(isSeen: true);
      expect(seen.isSeen, true);
    });

    test('should copyWith correctly update fields', () {
      final updated = testMessage.copyWith(
        content: 'Updated message',
        isSeen: true,
      );

      expect(updated.content, 'Updated message');
      expect(updated.isSeen, true);
      expect(updated.id, testMessage.id); // unchanged
      expect(updated.senderId, testMessage.senderId); // unchanged
    });

    test('should handle metadata correctly', () {
      final withMetadata = testMessage.copyWith(
        metadata: {
          'replyCount': '3',
          'reactionCount': '5',
        },
      );

      expect(withMetadata.metadata.length, 2);
      expect(withMetadata.metadata['replyCount'], '3');
      expect(withMetadata.metadata['reactionCount'], '5');
    });
  });

  group('MessageReaction', () {
    final testReactionTime = DateTime.parse('2024-01-15T18:30:00Z');
    final testReaction = MessageReaction(
      messageId: 'msg123',
      userId: 'user1',
      emoji: '❤️',
      reactedAt: testReactionTime,
    );

    test('should create MessageReaction correctly', () {
      expect(testReaction.messageId, 'msg123');
      expect(testReaction.userId, 'user1');
      expect(testReaction.emoji, '❤️');
      expect(testReaction.reactedAt, testReactionTime);
    });

    test('should support common emojis', () {
      const validEmojis = ['❤️', '😂', '😮', '😢', '😡', '👍', '🔥', '🎉'];

      for (final emoji in validEmojis) {
        final reaction = testReaction.copyWith(emoji: emoji);
        expect(reaction.emoji, emoji);
      }
    });

    test('should update emoji', () {
      final updated = testReaction.copyWith(emoji: '😂');
      expect(updated.emoji, '😂');
      expect(updated.messageId, testReaction.messageId); // unchanged
    });

    test('should update timestamp', () {
      final newTime = testReactionTime.add(const Duration(minutes: 5));
      final updated = testReaction.copyWith(reactedAt: newTime);

      expect(updated.reactedAt, newTime);
      expect(updated.reactedAt.isAfter(testReactionTime), true);
    });

    test('should handle different reactions from same user', () {
      final reaction1 = testReaction.copyWith(emoji: '❤️');
      final reaction2 = testReaction.copyWith(emoji: '😂');

      expect(reaction1.messageId, reaction2.messageId);
      expect(reaction1.userId, reaction2.userId);
      expect(reaction1.emoji, isNot(equals(reaction2.emoji)));
    });
  });

  group('ConversationMetadata', () {
    final testLastMessageTime = DateTime.parse('2024-01-15T18:30:00Z');
    final testMetadata = ConversationMetadata(
      matchId: 'match123',
      unreadCount: 5,
      lastMessageAt: testLastMessageTime,
      lastMessagePreview: 'See you tomorrow!',
      settings: {
        'notifications_enabled': 'true',
        'sound_enabled': 'false',
      },
    );

    test('should create ConversationMetadata with all fields', () {
      expect(testMetadata.matchId, 'match123');
      expect(testMetadata.unreadCount, 5);
      expect(testMetadata.lastMessageAt, testLastMessageTime);
      expect(testMetadata.lastMessagePreview, 'See you tomorrow!');
    });

    test('should initialize with default values', () {
      final defaultMetadata = ConversationMetadata(
        matchId: 'match456',
      );

      expect(defaultMetadata.matchId, 'match456');
      expect(defaultMetadata.unreadCount, 0);
      expect(defaultMetadata.lastMessageAt, isNull);
      expect(defaultMetadata.lastMessagePreview, isNull);
      expect(defaultMetadata.settings.isEmpty, true);
    });

    test('should increment unread count', () {
      final incremented = testMetadata.copyWith(unreadCount: 6);
      expect(incremented.unreadCount, 6);
    });

    test('should reset unread count', () {
      final reset = testMetadata.copyWith(unreadCount: 0);
      expect(reset.unreadCount, 0);
    });

    test('should update last message info', () {
      final newTime = testLastMessageTime.add(const Duration(minutes: 10));
      final updated = testMetadata.copyWith(
        lastMessageAt: newTime,
        lastMessagePreview: 'New message preview',
      );

      expect(updated.lastMessageAt, newTime);
      expect(updated.lastMessagePreview, 'New message preview');
      expect(updated.matchId, testMetadata.matchId); // unchanged
    });

    test('should update settings', () {
      final updated = testMetadata.copyWith(
        settings: {
          'notifications_enabled': 'false',
          'sound_enabled': 'true',
          'vibration_enabled': 'true',
        },
      );

      expect(updated.settings.length, 3);
      expect(updated.settings['notifications_enabled'], 'false');
      expect(updated.settings['vibration_enabled'], 'true');
    });

    test('should modify single setting', () {
      final updated = testMetadata.copyWith(
        settings: {
          ...testMetadata.settings,
          'sound_enabled': 'true',
        },
      );

      expect(updated.settings['notifications_enabled'], 'true');
      expect(updated.settings['sound_enabled'], 'true');
    });

    test('should handle empty preview', () {
      final withEmptyPreview = testMetadata.copyWith(
        lastMessagePreview: '',
      );

      expect(withEmptyPreview.lastMessagePreview, '');
    });

    test('should update timestamp correctly', () {
      final future = testLastMessageTime.add(const Duration(hours: 1));
      final updated = testMetadata.copyWith(lastMessageAt: future);

      expect(updated.lastMessageAt!.isAfter(testLastMessageTime!), true);
    });
  });
}
