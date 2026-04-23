// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rich_message_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RichMessageImpl _$$RichMessageImplFromJson(Map<String, dynamic> json) =>
    _$RichMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      repliedToMessageId: json['repliedToMessageId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSeen: json['isSeen'] as bool? ?? false,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$RichMessageImplToJson(_$RichMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'content': instance.content,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'repliedToMessageId': instance.repliedToMessageId,
      'timestamp': instance.timestamp.toIso8601String(),
      'isSeen': instance.isSeen,
      'metadata': instance.metadata,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.gif: 'gif',
  MessageType.audio: 'audio',
  MessageType.video: 'video',
  MessageType.reaction: 'reaction',
  MessageType.reply: 'reply',
  MessageType.location: 'location',
  MessageType.system: 'system',
};

_$MessageReactionImpl _$$MessageReactionImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageReactionImpl(
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      emoji: json['emoji'] as String,
      reactedAt: DateTime.parse(json['reactedAt'] as String),
    );

Map<String, dynamic> _$$MessageReactionImplToJson(
        _$MessageReactionImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'userId': instance.userId,
      'emoji': instance.emoji,
      'reactedAt': instance.reactedAt.toIso8601String(),
    };

_$ConversationMetadataImpl _$$ConversationMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationMetadataImpl(
      matchId: json['matchId'] as String,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ConversationMetadataImplToJson(
        _$ConversationMetadataImpl instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'unreadCount': instance.unreadCount,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessagePreview': instance.lastMessagePreview,
      'settings': instance.settings,
    };
