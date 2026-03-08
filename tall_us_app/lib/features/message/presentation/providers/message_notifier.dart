import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/message/data/datasources/message_remote_datasource.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';
import 'package:tall_us/features/message/presentation/providers/message_state.dart';

/// Notifier for chat messages
class MessageNotifier extends StateNotifier<MessageState> {
  final MessageRemoteDataSource dataSource;
  String _currentMatchId = '';

  MessageNotifier(this.dataSource) : super(const MessageState.initial());

  /// Load messages for a match
  Future<void> loadMessages(String matchId) async {
    _currentMatchId = matchId;
    state = const MessageState.loading();

    try {
      AppLogger.i('Loading messages for match: $matchId');

      final messages = await dataSource.getMessages(matchId);

      AppLogger.i('Loaded ${messages.length} messages');

      state = MessageState.loaded(messages);
    } catch (e) {
      AppLogger.e('Failed to load messages', error: e);
      state = MessageState.error(e.toString());
    }
  }

  /// Send a message
  Future<void> sendMessage({
    required String matchId,
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {
      AppLogger.i('Sending message to $receiverId');

      final message = await dataSource.sendMessage(
        matchId: matchId,
        senderId: senderId,
        receiverId: receiverId,
        content: content,
      );

      // Add message to current state
      state.whenOrNull(
        loaded: (messages) {
          state = MessageState.loaded([...messages, message]);
        },
      );

      AppLogger.i('Message sent successfully');
    } catch (e) {
      AppLogger.e('Failed to send message', error: e);
    }
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await dataSource.markAsRead(messageId);
    } catch (e) {
      AppLogger.e('Failed to mark message as read', error: e);
    }
  }

  /// Subscribe to real-time messages
  void subscribeToMessages(String matchId) {
    _currentMatchId = matchId;

    dataSource.subscribeToMessages(matchId, (newMessage) {
      AppLogger.i('New message received: ${newMessage.id}');

      state.whenOrNull(
        loaded: (messages) {
          // Check if message already exists
          if (!messages.any((m) => m.id == newMessage.id)) {
            state = MessageState.loaded([...messages, newMessage]);
          }
        },
      );
    });
  }

  /// Unsubscribe from messages
  void unsubscribe() {
    dataSource.unsubscribe();
  }

  /// Reset state
  void reset() {
    dataSource.unsubscribe();
    _currentMatchId = '';
    state = const MessageState.initial();
  }
}
