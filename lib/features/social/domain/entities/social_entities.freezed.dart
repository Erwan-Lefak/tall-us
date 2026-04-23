// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialEvent _$SocialEventFromJson(Map<String, dynamic> json) {
  return _SocialEvent.fromJson(json);
}

/// @nodoc
mixin _$SocialEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get attendees => throw _privateConstructorUsedError;
  int get maxAttendees => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SocialEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialEventCopyWith<SocialEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialEventCopyWith<$Res> {
  factory $SocialEventCopyWith(
          SocialEvent value, $Res Function(SocialEvent) then) =
      _$SocialEventCopyWithImpl<$Res, SocialEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String location,
      DateTime dateTime,
      List<String> attendees,
      int maxAttendees,
      String hostId,
      String imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class _$SocialEventCopyWithImpl<$Res, $Val extends SocialEvent>
    implements $SocialEventCopyWith<$Res> {
  _$SocialEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? dateTime = null,
    Object? attendees = null,
    Object? maxAttendees = null,
    Object? hostId = null,
    Object? imageUrl = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attendees: null == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialEventImplCopyWith<$Res>
    implements $SocialEventCopyWith<$Res> {
  factory _$$SocialEventImplCopyWith(
          _$SocialEventImpl value, $Res Function(_$SocialEventImpl) then) =
      __$$SocialEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String location,
      DateTime dateTime,
      List<String> attendees,
      int maxAttendees,
      String hostId,
      String imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class __$$SocialEventImplCopyWithImpl<$Res>
    extends _$SocialEventCopyWithImpl<$Res, _$SocialEventImpl>
    implements _$$SocialEventImplCopyWith<$Res> {
  __$$SocialEventImplCopyWithImpl(
      _$SocialEventImpl _value, $Res Function(_$SocialEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? dateTime = null,
    Object? attendees = null,
    Object? maxAttendees = null,
    Object? hostId = null,
    Object? imageUrl = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$SocialEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attendees: null == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialEventImpl implements _SocialEvent {
  const _$SocialEventImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.location,
      required this.dateTime,
      final List<String> attendees = const [],
      required this.maxAttendees,
      required this.hostId,
      this.imageUrl = '',
      this.createdAt})
      : _attendees = attendees;

  factory _$SocialEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String location;
  @override
  final DateTime dateTime;
  final List<String> _attendees;
  @override
  @JsonKey()
  List<String> get attendees {
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attendees);
  }

  @override
  final int maxAttendees;
  @override
  final String hostId;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SocialEvent(id: $id, title: $title, description: $description, location: $location, dateTime: $dateTime, attendees: $attendees, maxAttendees: $maxAttendees, hostId: $hostId, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      location,
      dateTime,
      const DeepCollectionEquality().hash(_attendees),
      maxAttendees,
      hostId,
      imageUrl,
      createdAt);

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialEventImplCopyWith<_$SocialEventImpl> get copyWith =>
      __$$SocialEventImplCopyWithImpl<_$SocialEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialEventImplToJson(
      this,
    );
  }
}

abstract class _SocialEvent implements SocialEvent {
  const factory _SocialEvent(
      {required final String id,
      required final String title,
      required final String description,
      required final String location,
      required final DateTime dateTime,
      final List<String> attendees,
      required final int maxAttendees,
      required final String hostId,
      final String imageUrl,
      final DateTime? createdAt}) = _$SocialEventImpl;

  factory _SocialEvent.fromJson(Map<String, dynamic> json) =
      _$SocialEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get location;
  @override
  DateTime get dateTime;
  @override
  List<String> get attendees;
  @override
  int get maxAttendees;
  @override
  String get hostId;
  @override
  String get imageUrl;
  @override
  DateTime? get createdAt;

  /// Create a copy of SocialEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialEventImplCopyWith<_$SocialEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialGroup _$SocialGroupFromJson(Map<String, dynamic> json) {
  return _SocialGroup.fromJson(json);
}

/// @nodoc
mixin _$SocialGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  int get maxMembers => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SocialGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialGroupCopyWith<SocialGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialGroupCopyWith<$Res> {
  factory $SocialGroupCopyWith(
          SocialGroup value, $Res Function(SocialGroup) then) =
      _$SocialGroupCopyWithImpl<$Res, SocialGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String category,
      List<String> members,
      int maxMembers,
      String hostId,
      String imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class _$SocialGroupCopyWithImpl<$Res, $Val extends SocialGroup>
    implements $SocialGroupCopyWith<$Res> {
  _$SocialGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? members = null,
    Object? maxMembers = null,
    Object? hostId = null,
    Object? imageUrl = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialGroupImplCopyWith<$Res>
    implements $SocialGroupCopyWith<$Res> {
  factory _$$SocialGroupImplCopyWith(
          _$SocialGroupImpl value, $Res Function(_$SocialGroupImpl) then) =
      __$$SocialGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String category,
      List<String> members,
      int maxMembers,
      String hostId,
      String imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class __$$SocialGroupImplCopyWithImpl<$Res>
    extends _$SocialGroupCopyWithImpl<$Res, _$SocialGroupImpl>
    implements _$$SocialGroupImplCopyWith<$Res> {
  __$$SocialGroupImplCopyWithImpl(
      _$SocialGroupImpl _value, $Res Function(_$SocialGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? members = null,
    Object? maxMembers = null,
    Object? hostId = null,
    Object? imageUrl = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$SocialGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxMembers: null == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialGroupImpl implements _SocialGroup {
  const _$SocialGroupImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      final List<String> members = const [],
      required this.maxMembers,
      required this.hostId,
      this.imageUrl = '',
      this.createdAt})
      : _members = members;

  factory _$SocialGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String category;
  final List<String> _members;
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final int maxMembers;
  @override
  final String hostId;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SocialGroup(id: $id, name: $name, description: $description, category: $category, members: $members, maxMembers: $maxMembers, hostId: $hostId, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      const DeepCollectionEquality().hash(_members),
      maxMembers,
      hostId,
      imageUrl,
      createdAt);

  /// Create a copy of SocialGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialGroupImplCopyWith<_$SocialGroupImpl> get copyWith =>
      __$$SocialGroupImplCopyWithImpl<_$SocialGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialGroupImplToJson(
      this,
    );
  }
}

abstract class _SocialGroup implements SocialGroup {
  const factory _SocialGroup(
      {required final String id,
      required final String name,
      required final String description,
      required final String category,
      final List<String> members,
      required final int maxMembers,
      required final String hostId,
      final String imageUrl,
      final DateTime? createdAt}) = _$SocialGroupImpl;

  factory _SocialGroup.fromJson(Map<String, dynamic> json) =
      _$SocialGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get category;
  @override
  List<String> get members;
  @override
  int get maxMembers;
  @override
  String get hostId;
  @override
  String get imageUrl;
  @override
  DateTime? get createdAt;

  /// Create a copy of SocialGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialGroupImplCopyWith<_$SocialGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhotoMetadata _$PhotoMetadataFromJson(Map<String, dynamic> json) {
  return _PhotoMetadata.fromJson(json);
}

/// @nodoc
mixin _$PhotoMetadata {
  String get photoId => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get matchCount => throw _privateConstructorUsedError;
  double get smartScore => throw _privateConstructorUsedError;
  DateTime? get lastScoreUpdate => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;

  /// Serializes this PhotoMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoMetadataCopyWith<PhotoMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoMetadataCopyWith<$Res> {
  factory $PhotoMetadataCopyWith(
          PhotoMetadata value, $Res Function(PhotoMetadata) then) =
      _$PhotoMetadataCopyWithImpl<$Res, PhotoMetadata>;
  @useResult
  $Res call(
      {String photoId,
      String url,
      String? caption,
      int displayOrder,
      int likeCount,
      int viewCount,
      int matchCount,
      double smartScore,
      DateTime? lastScoreUpdate,
      bool? isVerified});
}

/// @nodoc
class _$PhotoMetadataCopyWithImpl<$Res, $Val extends PhotoMetadata>
    implements $PhotoMetadataCopyWith<$Res> {
  _$PhotoMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoId = null,
    Object? url = null,
    Object? caption = freezed,
    Object? displayOrder = null,
    Object? likeCount = null,
    Object? viewCount = null,
    Object? matchCount = null,
    Object? smartScore = null,
    Object? lastScoreUpdate = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_value.copyWith(
      photoId: null == photoId
          ? _value.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      matchCount: null == matchCount
          ? _value.matchCount
          : matchCount // ignore: cast_nullable_to_non_nullable
              as int,
      smartScore: null == smartScore
          ? _value.smartScore
          : smartScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastScoreUpdate: freezed == lastScoreUpdate
          ? _value.lastScoreUpdate
          : lastScoreUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoMetadataImplCopyWith<$Res>
    implements $PhotoMetadataCopyWith<$Res> {
  factory _$$PhotoMetadataImplCopyWith(
          _$PhotoMetadataImpl value, $Res Function(_$PhotoMetadataImpl) then) =
      __$$PhotoMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String photoId,
      String url,
      String? caption,
      int displayOrder,
      int likeCount,
      int viewCount,
      int matchCount,
      double smartScore,
      DateTime? lastScoreUpdate,
      bool? isVerified});
}

/// @nodoc
class __$$PhotoMetadataImplCopyWithImpl<$Res>
    extends _$PhotoMetadataCopyWithImpl<$Res, _$PhotoMetadataImpl>
    implements _$$PhotoMetadataImplCopyWith<$Res> {
  __$$PhotoMetadataImplCopyWithImpl(
      _$PhotoMetadataImpl _value, $Res Function(_$PhotoMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoId = null,
    Object? url = null,
    Object? caption = freezed,
    Object? displayOrder = null,
    Object? likeCount = null,
    Object? viewCount = null,
    Object? matchCount = null,
    Object? smartScore = null,
    Object? lastScoreUpdate = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_$PhotoMetadataImpl(
      photoId: null == photoId
          ? _value.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      matchCount: null == matchCount
          ? _value.matchCount
          : matchCount // ignore: cast_nullable_to_non_nullable
              as int,
      smartScore: null == smartScore
          ? _value.smartScore
          : smartScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastScoreUpdate: freezed == lastScoreUpdate
          ? _value.lastScoreUpdate
          : lastScoreUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoMetadataImpl implements _PhotoMetadata {
  const _$PhotoMetadataImpl(
      {required this.photoId,
      required this.url,
      this.caption,
      required this.displayOrder,
      this.likeCount = 0,
      this.viewCount = 0,
      this.matchCount = 0,
      this.smartScore = 50.0,
      this.lastScoreUpdate,
      this.isVerified});

  factory _$PhotoMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoMetadataImplFromJson(json);

  @override
  final String photoId;
  @override
  final String url;
  @override
  final String? caption;
  @override
  final int displayOrder;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int viewCount;
  @override
  @JsonKey()
  final int matchCount;
  @override
  @JsonKey()
  final double smartScore;
  @override
  final DateTime? lastScoreUpdate;
  @override
  final bool? isVerified;

  @override
  String toString() {
    return 'PhotoMetadata(photoId: $photoId, url: $url, caption: $caption, displayOrder: $displayOrder, likeCount: $likeCount, viewCount: $viewCount, matchCount: $matchCount, smartScore: $smartScore, lastScoreUpdate: $lastScoreUpdate, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoMetadataImpl &&
            (identical(other.photoId, photoId) || other.photoId == photoId) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.matchCount, matchCount) ||
                other.matchCount == matchCount) &&
            (identical(other.smartScore, smartScore) ||
                other.smartScore == smartScore) &&
            (identical(other.lastScoreUpdate, lastScoreUpdate) ||
                other.lastScoreUpdate == lastScoreUpdate) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      photoId,
      url,
      caption,
      displayOrder,
      likeCount,
      viewCount,
      matchCount,
      smartScore,
      lastScoreUpdate,
      isVerified);

  /// Create a copy of PhotoMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoMetadataImplCopyWith<_$PhotoMetadataImpl> get copyWith =>
      __$$PhotoMetadataImplCopyWithImpl<_$PhotoMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoMetadataImplToJson(
      this,
    );
  }
}

abstract class _PhotoMetadata implements PhotoMetadata {
  const factory _PhotoMetadata(
      {required final String photoId,
      required final String url,
      final String? caption,
      required final int displayOrder,
      final int likeCount,
      final int viewCount,
      final int matchCount,
      final double smartScore,
      final DateTime? lastScoreUpdate,
      final bool? isVerified}) = _$PhotoMetadataImpl;

  factory _PhotoMetadata.fromJson(Map<String, dynamic> json) =
      _$PhotoMetadataImpl.fromJson;

  @override
  String get photoId;
  @override
  String get url;
  @override
  String? get caption;
  @override
  int get displayOrder;
  @override
  int get likeCount;
  @override
  int get viewCount;
  @override
  int get matchCount;
  @override
  double get smartScore;
  @override
  DateTime? get lastScoreUpdate;
  @override
  bool? get isVerified;

  /// Create a copy of PhotoMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoMetadataImplCopyWith<_$PhotoMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileExtended _$UserProfileExtendedFromJson(Map<String, dynamic> json) {
  return _UserProfileExtended.fromJson(json);
}

/// @nodoc
mixin _$UserProfileExtended {
  String get userId => throw _privateConstructorUsedError; // Job & Education
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get company => throw _privateConstructorUsedError;
  String? get school => throw _privateConstructorUsedError;
  String? get degree => throw _privateConstructorUsedError; // Lifestyle
  String? get drinkingPreference => throw _privateConstructorUsedError;
  String? get smokingPreference => throw _privateConstructorUsedError;
  String? get workoutFrequency =>
      throw _privateConstructorUsedError; // Identity
  List<String> get genders => throw _privateConstructorUsedError;
  String? get pronouns => throw _privateConstructorUsedError;
  String? get zodiacSign =>
      throw _privateConstructorUsedError; // Photos metadata
  List<PhotoMetadata> get photos =>
      throw _privateConstructorUsedError; // Social connections
  List<String> get friendIds => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfileExtended to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileExtended
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileExtendedCopyWith<UserProfileExtended> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileExtendedCopyWith<$Res> {
  factory $UserProfileExtendedCopyWith(
          UserProfileExtended value, $Res Function(UserProfileExtended) then) =
      _$UserProfileExtendedCopyWithImpl<$Res, UserProfileExtended>;
  @useResult
  $Res call(
      {String userId,
      String? jobTitle,
      String? company,
      String? school,
      String? degree,
      String? drinkingPreference,
      String? smokingPreference,
      String? workoutFrequency,
      List<String> genders,
      String? pronouns,
      String? zodiacSign,
      List<PhotoMetadata> photos,
      List<String> friendIds,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileExtendedCopyWithImpl<$Res, $Val extends UserProfileExtended>
    implements $UserProfileExtendedCopyWith<$Res> {
  _$UserProfileExtendedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileExtended
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? jobTitle = freezed,
    Object? company = freezed,
    Object? school = freezed,
    Object? degree = freezed,
    Object? drinkingPreference = freezed,
    Object? smokingPreference = freezed,
    Object? workoutFrequency = freezed,
    Object? genders = null,
    Object? pronouns = freezed,
    Object? zodiacSign = freezed,
    Object? photos = null,
    Object? friendIds = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      degree: freezed == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkingPreference: freezed == drinkingPreference
          ? _value.drinkingPreference
          : drinkingPreference // ignore: cast_nullable_to_non_nullable
              as String?,
      smokingPreference: freezed == smokingPreference
          ? _value.smokingPreference
          : smokingPreference // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutFrequency: freezed == workoutFrequency
          ? _value.workoutFrequency
          : workoutFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      genders: null == genders
          ? _value.genders
          : genders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pronouns: freezed == pronouns
          ? _value.pronouns
          : pronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      zodiacSign: freezed == zodiacSign
          ? _value.zodiacSign
          : zodiacSign // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PhotoMetadata>,
      friendIds: null == friendIds
          ? _value.friendIds
          : friendIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileExtendedImplCopyWith<$Res>
    implements $UserProfileExtendedCopyWith<$Res> {
  factory _$$UserProfileExtendedImplCopyWith(_$UserProfileExtendedImpl value,
          $Res Function(_$UserProfileExtendedImpl) then) =
      __$$UserProfileExtendedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? jobTitle,
      String? company,
      String? school,
      String? degree,
      String? drinkingPreference,
      String? smokingPreference,
      String? workoutFrequency,
      List<String> genders,
      String? pronouns,
      String? zodiacSign,
      List<PhotoMetadata> photos,
      List<String> friendIds,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileExtendedImplCopyWithImpl<$Res>
    extends _$UserProfileExtendedCopyWithImpl<$Res, _$UserProfileExtendedImpl>
    implements _$$UserProfileExtendedImplCopyWith<$Res> {
  __$$UserProfileExtendedImplCopyWithImpl(_$UserProfileExtendedImpl _value,
      $Res Function(_$UserProfileExtendedImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileExtended
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? jobTitle = freezed,
    Object? company = freezed,
    Object? school = freezed,
    Object? degree = freezed,
    Object? drinkingPreference = freezed,
    Object? smokingPreference = freezed,
    Object? workoutFrequency = freezed,
    Object? genders = null,
    Object? pronouns = freezed,
    Object? zodiacSign = freezed,
    Object? photos = null,
    Object? friendIds = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileExtendedImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String?,
      school: freezed == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String?,
      degree: freezed == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String?,
      drinkingPreference: freezed == drinkingPreference
          ? _value.drinkingPreference
          : drinkingPreference // ignore: cast_nullable_to_non_nullable
              as String?,
      smokingPreference: freezed == smokingPreference
          ? _value.smokingPreference
          : smokingPreference // ignore: cast_nullable_to_non_nullable
              as String?,
      workoutFrequency: freezed == workoutFrequency
          ? _value.workoutFrequency
          : workoutFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
      genders: null == genders
          ? _value._genders
          : genders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pronouns: freezed == pronouns
          ? _value.pronouns
          : pronouns // ignore: cast_nullable_to_non_nullable
              as String?,
      zodiacSign: freezed == zodiacSign
          ? _value.zodiacSign
          : zodiacSign // ignore: cast_nullable_to_non_nullable
              as String?,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PhotoMetadata>,
      friendIds: null == friendIds
          ? _value._friendIds
          : friendIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileExtendedImpl implements _UserProfileExtended {
  const _$UserProfileExtendedImpl(
      {required this.userId,
      this.jobTitle,
      this.company,
      this.school,
      this.degree,
      this.drinkingPreference,
      this.smokingPreference,
      this.workoutFrequency,
      final List<String> genders = const [],
      this.pronouns,
      this.zodiacSign,
      final List<PhotoMetadata> photos = const [],
      final List<String> friendIds = const [],
      this.updatedAt})
      : _genders = genders,
        _photos = photos,
        _friendIds = friendIds;

  factory _$UserProfileExtendedImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileExtendedImplFromJson(json);

  @override
  final String userId;
// Job & Education
  @override
  final String? jobTitle;
  @override
  final String? company;
  @override
  final String? school;
  @override
  final String? degree;
// Lifestyle
  @override
  final String? drinkingPreference;
  @override
  final String? smokingPreference;
  @override
  final String? workoutFrequency;
// Identity
  final List<String> _genders;
// Identity
  @override
  @JsonKey()
  List<String> get genders {
    if (_genders is EqualUnmodifiableListView) return _genders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genders);
  }

  @override
  final String? pronouns;
  @override
  final String? zodiacSign;
// Photos metadata
  final List<PhotoMetadata> _photos;
// Photos metadata
  @override
  @JsonKey()
  List<PhotoMetadata> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

// Social connections
  final List<String> _friendIds;
// Social connections
  @override
  @JsonKey()
  List<String> get friendIds {
    if (_friendIds is EqualUnmodifiableListView) return _friendIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendIds);
  }

  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfileExtended(userId: $userId, jobTitle: $jobTitle, company: $company, school: $school, degree: $degree, drinkingPreference: $drinkingPreference, smokingPreference: $smokingPreference, workoutFrequency: $workoutFrequency, genders: $genders, pronouns: $pronouns, zodiacSign: $zodiacSign, photos: $photos, friendIds: $friendIds, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileExtendedImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.drinkingPreference, drinkingPreference) ||
                other.drinkingPreference == drinkingPreference) &&
            (identical(other.smokingPreference, smokingPreference) ||
                other.smokingPreference == smokingPreference) &&
            (identical(other.workoutFrequency, workoutFrequency) ||
                other.workoutFrequency == workoutFrequency) &&
            const DeepCollectionEquality().equals(other._genders, _genders) &&
            (identical(other.pronouns, pronouns) ||
                other.pronouns == pronouns) &&
            (identical(other.zodiacSign, zodiacSign) ||
                other.zodiacSign == zodiacSign) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality()
                .equals(other._friendIds, _friendIds) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      jobTitle,
      company,
      school,
      degree,
      drinkingPreference,
      smokingPreference,
      workoutFrequency,
      const DeepCollectionEquality().hash(_genders),
      pronouns,
      zodiacSign,
      const DeepCollectionEquality().hash(_photos),
      const DeepCollectionEquality().hash(_friendIds),
      updatedAt);

  /// Create a copy of UserProfileExtended
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileExtendedImplCopyWith<_$UserProfileExtendedImpl> get copyWith =>
      __$$UserProfileExtendedImplCopyWithImpl<_$UserProfileExtendedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileExtendedImplToJson(
      this,
    );
  }
}

abstract class _UserProfileExtended implements UserProfileExtended {
  const factory _UserProfileExtended(
      {required final String userId,
      final String? jobTitle,
      final String? company,
      final String? school,
      final String? degree,
      final String? drinkingPreference,
      final String? smokingPreference,
      final String? workoutFrequency,
      final List<String> genders,
      final String? pronouns,
      final String? zodiacSign,
      final List<PhotoMetadata> photos,
      final List<String> friendIds,
      final DateTime? updatedAt}) = _$UserProfileExtendedImpl;

  factory _UserProfileExtended.fromJson(Map<String, dynamic> json) =
      _$UserProfileExtendedImpl.fromJson;

  @override
  String get userId; // Job & Education
  @override
  String? get jobTitle;
  @override
  String? get company;
  @override
  String? get school;
  @override
  String? get degree; // Lifestyle
  @override
  String? get drinkingPreference;
  @override
  String? get smokingPreference;
  @override
  String? get workoutFrequency; // Identity
  @override
  List<String> get genders;
  @override
  String? get pronouns;
  @override
  String? get zodiacSign; // Photos metadata
  @override
  List<PhotoMetadata> get photos; // Social connections
  @override
  List<String> get friendIds;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserProfileExtended
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileExtendedImplCopyWith<_$UserProfileExtendedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopPickScore _$TopPickScoreFromJson(Map<String, dynamic> json) {
  return _TopPickScore.fromJson(json);
}

/// @nodoc
mixin _$TopPickScore {
  String get profileId => throw _privateConstructorUsedError;
  double get compatibilityScore => throw _privateConstructorUsedError;
  List<String> get matchReasons => throw _privateConstructorUsedError;
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this TopPickScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopPickScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopPickScoreCopyWith<TopPickScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopPickScoreCopyWith<$Res> {
  factory $TopPickScoreCopyWith(
          TopPickScore value, $Res Function(TopPickScore) then) =
      _$TopPickScoreCopyWithImpl<$Res, TopPickScore>;
  @useResult
  $Res call(
      {String profileId,
      double compatibilityScore,
      List<String> matchReasons,
      DateTime calculatedAt});
}

/// @nodoc
class _$TopPickScoreCopyWithImpl<$Res, $Val extends TopPickScore>
    implements $TopPickScoreCopyWith<$Res> {
  _$TopPickScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopPickScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? compatibilityScore = null,
    Object? matchReasons = null,
    Object? calculatedAt = null,
  }) {
    return _then(_value.copyWith(
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      compatibilityScore: null == compatibilityScore
          ? _value.compatibilityScore
          : compatibilityScore // ignore: cast_nullable_to_non_nullable
              as double,
      matchReasons: null == matchReasons
          ? _value.matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopPickScoreImplCopyWith<$Res>
    implements $TopPickScoreCopyWith<$Res> {
  factory _$$TopPickScoreImplCopyWith(
          _$TopPickScoreImpl value, $Res Function(_$TopPickScoreImpl) then) =
      __$$TopPickScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String profileId,
      double compatibilityScore,
      List<String> matchReasons,
      DateTime calculatedAt});
}

/// @nodoc
class __$$TopPickScoreImplCopyWithImpl<$Res>
    extends _$TopPickScoreCopyWithImpl<$Res, _$TopPickScoreImpl>
    implements _$$TopPickScoreImplCopyWith<$Res> {
  __$$TopPickScoreImplCopyWithImpl(
      _$TopPickScoreImpl _value, $Res Function(_$TopPickScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopPickScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileId = null,
    Object? compatibilityScore = null,
    Object? matchReasons = null,
    Object? calculatedAt = null,
  }) {
    return _then(_$TopPickScoreImpl(
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      compatibilityScore: null == compatibilityScore
          ? _value.compatibilityScore
          : compatibilityScore // ignore: cast_nullable_to_non_nullable
              as double,
      matchReasons: null == matchReasons
          ? _value._matchReasons
          : matchReasons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      calculatedAt: null == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopPickScoreImpl implements _TopPickScore {
  const _$TopPickScoreImpl(
      {required this.profileId,
      required this.compatibilityScore,
      final List<String> matchReasons = const [],
      required this.calculatedAt})
      : _matchReasons = matchReasons;

  factory _$TopPickScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopPickScoreImplFromJson(json);

  @override
  final String profileId;
  @override
  final double compatibilityScore;
  final List<String> _matchReasons;
  @override
  @JsonKey()
  List<String> get matchReasons {
    if (_matchReasons is EqualUnmodifiableListView) return _matchReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchReasons);
  }

  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'TopPickScore(profileId: $profileId, compatibilityScore: $compatibilityScore, matchReasons: $matchReasons, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopPickScoreImpl &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.compatibilityScore, compatibilityScore) ||
                other.compatibilityScore == compatibilityScore) &&
            const DeepCollectionEquality()
                .equals(other._matchReasons, _matchReasons) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, profileId, compatibilityScore,
      const DeepCollectionEquality().hash(_matchReasons), calculatedAt);

  /// Create a copy of TopPickScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopPickScoreImplCopyWith<_$TopPickScoreImpl> get copyWith =>
      __$$TopPickScoreImplCopyWithImpl<_$TopPickScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopPickScoreImplToJson(
      this,
    );
  }
}

abstract class _TopPickScore implements TopPickScore {
  const factory _TopPickScore(
      {required final String profileId,
      required final double compatibilityScore,
      final List<String> matchReasons,
      required final DateTime calculatedAt}) = _$TopPickScoreImpl;

  factory _TopPickScore.fromJson(Map<String, dynamic> json) =
      _$TopPickScoreImpl.fromJson;

  @override
  String get profileId;
  @override
  double get compatibilityScore;
  @override
  List<String> get matchReasons;
  @override
  DateTime get calculatedAt;

  /// Create a copy of TopPickScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopPickScoreImplCopyWith<_$TopPickScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LikeRecord _$LikeRecordFromJson(Map<String, dynamic> json) {
  return _LikeRecord.fromJson(json);
}

/// @nodoc
mixin _$LikeRecord {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  DateTime get likedAt => throw _privateConstructorUsedError;
  bool get isSeen => throw _privateConstructorUsedError;

  /// Serializes this LikeRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LikeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LikeRecordCopyWith<LikeRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeRecordCopyWith<$Res> {
  factory $LikeRecordCopyWith(
          LikeRecord value, $Res Function(LikeRecord) then) =
      _$LikeRecordCopyWithImpl<$Res, LikeRecord>;
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      DateTime likedAt,
      bool isSeen});
}

/// @nodoc
class _$LikeRecordCopyWithImpl<$Res, $Val extends LikeRecord>
    implements $LikeRecordCopyWith<$Res> {
  _$LikeRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LikeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? likedAt = null,
    Object? isSeen = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      likedAt: null == likedAt
          ? _value.likedAt
          : likedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LikeRecordImplCopyWith<$Res>
    implements $LikeRecordCopyWith<$Res> {
  factory _$$LikeRecordImplCopyWith(
          _$LikeRecordImpl value, $Res Function(_$LikeRecordImpl) then) =
      __$$LikeRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      DateTime likedAt,
      bool isSeen});
}

/// @nodoc
class __$$LikeRecordImplCopyWithImpl<$Res>
    extends _$LikeRecordCopyWithImpl<$Res, _$LikeRecordImpl>
    implements _$$LikeRecordImplCopyWith<$Res> {
  __$$LikeRecordImplCopyWithImpl(
      _$LikeRecordImpl _value, $Res Function(_$LikeRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of LikeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? likedAt = null,
    Object? isSeen = null,
  }) {
    return _then(_$LikeRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      likedAt: null == likedAt
          ? _value.likedAt
          : likedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LikeRecordImpl implements _LikeRecord {
  const _$LikeRecordImpl(
      {required this.id,
      required this.fromUserId,
      required this.toUserId,
      required this.likedAt,
      this.isSeen = false});

  factory _$LikeRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikeRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  final DateTime likedAt;
  @override
  @JsonKey()
  final bool isSeen;

  @override
  String toString() {
    return 'LikeRecord(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, likedAt: $likedAt, isSeen: $isSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikeRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.likedAt, likedAt) || other.likedAt == likedAt) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, fromUserId, toUserId, likedAt, isSeen);

  /// Create a copy of LikeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikeRecordImplCopyWith<_$LikeRecordImpl> get copyWith =>
      __$$LikeRecordImplCopyWithImpl<_$LikeRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikeRecordImplToJson(
      this,
    );
  }
}

abstract class _LikeRecord implements LikeRecord {
  const factory _LikeRecord(
      {required final String id,
      required final String fromUserId,
      required final String toUserId,
      required final DateTime likedAt,
      final bool isSeen}) = _$LikeRecordImpl;

  factory _LikeRecord.fromJson(Map<String, dynamic> json) =
      _$LikeRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  DateTime get likedAt;
  @override
  bool get isSeen;

  /// Create a copy of LikeRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikeRecordImplCopyWith<_$LikeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
