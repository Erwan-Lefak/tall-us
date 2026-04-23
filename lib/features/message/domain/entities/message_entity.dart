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

  // NEW: Media support
  final String? mediaUrl;
  final int? duration; // For audio/video in seconds
  final bool isPriority; // Priority message (from super like)
  final List<MessageReaction>? reactions; // Emoji reactions
  final MessageReply? replyTo; // Reply to another message

  const MessageEntity({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.readAt,
    this.isRead = false,
    this.mediaUrl,
    this.duration,
    this.isPriority = false,
    this.reactions,
    this.replyTo,
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
        mediaUrl,
        duration,
        isPriority,
        reactions,
        replyTo,
      ];

  MessageEntity copyWith({
    String? id,
    String? matchId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isRead,
    String? mediaUrl,
    int? duration,
    bool? isPriority,
    List<MessageReaction>? reactions,
    MessageReply? replyTo,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      duration: duration ?? this.duration,
      isPriority: isPriority ?? this.isPriority,
      reactions: reactions ?? this.reactions,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}

/// Message type enum
enum MessageType {
  text,
  image,
  gif,
  audio,
  video,
  system,
  icebreaker,
}

/// Message reaction
class MessageReaction extends Equatable {
  final String emoji;
  final String senderId;
  final DateTime createdAt;

  const MessageReaction({
    required this.emoji,
    required this.senderId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [emoji, senderId, createdAt];
}

/// Message reply
class MessageReply extends Equatable {
  final String messageId;
  final String content;
  final String senderName;

  const MessageReply({
    required this.messageId,
    required this.content,
    required this.senderName,
  });

  @override
  List<Object?> get props => [messageId, content, senderName];
}
