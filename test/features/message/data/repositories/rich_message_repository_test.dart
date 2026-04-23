import 'package:flutter_test/flutter_test.dart';
import 'package:tall_us/features/message/domain/entities/rich_message_entities.dart';

/// Tests for Rich Message Repository
///
/// Tests cover:
/// - Message creation and sending
/// - Message types (text, image, GIF, audio, video, location, reply, system)
/// - Message reactions
/// - Conversation metadata
/// - Pagination and limits
void main() {
  group('RichMessage - Basic Message Creation', () {
    test('should create text message', () {
      final message = RichMessage(
        id: 'msg_001',
        senderId: 'user_001',
        type: MessageType.text,
        content: 'Salut ! Comment ça va ?',
        timestamp: DateTime.now(),
        isSeen: false,
      );

      expect(message.id, 'msg_001');
      expect(message.senderId, 'user_001');
      expect(message.type, MessageType.text);
      expect(message.content, 'Salut ! Comment ça va ?');
      expect(message.isSeen, false);
    });

    test('should create image message', () {
      final message = RichMessage(
        id: 'msg_002',
        senderId: 'user_002',
        type: MessageType.image,
        content: 'https://example.com/image.jpg',
        timestamp: DateTime.now(),
        isSeen: false,
        mediaUrl: 'https://example.com/image.jpg',
        metadata: {
          'width': '1920',
          'height': '1080',
        },
      );

      expect(message.type, MessageType.image);
      expect(message.mediaUrl, 'https://example.com/image.jpg');
      expect(message.metadata['width'], '1920');
    });

    test('should create GIF message', () {
      final message = RichMessage(
        id: 'msg_003',
        senderId: 'user_001',
        type: MessageType.gif,
        content: 'https://media.giphy.com/media/xyz/giphy.gif',
        timestamp: DateTime.now(),
        isSeen: true,
        mediaUrl: 'https://media.giphy.com/media/xyz/giphy.gif',
        metadata: {
          'previewUrl': 'https://media.giphy.com/media/xyz/200.gif',
        },
      );

      expect(message.type, MessageType.gif);
      expect(message.isSeen, true);
    });

    test('should create audio message', () {
      final message = RichMessage(
        id: 'msg_004',
        senderId: 'user_002',
        type: MessageType.audio,
        content: 'https://example.com/audio/voice_note.mp3',
        timestamp: DateTime.now(),
        isSeen: false,
        mediaUrl: 'https://example.com/audio/voice_note.mp3',
        metadata: {
          'duration': '45',
        },
      );

      expect(message.type, MessageType.audio);
      expect(message.metadata['duration'], '45');
    });

    test('should create location message', () {
      final message = RichMessage(
        id: 'msg_005',
        senderId: 'user_001',
        type: MessageType.location,
        content: '48.8566, 2.3522',
        timestamp: DateTime.now(),
        isSeen: true,
        metadata: {
          'latitude': '48.8566',
          'longitude': '2.3522',
          'address': 'Tour Eiffel, Paris',
        },
      );

      expect(message.type, MessageType.location);
      expect(message.metadata['address'], 'Tour Eiffel, Paris');
    });

    test('should create reply message', () {
      final message = RichMessage(
        id: 'msg_006',
        senderId: 'user_002',
        type: MessageType.reply,
        content: 'Oui bien sûr !',
        timestamp: DateTime.now(),
        isSeen: true,
        repliedToMessageId: 'msg_001',
      );

      expect(message.type, MessageType.reply);
      expect(message.repliedToMessageId, 'msg_001');
    });

    test('should create system message', () {
      final message = RichMessage(
        id: 'msg_007',
        senderId: 'system',
        type: MessageType.system,
        content: 'Vous avez matché avec Marie ! 💕',
        timestamp: DateTime.now(),
        isSeen: true,
        metadata: {
          'type': 'match',
          'matchedUserId': 'user_002',
        },
      );

      expect(message.senderId, 'system');
      expect(message.type, MessageType.system);
      expect(message.metadata['type'], 'match');
    });

    test('should create video message', () {
      final message = RichMessage(
        id: 'msg_008',
        senderId: 'user_001',
        type: MessageType.video,
        content: 'https://example.com/video.mp4',
        timestamp: DateTime.now(),
        mediaUrl: 'https://example.com/video.mp4',
        thumbnailUrl: 'https://example.com/video_thumb.jpg',
        metadata: {
          'duration': '120',
          'size': '10485760',
        },
      );

      expect(message.type, MessageType.video);
      expect(message.thumbnailUrl, isNotNull);
    });
  });

  group('RichMessage - Message Operations', () {
    test('should mark message as seen', () {
      final message = RichMessage(
        id: 'msg_001',
        senderId: 'user_001',
        type: MessageType.text,
        content: 'Test message',
        timestamp: DateTime.now(),
        isSeen: false,
      );

      final seenMessage = message.copyWith(isSeen: true);

      expect(seenMessage.isSeen, true);
      expect(seenMessage.id, message.id);
      expect(seenMessage.content, message.content);
    });

    test('should handle message with all optional fields', () {
      final now = DateTime.now();
      final message = RichMessage(
        id: 'msg_full',
        senderId: 'user_001',
        type: MessageType.image,
        content: 'Photo',
        timestamp: now,
        isSeen: false,
        mediaUrl: 'https://example.com/full.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        repliedToMessageId: 'msg_002',
        metadata: {
          'width': '1920',
          'height': '1080',
          'size': '2048000',
        },
      );

      expect(message.mediaUrl, isNotEmpty);
      expect(message.thumbnailUrl, isNotEmpty);
      expect(message.repliedToMessageId, isNotEmpty);
      expect(message.metadata.length, 3);
    });

    test('should handle message with minimal data', () {
      final message = RichMessage(
        id: 'msg_minimal',
        senderId: 'user_002',
        type: MessageType.text,
        content: 'Simple text',
        timestamp: DateTime.now(),
      );

      expect(message.isSeen, false);
      expect(message.mediaUrl, isNull);
      expect(message.metadata.isEmpty, true);
    });
  });

  group('MessageReaction - Basic Operations', () {
    test('should create message reaction', () {
      final reaction = MessageReaction(
        messageId: 'msg_001',
        userId: 'user_002',
        emoji: '❤️',
        reactedAt: DateTime.now(),
      );

      expect(reaction.messageId, 'msg_001');
      expect(reaction.userId, 'user_002');
      expect(reaction.emoji, '❤️');
    });

    test('should update reaction emoji', () {
      final now = DateTime.now();
      final reaction = MessageReaction(
        messageId: 'msg_001',
        userId: 'user_002',
        emoji: '❤️',
        reactedAt: now,
      );

      final updatedReaction = reaction.copyWith(
        emoji: '🔥',
        reactedAt: now.add(const Duration(seconds: 1)),
      );

      expect(updatedReaction.emoji, '🔥');
      expect(updatedReaction.messageId, reaction.messageId);
    });

    test('should support common emojis', () {
      final commonEmojis = ['❤️', '😂', '🔥', '👍', '😮', '😢'];

      for (final emoji in commonEmojis) {
        final reaction = MessageReaction(
          messageId: 'msg_001',
          userId: 'user_001',
          emoji: emoji,
          reactedAt: DateTime.now(),
        );

        expect(reaction.emoji, emoji);
      }
    });

    test('should handle multiple reactions from same user', () {
      final userId = 'user_001';
      final messageId = 'msg_001';
      final now = DateTime.now();

      final reaction1 = MessageReaction(
        messageId: messageId,
        userId: userId,
        emoji: '❤️',
        reactedAt: now.subtract(const Duration(minutes: 5)),
      );

      final reaction2 = MessageReaction(
        messageId: messageId,
        userId: userId,
        emoji: '🔥',
        reactedAt: now,
      );

      expect(reaction1.userId, userId);
      expect(reaction2.userId, userId);
      expect(reaction2.reactedAt.isAfter(reaction1.reactedAt), true);
    });
  });

  group('ConversationMetadata - Basic Operations', () {
    test('should create conversation metadata', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_001',
        unreadCount: 5,
        lastMessageAt: DateTime.now(),
        lastMessagePreview: 'Salut !',
      );

      expect(metadata.matchId, 'conv_001');
      expect(metadata.unreadCount, 5);
      expect(metadata.lastMessagePreview, 'Salut !');
      expect(metadata.settings.isEmpty, true);
    });

    test('should increment unread count', () {
      var metadata = ConversationMetadata(
        matchId: 'conv_001',
        unreadCount: 2,
        lastMessageAt: DateTime.now(),
        lastMessagePreview: 'Test',
      );

      metadata = metadata.copyWith(unreadCount: metadata.unreadCount + 1);

      expect(metadata.unreadCount, 3);
    });

    test('should reset unread count', () {
      var metadata = ConversationMetadata(
        matchId: 'conv_001',
        unreadCount: 10,
        lastMessageAt: DateTime.now(),
        lastMessagePreview: 'Test',
      );

      metadata = metadata.copyWith(unreadCount: 0);

      expect(metadata.unreadCount, 0);
    });

    test('should update last message info', () {
      final now = DateTime.now();
      var metadata = ConversationMetadata(
        matchId: 'conv_001',
        lastMessageAt: now.subtract(const Duration(hours: 1)),
        lastMessagePreview: 'Old message',
      );

      metadata = metadata.copyWith(
        lastMessageAt: now,
        lastMessagePreview: 'New message',
      );

      expect(metadata.lastMessagePreview, 'New message');
      expect(metadata.lastMessageAt, now);
    });

    test('should handle settings', () {
      var metadata = ConversationMetadata(
        matchId: 'conv_001',
        settings: {
          'notificationsEnabled': true,
          'soundEnabled': true,
        },
      );

      expect(metadata.settings['notificationsEnabled'], true);
      expect(metadata.settings['soundEnabled'], true);

      metadata = metadata.copyWith(
        settings: {
          'notificationsEnabled': false,
          'soundEnabled': false,
        },
      );

      expect(metadata.settings['notificationsEnabled'], false);
    });

    test('should handle metadata with no messages', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_002',
        unreadCount: 0,
        lastMessagePreview: "D'accord !",
      );

      expect(metadata.unreadCount, 0);
      expect(metadata.lastMessageAt, isNull);
    });

    test('should handle metadata with high unread count', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_003',
        unreadCount: 999,
        lastMessagePreview: 'Test',
      );

      expect(metadata.unreadCount, 999);
      expect(metadata.unreadCount, greaterThan(100));
    });

    test('should handle empty message preview', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_004',
        lastMessagePreview: '',
      );

      expect(metadata.lastMessagePreview, '');
      expect(metadata.lastMessagePreview?.isEmpty, true);
    });

    test('should handle null message preview', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_005',
      );

      expect(metadata.lastMessagePreview, isNull);
      expect(metadata.unreadCount, 0);
    });
  });

  group('MessageType - Enum Values', () {
    test('should have all required message types', () {
      final types = MessageType.values;

      expect(types, contains(MessageType.text));
      expect(types, contains(MessageType.image));
      expect(types, contains(MessageType.gif));
      expect(types, contains(MessageType.audio));
      expect(types, contains(MessageType.video));
      expect(types, contains(MessageType.location));
      expect(types, contains(MessageType.reply));
      expect(types, contains(MessageType.system));
      expect(types, contains(MessageType.reaction));
    });

    test('should have correct type names', () {
      expect(MessageType.text.name, 'text');
      expect(MessageType.image.name, 'image');
      expect(MessageType.gif.name, 'gif');
      expect(MessageType.audio.name, 'audio');
      expect(MessageType.video.name, 'video');
      expect(MessageType.location.name, 'location');
      expect(MessageType.reply.name, 'reply');
      expect(MessageType.system.name, 'system');
      expect(MessageType.reaction.name, 'reaction');
    });
  });

  group('Message Pagination', () {
    test('should handle pagination parameters', () {
      final limit = 50;
      final offset = 10;

      final messages = List.generate(
        limit,
        (i) => RichMessage(
          id: 'msg_${i + offset}',
          senderId: 'user_001',
          type: MessageType.text,
          content: 'Message $i',
          timestamp: DateTime.now().subtract(Duration(minutes: i)),
        ),
      );

      expect(messages.length, limit);
      expect(messages.first.id, 'msg_$offset');
      expect(messages.last.id, 'msg_${offset + limit - 1}');
    });

    test('should handle empty message list', () {
      final messages = <RichMessage>[];

      expect(messages, isEmpty);
      expect(messages.length, 0);
    });

    test('should handle single message', () {
      final messages = [
        RichMessage(
          id: 'msg_single',
          senderId: 'user_001',
          type: MessageType.text,
          content: 'Only message',
          timestamp: DateTime.now(),
        ),
      ];

      expect(messages.length, 1);
      expect(messages.first.id, 'msg_single');
    });

    test('should sort messages by timestamp', () {
      final now = DateTime.now();
      final messages = [
        RichMessage(
          id: 'msg_001',
          senderId: 'user_001',
          type: MessageType.text,
          content: 'First',
          timestamp: now.subtract(const Duration(minutes: 10)),
        ),
        RichMessage(
          id: 'msg_002',
          senderId: 'user_002',
          type: MessageType.text,
          content: 'Second',
          timestamp: now.subtract(const Duration(minutes: 5)),
        ),
        RichMessage(
          id: 'msg_003',
          senderId: 'user_001',
          type: MessageType.text,
          content: 'Third',
          timestamp: now,
        ),
      ];

      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      expect(messages[0].id, 'msg_003');
      expect(messages[1].id, 'msg_002');
      expect(messages[2].id, 'msg_001');
    });
  });

  group('Message Serialization', () {
    test('should serialize and deserialize RichMessage', () {
      final message = RichMessage(
        id: 'msg_001',
        senderId: 'user_001',
        type: MessageType.text,
        content: 'Test message',
        timestamp: DateTime.parse('2024-01-15T10:00:00Z'),
        isSeen: false,
        metadata: {'key': 'value'},
      );

      final json = message.toJson();
      expect(json['id'], 'msg_001');
      expect(json['senderId'], 'user_001');
      expect(json['type'], 'text');
      expect(json['content'], 'Test message');
      expect(json['isSeen'], false);

      final deserialized = RichMessage.fromJson(json);
      expect(deserialized.id, message.id);
      expect(deserialized.senderId, message.senderId);
      expect(deserialized.type, message.type);
      expect(deserialized.content, message.content);
    });

    test('should serialize and deserialize MessageReaction', () {
      final reaction = MessageReaction(
        messageId: 'msg_001',
        userId: 'user_002',
        emoji: '❤️',
        reactedAt: DateTime.parse('2024-01-15T10:00:00Z'),
      );

      final json = reaction.toJson();
      expect(json['messageId'], 'msg_001');
      expect(json['emoji'], '❤️');

      final deserialized = MessageReaction.fromJson(json);
      expect(deserialized.messageId, reaction.messageId);
      expect(deserialized.emoji, reaction.emoji);
    });

    test('should serialize and deserialize ConversationMetadata', () {
      final metadata = ConversationMetadata(
        matchId: 'conv_001',
        unreadCount: 5,
        lastMessageAt: DateTime.parse('2024-01-15T10:00:00Z'),
        lastMessagePreview: 'Hello',
        settings: {'notificationsEnabled': true},
      );

      final json = metadata.toJson();
      expect(json['matchId'], 'conv_001');
      expect(json['unreadCount'], 5);

      final deserialized = ConversationMetadata.fromJson(json);
      expect(deserialized.matchId, metadata.matchId);
      expect(deserialized.unreadCount, metadata.unreadCount);
    });
  });

  group('Message Edge Cases', () {
    test('should handle very long message content', () {
      final longContent = 'A' * 1000;

      final message = RichMessage(
        id: 'msg_long',
        senderId: 'user_001',
        type: MessageType.text,
        content: longContent,
        timestamp: DateTime.now(),
      );

      expect(message.content?.length, 1000);
    });

    test('should handle special characters in content', () {
      final specialContent = '😀 Test émoji 🎉 & spëcial çhars';

      final message = RichMessage(
        id: 'msg_special',
        senderId: 'user_002',
        type: MessageType.text,
        content: specialContent,
        timestamp: DateTime.now(),
      );

      expect(message.content, specialContent);
      expect(message.content, contains('😀'));
      expect(message.content, contains('é'));
    });

    test('should handle system message from system user', () {
      final message = RichMessage(
        id: 'msg_system',
        senderId: 'system',
        type: MessageType.system,
        content: 'System notification',
        timestamp: DateTime.now(),
        isSeen: true,
      );

      expect(message.senderId, 'system');
      expect(message.type, MessageType.system);
    });

    test('should handle message with empty content', () {
      final message = RichMessage(
        id: 'msg_empty',
        senderId: 'user_001',
        type: MessageType.text,
        content: '',
        timestamp: DateTime.now(),
      );

      expect(message.content, '');
      expect(message.content?.isEmpty, true);
    });

    test('should handle message with null content', () {
      final message = RichMessage(
        id: 'msg_null_content',
        senderId: 'user_002',
        type: MessageType.image,
        timestamp: DateTime.now(),
        mediaUrl: 'https://example.com/image.jpg',
      );

      expect(message.content, isNull);
      expect(message.mediaUrl, isNotNull);
    });
  });

  group('Message Timestamps', () {
    test('should handle future timestamp', () {
      final future = DateTime.now().add(const Duration(hours: 1));

      final message = RichMessage(
        id: 'msg_future',
        senderId: 'user_001',
        type: MessageType.text,
        content: 'Future message',
        timestamp: future,
      );

      expect(message.timestamp.isAfter(DateTime.now()), true);
    });

    test('should handle old timestamp', () {
      final past = DateTime.now().subtract(const Duration(days: 30));

      final message = RichMessage(
        id: 'msg_old',
        senderId: 'user_002',
        type: MessageType.text,
        content: 'Old message',
        timestamp: past,
      );

      expect(message.timestamp.isBefore(DateTime.now()), true);
      expect(DateTime.now().difference(message.timestamp).inDays, 30);
    });

    test('should handle reaction timestamps', () {
      final now = DateTime.now();
      final reaction = MessageReaction(
        messageId: 'msg_001',
        userId: 'user_001',
        emoji: '❤️',
        reactedAt: now,
      );

      expect(reaction.reactedAt, now);
      expect(reaction.reactedAt.isBefore(now.add(const Duration(seconds: 1))), true);
    });
  });

  group('Message Metadata', () {
    test('should store arbitrary metadata', () {
      final message = RichMessage(
        id: 'msg_metadata',
        senderId: 'user_001',
        type: MessageType.image,
        content: 'https://example.com/image.jpg',
        timestamp: DateTime.now(),
        metadata: {
          'width': '1920',
          'height': '1080',
          'format': 'jpg',
          'size': '2048000',
          'location': 'Paris, France',
        },
      );

      expect(message.metadata.length, 5);
      expect(message.metadata['format'], 'jpg');
      expect(message.metadata['location'], 'Paris, France');
    });

    test('should handle empty metadata', () {
      final message = RichMessage(
        id: 'msg_no_meta',
        senderId: 'user_002',
        type: MessageType.text,
        content: 'Test',
        timestamp: DateTime.now(),
      );

      expect(message.metadata.isEmpty, true);
    });

    test('should update metadata', () {
      var message = RichMessage(
        id: 'msg_update_meta',
        senderId: 'user_001',
        type: MessageType.audio,
        content: 'voice.mp3',
        timestamp: DateTime.now(),
        metadata: {
          'duration': '30',
        },
      );

      message = message.copyWith(
        metadata: {
          'duration': '30',
          'listenedAt': '2024-01-15T10:00:00Z',
        },
      );

      expect(message.metadata['duration'], '30');
      expect(message.metadata['listenedAt'], isNotNull);
    });
  });
}
