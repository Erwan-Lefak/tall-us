import 'package:equatable/equatable.dart';

/// Entity representing a chat message
class MessageEntity extends Equatable {
  final String id;
  final String matchId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.readAt,
    this.isRead = false,
  });

  /// Check if message was sent by current user
  bool isFromUser(String userId) {
    return senderId == userId;
  }

  @override
  List<Object?> get props => [
        id,
        matchId,
        senderId,
        content,
        type,
        createdAt,
        readAt,
        isRead,
      ];
}

/// Message type enum
enum MessageType {
  text,
  image,
  system,
  icebreaker,
}
