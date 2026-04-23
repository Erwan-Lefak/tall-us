// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rich_message_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RichMessage _$RichMessageFromJson(Map<String, dynamic> json) {
  return _RichMessage.fromJson(json);
}

/// @nodoc
mixin _$RichMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get repliedToMessageId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isSeen => throw _privateConstructorUsedError;
  Map<String, String> get metadata => throw _privateConstructorUsedError;

  /// Serializes this RichMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RichMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RichMessageCopyWith<RichMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RichMessageCopyWith<$Res> {
  factory $RichMessageCopyWith(
          RichMessage value, $Res Function(RichMessage) then) =
      _$RichMessageCopyWithImpl<$Res, RichMessage>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      MessageType type,
      String? content,
      String? mediaUrl,
      String? thumbnailUrl,
      String? repliedToMessageId,
      DateTime timestamp,
      bool isSeen,
      Map<String, String> metadata});
}

/// @nodoc
class _$RichMessageCopyWithImpl<$Res, $Val extends RichMessage>
    implements $RichMessageCopyWith<$Res> {
  _$RichMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RichMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? type = null,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? repliedToMessageId = freezed,
    Object? timestamp = null,
    Object? isSeen = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      repliedToMessageId: freezed == repliedToMessageId
          ? _value.repliedToMessageId
          : repliedToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RichMessageImplCopyWith<$Res>
    implements $RichMessageCopyWith<$Res> {
  factory _$$RichMessageImplCopyWith(
          _$RichMessageImpl value, $Res Function(_$RichMessageImpl) then) =
      __$$RichMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      MessageType type,
      String? content,
      String? mediaUrl,
      String? thumbnailUrl,
      String? repliedToMessageId,
      DateTime timestamp,
      bool isSeen,
      Map<String, String> metadata});
}

