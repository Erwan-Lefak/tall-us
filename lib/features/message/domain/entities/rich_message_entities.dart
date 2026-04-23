import 'package:freezed_annotation/freezed_annotation.dart';

part 'rich_message_entities.freezed.dart';
part 'rich_message_entities.g.dart';

/// Message types enum
enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('gif')
  gif,
  @JsonValue('audio')
  audio,
  @JsonValue('video')
  video,
  @JsonValue('reaction')
  reaction,
  @JsonValue('reply')
  reply,
  @JsonValue('location')
  location,
  @JsonValue('system')
  system,
}

/// Rich message entity
@freezed
class RichMessage with _$RichMessage {
  const factory RichMessage({
    required String id,
    required String senderId,
    required MessageType type,
    String? content,
    String? mediaUrl,
    String? thumbnailUrl,
    String? repliedToMessageId,
    required DateTime timestamp,
    @Default(false) bool isSeen,
    @Default({}) Map<String, String> metadata,
  }) = _RichMessage;

  factory RichMessage.fromJson(Map<String, dynamic> json) =>
      _$RichMessageFromJson(json);
}

/// Message reaction entity
@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String messageId,
    required String userId,
    required String emoji,
    required DateTime reactedAt,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);
}

/// Conversation metadata
@freezed
class ConversationMetadata with _$ConversationMetadata {
  const factory ConversationMetadata({
    required String matchId,
    @Default(0) int unreadCount,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    @Default({}) Map<String, dynamic> settings, // e.g., notifications enabled
  }) = _ConversationMetadata;

  factory ConversationMetadata.fromJson(Map<String, dynamic> json) =>
      _$ConversationMetadataFromJson(json);
}
