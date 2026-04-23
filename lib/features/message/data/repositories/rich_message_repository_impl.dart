import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/message/domain/entities/rich_message_entities.dart';

/// Rich Messages Repository Interface
abstract class RichMessageRepository {
  // ==================== Messages ====================

  /// Send a rich message
  Future<RichMessage> sendMessage(RichMessage message);

  /// Get messages for a match
  Future<List<RichMessage>> getMessages(String matchId,
      {int limit, int offset});

  /// Mark message as seen
  Future<void> markAsSeen(String messageId);

  // ==================== Reactions ====================

  /// Add reaction to message
  Future<MessageReaction> addReaction(MessageReaction reaction);

  /// Remove reaction from message
  Future<void> removeReaction(String messageId, String userId);

  /// Get reactions for a message
  Future<List<MessageReaction>> getMessageReactions(String messageId);

  // ==================== Realtime ====================

  /// Subscribe to new messages in a conversation
  Stream<RichMessage> subscribeToMessages(String matchId);
}

/// Appwrite implementation of Rich Message Repository
class RichMessageRepositoryImpl implements RichMessageRepository {
  final Databases _databases;
  final Realtime _realtime;

  RichMessageRepositoryImpl({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  @override
  Future<RichMessage> sendMessage(RichMessage message) async {
    try {
      AppLogger.i('Sending message of type: ${message.type}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        documentId: message.id,
        data: {
          'senderId': message.senderId,
          'type': message.type.name,
          'content': message.content,
          'mediaUrl': message.mediaUrl,
          'thumbnailUrl': message.thumbnailUrl,
          'repliedToMessageId': message.repliedToMessageId,
          'timestamp': message.timestamp.toIso8601String(),
          'isSeen': message.isSeen,
          'metadata': message.metadata,
          'matchId': message.id.split('_')[0], // Extract matchId from messageId
        },
        permissions: {
          Permission.read(Role.users(message.senderId)),
          Permission.read(Role.users(message.id.split('_')[1])), // Other user
        },
      );

      AppLogger.i('Message sent successfully: ${document.$id}');
      return message.copyWith(id: document.$id);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to send message', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<RichMessage>> getMessages(String matchId,
      {int limit = 50, int offset = 0}) async {
    try {
      AppLogger.i('Fetching messages for match $matchId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        queries: [
          Query.equal('matchId', matchId),
          Query.orderDesc('timestamp'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      final messages = documents.documents.map((doc) {
        final data = doc.data;
        final typeStr = data['type'] ?? 'text';
        final type = MessageType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => MessageType.text,
        );

        return RichMessage(
          id: doc.$id,
          senderId: data['senderId'] ?? '',
          type: type,
          content: data['content'],
          mediaUrl: data['mediaUrl'],
          thumbnailUrl: data['thumbnailUrl'],
          repliedToMessageId: data['repliedToMessageId'],
          timestamp: DateTime.parse(data['timestamp']),
          isSeen: data['isSeen'] ?? false,
          metadata: Map<String, String>.from(data['metadata'] ?? {}),
        );
      }).toList();

      AppLogger.i('Retrieved ${messages.length} messages');
      return messages;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch messages', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> markAsSeen(String messageId) async {
    try {
      AppLogger.i('Marking message $messageId as seen');

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        documentId: messageId,
        data: {'isSeen': true},
      );

      AppLogger.i('Message marked as seen');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to mark message as seen',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<MessageReaction> addReaction(MessageReaction reaction) async {
    try {
      AppLogger.i(
          'Adding reaction: ${reaction.emoji} to message ${reaction.messageId}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messageReactionsCollection,
        documentId: '${reaction.messageId}_${reaction.userId}',
        data: {
          'messageId': reaction.messageId,
          'userId': reaction.userId,
          'emoji': reaction.emoji,
          'reactedAt': reaction.reactedAt.toIso8601String(),
        },
      );

      AppLogger.i('Reaction added successfully');
      return reaction;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to add reaction', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> removeReaction(String messageId, String userId) async {
    try {
      AppLogger.i('Removing reaction from message $messageId by user $userId');

      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messageReactionsCollection,
        documentId: '${messageId}_$userId',
      );

      AppLogger.i('Reaction removed successfully');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to remove reaction',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<MessageReaction>> getMessageReactions(String messageId) async {
    try {
      AppLogger.i('Fetching reactions for message $messageId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messageReactionsCollection,
        queries: [
          Query.equal('messageId', messageId),
        ],
      );

      final reactions = documents.documents.map((doc) {
        final data = doc.data;
        return MessageReaction(
          messageId: data['messageId'] ?? '',
          userId: data['userId'] ?? '',
          emoji: data['emoji'] ?? '',
          reactedAt: DateTime.parse(data['reactedAt']),
        );
      }).toList();

      AppLogger.i('Retrieved ${reactions.length} reactions');
      return reactions;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch reactions',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Stream<RichMessage> subscribeToMessages(String matchId) {
    return _realtime
        .subscribe(
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.messagesCollection}.documents',
    )
        .map((event) {
      if (event.events.isNotEmpty) {
        final payload = event.events.first.payload;
        final typeStr = payload['type'] ?? 'text';
        final type = MessageType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => MessageType.text,
        );

        return RichMessage(
          id: payload['\$id'] ?? '',
          senderId: payload['senderId'] ?? '',
          type: type,
          content: payload['content'],
          mediaUrl: payload['mediaUrl'],
          thumbnailUrl: payload['thumbnailUrl'],
          repliedToMessageId: payload['repliedToMessageId'],
          timestamp: DateTime.parse(payload['timestamp']),
          isSeen: payload['isSeen'] ?? false,
          metadata: Map<String, String>.from(payload['metadata'] ?? {}),
        );
      }
      throw Exception('Invalid realtime event');
    });
  }
}