/// @nodoc
class __$$RichMessageImplCopyWithImpl<$Res>
    extends _$RichMessageCopyWithImpl<$Res, _$RichMessageImpl>
    implements _$$RichMessageImplCopyWith<$Res> {
  __$$RichMessageImplCopyWithImpl(
      _$RichMessageImpl _value, $Res Function(_$RichMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of RichMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? type = null,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? repliedToMessageId = freezed,
    Object? timestamp = null,
    Object? isSeen = null,
    Object? metadata = null,
  }) {
    return _then(_$RichMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      repliedToMessageId: freezed == repliedToMessageId
          ? _value.repliedToMessageId
          : repliedToMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RichMessageImpl implements _RichMessage {
  const _$RichMessageImpl(
      {required this.id,
      required this.senderId,
      required this.type,
      this.content,
      this.mediaUrl,
      this.thumbnailUrl,
      this.repliedToMessageId,
      required this.timestamp,
      this.isSeen = false,
      final Map<String, String> metadata = const {}})
      : _metadata = metadata;

  factory _$RichMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$RichMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final MessageType type;
  @override
  final String? content;
  @override
  final String? mediaUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? repliedToMessageId;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isSeen;
  final Map<String, String> _metadata;
  @override
  @JsonKey()
  Map<String, String> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'RichMessage(id: $id, senderId: $senderId, type: $type, content: $content, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, repliedToMessageId: $repliedToMessageId, timestamp: $timestamp, isSeen: $isSeen, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RichMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.repliedToMessageId, repliedToMessageId) ||
                other.repliedToMessageId == repliedToMessageId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderId,
      type,
      content,
      mediaUrl,
      thumbnailUrl,
      repliedToMessageId,
      timestamp,
      isSeen,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of RichMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RichMessageImplCopyWith<_$RichMessageImpl> get copyWith =>
      __$$RichMessageImplCopyWithImpl<_$RichMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RichMessageImplToJson(
      this,
    );
  }
}

abstract class _RichMessage implements RichMessage {
  const factory _RichMessage(
      {required final String id,
      required final String senderId,
      required final MessageType type,
      final String? content,
      final String? mediaUrl,
      final String? thumbnailUrl,
      final String? repliedToMessageId,
      required final DateTime timestamp,
      final bool isSeen,
      final Map<String, String> metadata}) = _$RichMessageImpl;

  factory _RichMessage.fromJson(Map<String, dynamic> json) =
      _$RichMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  MessageType get type;
  @override
  String? get content;
  @override
  String? get mediaUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get repliedToMessageId;
  @override
  DateTime get timestamp;
  @override
  bool get isSeen;
  @override
  Map<String, String> get metadata;

  /// Create a copy of RichMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RichMessageImplCopyWith<_$RichMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageReaction _$MessageReactionFromJson(Map<String, dynamic> json) {
  return _MessageReaction.fromJson(json);
}

/// @nodoc
mixin _$MessageReaction {
  String get messageId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  DateTime get reactedAt => throw _privateConstructorUsedError;

  /// Serializes this MessageReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageReactionCopyWith<MessageReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageReactionCopyWith<$Res> {
  factory $MessageReactionCopyWith(
          MessageReaction value, $Res Function(MessageReaction) then) =
      _$MessageReactionCopyWithImpl<$Res, MessageReaction>;
  @useResult
  $Res call(
      {String messageId, String userId, String emoji, DateTime reactedAt});
}

/// @nodoc
class _$MessageReactionCopyWithImpl<$Res, $Val extends MessageReaction>
    implements $MessageReactionCopyWith<$Res> {
  _$MessageReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? userId = null,
    Object? emoji = null,
    Object? reactedAt = null,
  }) {
    return _then(_value.copyWith(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      reactedAt: null == reactedAt
          ? _value.reactedAt
          : reactedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageReactionImplCopyWith<$Res>
    implements $MessageReactionCopyWith<$Res> {
  factory _$$MessageReactionImplCopyWith(_$MessageReactionImpl value,
          $Res Function(_$MessageReactionImpl) then) =
      __$$MessageReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String messageId, String userId, String emoji, DateTime reactedAt});
}

/// @nodoc
class __$$MessageReactionImplCopyWithImpl<$Res>
    extends _$MessageReactionCopyWithImpl<$Res, _$MessageReactionImpl>
    implements _$$MessageReactionImplCopyWith<$Res> {
  __$$MessageReactionImplCopyWithImpl(
      _$MessageReactionImpl _value, $Res Function(_$MessageReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? userId = null,
    Object? emoji = null,
    Object? reactedAt = null,
  }) {
    return _then(_$MessageReactionImpl(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      reactedAt: null == reactedAt
          ? _value.reactedAt
          : reactedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageReactionImpl implements _MessageReaction {
  const _$MessageReactionImpl(
      {required this.messageId,
      required this.userId,
      required this.emoji,
      required this.reactedAt});

  factory _$MessageReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageReactionImplFromJson(json);

  @override
  final String messageId;
  @override
  final String userId;
  @override
  final String emoji;
  @override
  final DateTime reactedAt;

  @override
  String toString() {
    return 'MessageReaction(messageId: $messageId, userId: $userId, emoji: $emoji, reactedAt: $reactedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageReactionImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.reactedAt, reactedAt) ||
                other.reactedAt == reactedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, messageId, userId, emoji, reactedAt);

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageReactionImplCopyWith<_$MessageReactionImpl> get copyWith =>
      __$$MessageReactionImplCopyWithImpl<_$MessageReactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageReactionImplToJson(
      this,
    );
  }
}

abstract class _MessageReaction implements MessageReaction {
  const factory _MessageReaction(
      {required final String messageId,
      required final String userId,
      required final String emoji,
      required final DateTime reactedAt}) = _$MessageReactionImpl;

  factory _MessageReaction.fromJson(Map<String, dynamic> json) =
      _$MessageReactionImpl.fromJson;

  @override
  String get messageId;
  @override
  String get userId;
  @override
  String get emoji;
  @override
  DateTime get reactedAt;

  /// Create a copy of MessageReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageReactionImplCopyWith<_$MessageReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationMetadata _$ConversationMetadataFromJson(Map<String, dynamic> json) {
  return _ConversationMetadata.fromJson(json);
}

/// @nodoc
mixin _$ConversationMetadata {
  String get matchId => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  String? get lastMessagePreview => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;

  /// Serializes this ConversationMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationMetadataCopyWith<ConversationMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationMetadataCopyWith<$Res> {
  factory $ConversationMetadataCopyWith(ConversationMetadata value,
          $Res Function(ConversationMetadata) then) =
      _$ConversationMetadataCopyWithImpl<$Res, ConversationMetadata>;
  @useResult
  $Res call(
      {String matchId,
      int unreadCount,
      DateTime? lastMessageAt,
      String? lastMessagePreview,
      Map<String, dynamic> settings});
}

/// @nodoc
class _$ConversationMetadataCopyWithImpl<$Res,
        $Val extends ConversationMetadata>
    implements $ConversationMetadataCopyWith<$Res> {
  _$ConversationMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? unreadCount = null,
    Object? lastMessageAt = freezed,
    Object? lastMessagePreview = freezed,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationMetadataImplCopyWith<$Res>
    implements $ConversationMetadataCopyWith<$Res> {
  factory _$$ConversationMetadataImplCopyWith(_$ConversationMetadataImpl value,
          $Res Function(_$ConversationMetadataImpl) then) =
      __$$ConversationMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String matchId,
      int unreadCount,
      DateTime? lastMessageAt,
      String? lastMessagePreview,
      Map<String, dynamic> settings});
}

/// @nodoc
class __$$ConversationMetadataImplCopyWithImpl<$Res>
    extends _$ConversationMetadataCopyWithImpl<$Res, _$ConversationMetadataImpl>
    implements _$$ConversationMetadataImplCopyWith<$Res> {
  __$$ConversationMetadataImplCopyWithImpl(_$ConversationMetadataImpl _value,
      $Res Function(_$ConversationMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? unreadCount = null,
    Object? lastMessageAt = freezed,
    Object? lastMessagePreview = freezed,
    Object? settings = null,
  }) {
    return _then(_$ConversationMetadataImpl(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationMetadataImpl implements _ConversationMetadata {
  const _$ConversationMetadataImpl(
      {required this.matchId,
      this.unreadCount = 0,
      this.lastMessageAt,
      this.lastMessagePreview,
      final Map<String, dynamic> settings = const {}})
      : _settings = settings;

  factory _$ConversationMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationMetadataImplFromJson(json);

  @override
  final String matchId;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final DateTime? lastMessageAt;
  @override
  final String? lastMessagePreview;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  String toString() {
    return 'ConversationMetadata(matchId: $matchId, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt, lastMessagePreview: $lastMessagePreview, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationMetadataImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessagePreview, lastMessagePreview) ||
                other.lastMessagePreview == lastMessagePreview) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matchId,
      unreadCount,
      lastMessageAt,
      lastMessagePreview,
      const DeepCollectionEquality().hash(_settings));

  /// Create a copy of ConversationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationMetadataImplCopyWith<_$ConversationMetadataImpl>
      get copyWith =>
          __$$ConversationMetadataImplCopyWithImpl<_$ConversationMetadataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationMetadataImplToJson(
      this,
    );
  }
}

abstract class _ConversationMetadata implements ConversationMetadata {
  const factory _ConversationMetadata(
      {required final String matchId,
      final int unreadCount,
      final DateTime? lastMessageAt,
      final String? lastMessagePreview,
      final Map<String, dynamic> settings}) = _$ConversationMetadataImpl;

  factory _ConversationMetadata.fromJson(Map<String, dynamic> json) =
      _$ConversationMetadataImpl.fromJson;

  @override
  String get matchId;
  @override
  int get unreadCount;
  @override
  DateTime? get lastMessageAt;
  @override
  String? get lastMessagePreview;
  @override
  Map<String, dynamic> get settings;

  /// Create a copy of ConversationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationMetadataImplCopyWith<_$ConversationMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
