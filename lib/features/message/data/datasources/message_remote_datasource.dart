import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';

/// Remote data source for messages with Appwrite Realtime support
class MessageRemoteDataSource {
  final Databases _databases;
  final Realtime _realtime;
  RealtimeSubscription? _subscription;

  MessageRemoteDataSource({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  /// Send a message
  Future<MessageEntity> sendMessage({
    required String matchId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    try {
      AppLogger.i('Sending message to $receiverId');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        documentId: ID.unique(),
        data: {
          'matchId': matchId,
          'senderId': senderId,
          'receiverId': receiverId,
          'content': content,
          'type': type.name,
          'createdAt': DateTime.now().toIso8601String(),
          'isRead': false,
        },
        permissions: [
          Permission.read(Role.user(senderId)),
          Permission.read(Role.user(receiverId)),
        ],
      );

      AppLogger.i('Message sent successfully: ${document.$id}');

      return MessageEntity(
        id: document.$id,
        matchId: document.data['matchId'],
        senderId: document.data['senderId'],
        content: document.data['content'],
        type: _parseMessageType(document.data['type']),
        createdAt: DateTime.parse(document.data['createdAt']),
        isRead: document.data['isRead'] ?? false,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to send message', error: e);
      rethrow;
    }
  }

  /// Get messages for a match
  Future<List<MessageEntity>> getMessages(String matchId) async {
    try {
      AppLogger.i('Fetching messages for match: $matchId');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        queries: [
          Query.equal('matchId', matchId),
          Query.orderDesc('createdAt'),
          Query.limit(100),
        ],
      );

      final messages = documents.documents.map((doc) {
        return MessageEntity(
          id: doc.$id,
          matchId: doc.data['matchId'],
          senderId: doc.data['senderId'],
          content: doc.data['content'],
          type: _parseMessageType(doc.data['type']),
          createdAt: DateTime.parse(doc.data['createdAt']),
          isRead: doc.data['isRead'] ?? false,
        );
      }).toList();

      // Reverse to show oldest first
      final reversedMessages = messages.reversed.toList();

      AppLogger.i('Fetched ${reversedMessages.length} messages');

      return reversedMessages;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to fetch messages', error: e);
      rethrow;
    }
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollection,
        documentId: messageId,
        data: {
          'isRead': true,
          'readAt': DateTime.now().toIso8601String(),
        },
      );

      AppLogger.i('Message marked as read: $messageId');
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to mark message as read', error: e);
      rethrow;
    }
  }

  /// Subscribe to real-time messages for a match
  void subscribeToMessages(
    String matchId,
    void Function(MessageEntity) onMessage,
  ) {
    AppLogger.i('Realtime subscription - TODO: Implement Appwrite Realtime properly');
    // TODO: Implement Appwrite Realtime
    // The API has changed, need to check the correct implementation
    // For now, messages will be loaded manually
  }

  /// Unsubscribe from real-time messages
  void unsubscribe() {
    _subscription?.close();
    _subscription = null;
    AppLogger.i('Unsubscribed from messages');
  }

  MessageType _parseMessageType(String type) {
    return MessageType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MessageType.text,
    );
  }
}
