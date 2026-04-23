// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialEvent> events) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialEvent> events)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialEvent> events)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EventsStateInitial value) initial,
    required TResult Function(_EventsStateLoading value) loading,
    required TResult Function(_EventsStateLoaded value) loaded,
    required TResult Function(_EventsStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EventsStateInitial value)? initial,
    TResult? Function(_EventsStateLoading value)? loading,
    TResult? Function(_EventsStateLoaded value)? loaded,
    TResult? Function(_EventsStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EventsStateInitial value)? initial,
    TResult Function(_EventsStateLoading value)? loading,
    TResult Function(_EventsStateLoaded value)? loaded,
    TResult Function(_EventsStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventsStateCopyWith<$Res> {
  factory $EventsStateCopyWith(
          EventsState value, $Res Function(EventsState) then) =
      _$EventsStateCopyWithImpl<$Res, EventsState>;
}

/// @nodoc
class _$EventsStateCopyWithImpl<$Res, $Val extends EventsState>
    implements $EventsStateCopyWith<$Res> {
  _$EventsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$EventsStateInitialImplCopyWith<$Res> {
  factory _$$EventsStateInitialImplCopyWith(_$EventsStateInitialImpl value,
          $Res Function(_$EventsStateInitialImpl) then) =
      __$$EventsStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EventsStateInitialImplCopyWithImpl<$Res>
    extends _$EventsStateCopyWithImpl<$Res, _$EventsStateInitialImpl>
    implements _$$EventsStateInitialImplCopyWith<$Res> {
  __$$EventsStateInitialImplCopyWithImpl(_$EventsStateInitialImpl _value,
      $Res Function(_$EventsStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EventsStateInitialImpl implements _EventsStateInitial {
  const _$EventsStateInitialImpl();

  @override
  String toString() {
    return 'EventsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EventsStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialEvent> events) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialEvent> events)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialEvent> events)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EventsStateInitial value) initial,
    required TResult Function(_EventsStateLoading value) loading,
    required TResult Function(_EventsStateLoaded value) loaded,
    required TResult Function(_EventsStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EventsStateInitial value)? initial,
    TResult? Function(_EventsStateLoading value)? loading,
    TResult? Function(_EventsStateLoaded value)? loaded,
    TResult? Function(_EventsStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EventsStateInitial value)? initial,
    TResult Function(_EventsStateLoading value)? loading,
    TResult Function(_EventsStateLoaded value)? loaded,
    TResult Function(_EventsStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _EventsStateInitial implements EventsState {
  const factory _EventsStateInitial() = _$EventsStateInitialImpl;
}

/// @nodoc
abstract class _$$EventsStateLoadingImplCopyWith<$Res> {
  factory _$$EventsStateLoadingImplCopyWith(_$EventsStateLoadingImpl value,
          $Res Function(_$EventsStateLoadingImpl) then) =
      __$$EventsStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EventsStateLoadingImplCopyWithImpl<$Res>
    extends _$EventsStateCopyWithImpl<$Res, _$EventsStateLoadingImpl>
    implements _$$EventsStateLoadingImplCopyWith<$Res> {
  __$$EventsStateLoadingImplCopyWithImpl(_$EventsStateLoadingImpl _value,
      $Res Function(_$EventsStateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EventsStateLoadingImpl implements _EventsStateLoading {
  const _$EventsStateLoadingImpl();

  @override
  String toString() {
    return 'EventsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EventsStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialEvent> events) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialEvent> events)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialEvent> events)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EventsStateInitial value) initial,
    required TResult Function(_EventsStateLoading value) loading,
    required TResult Function(_EventsStateLoaded value) loaded,
    required TResult Function(_EventsStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EventsStateInitial value)? initial,
    TResult? Function(_EventsStateLoading value)? loading,
    TResult? Function(_EventsStateLoaded value)? loaded,
    TResult? Function(_EventsStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EventsStateInitial value)? initial,
    TResult Function(_EventsStateLoading value)? loading,
    TResult Function(_EventsStateLoaded value)? loaded,
    TResult Function(_EventsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _EventsStateLoading implements EventsState {
  const factory _EventsStateLoading() = _$EventsStateLoadingImpl;
}

/// @nodoc
abstract class _$$EventsStateLoadedImplCopyWith<$Res> {
  factory _$$EventsStateLoadedImplCopyWith(_$EventsStateLoadedImpl value,
          $Res Function(_$EventsStateLoadedImpl) then) =
      __$$EventsStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SocialEvent> events});
}

/// @nodoc
class __$$EventsStateLoadedImplCopyWithImpl<$Res>
    extends _$EventsStateCopyWithImpl<$Res, _$EventsStateLoadedImpl>
    implements _$$EventsStateLoadedImplCopyWith<$Res> {
  __$$EventsStateLoadedImplCopyWithImpl(_$EventsStateLoadedImpl _value,
      $Res Function(_$EventsStateLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
  }) {
    return _then(_$EventsStateLoadedImpl(
      null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<SocialEvent>,
    ));
  }
}

/// @nodoc

class _$EventsStateLoadedImpl implements _EventsStateLoaded {
  const _$EventsStateLoadedImpl(final List<SocialEvent> events)
      : _events = events;

  final List<SocialEvent> _events;
  @override
  List<SocialEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  String toString() {
    return 'EventsState.loaded(events: $events)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventsStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._events, _events));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_events));

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventsStateLoadedImplCopyWith<_$EventsStateLoadedImpl> get copyWith =>
      __$$EventsStateLoadedImplCopyWithImpl<_$EventsStateLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialEvent> events) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(events);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialEvent> events)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(events);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialEvent> events)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(events);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EventsStateInitial value) initial,
    required TResult Function(_EventsStateLoading value) loading,
    required TResult Function(_EventsStateLoaded value) loaded,
    required TResult Function(_EventsStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EventsStateInitial value)? initial,
    TResult? Function(_EventsStateLoading value)? loading,
    TResult? Function(_EventsStateLoaded value)? loaded,
    TResult? Function(_EventsStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EventsStateInitial value)? initial,
    TResult Function(_EventsStateLoading value)? loading,
    TResult Function(_EventsStateLoaded value)? loaded,
    TResult Function(_EventsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _EventsStateLoaded implements EventsState {
  const factory _EventsStateLoaded(final List<SocialEvent> events) =
      _$EventsStateLoadedImpl;

  List<SocialEvent> get events;

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventsStateLoadedImplCopyWith<_$EventsStateLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EventsStateErrorImplCopyWith<$Res> {
  factory _$$EventsStateErrorImplCopyWith(_$EventsStateErrorImpl value,
          $Res Function(_$EventsStateErrorImpl) then) =
      __$$EventsStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$EventsStateErrorImplCopyWithImpl<$Res>
    extends _$EventsStateCopyWithImpl<$Res, _$EventsStateErrorImpl>
    implements _$$EventsStateErrorImplCopyWith<$Res> {
  __$$EventsStateErrorImplCopyWithImpl(_$EventsStateErrorImpl _value,
      $Res Function(_$EventsStateErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$EventsStateErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EventsStateErrorImpl implements _EventsStateError {
  const _$EventsStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'EventsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventsStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventsStateErrorImplCopyWith<_$EventsStateErrorImpl> get copyWith =>
      __$$EventsStateErrorImplCopyWithImpl<_$EventsStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialEvent> events) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialEvent> events)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialEvent> events)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_EventsStateInitial value) initial,
    required TResult Function(_EventsStateLoading value) loading,
    required TResult Function(_EventsStateLoaded value) loaded,
    required TResult Function(_EventsStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_EventsStateInitial value)? initial,
    TResult? Function(_EventsStateLoading value)? loading,
    TResult? Function(_EventsStateLoaded value)? loaded,
    TResult? Function(_EventsStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_EventsStateInitial value)? initial,
    TResult Function(_EventsStateLoading value)? loading,
    TResult Function(_EventsStateLoaded value)? loaded,
    TResult Function(_EventsStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _EventsStateError implements EventsState {
  const factory _EventsStateError(final String message) =
      _$EventsStateErrorImpl;

  String get message;

  /// Create a copy of EventsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventsStateErrorImplCopyWith<_$EventsStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GroupsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialGroup> groups) loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialGroup> groups)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialGroup> groups)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GroupsStateInitial value) initial,
    required TResult Function(_GroupsStateLoading value) loading,
    required TResult Function(_GroupsStateLoaded value) loaded,
    required TResult Function(_GroupsStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GroupsStateInitial value)? initial,
    TResult? Function(_GroupsStateLoading value)? loading,
    TResult? Function(_GroupsStateLoaded value)? loaded,
    TResult? Function(_GroupsStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GroupsStateInitial value)? initial,
    TResult Function(_GroupsStateLoading value)? loading,
    TResult Function(_GroupsStateLoaded value)? loaded,
    TResult Function(_GroupsStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupsStateCopyWith<$Res> {
  factory $GroupsStateCopyWith(
          GroupsState value, $Res Function(GroupsState) then) =
      _$GroupsStateCopyWithImpl<$Res, GroupsState>;
}

/// @nodoc
class _$GroupsStateCopyWithImpl<$Res, $Val extends GroupsState>
    implements $GroupsStateCopyWith<$Res> {
  _$GroupsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GroupsStateInitialImplCopyWith<$Res> {
  factory _$$GroupsStateInitialImplCopyWith(_$GroupsStateInitialImpl value,
          $Res Function(_$GroupsStateInitialImpl) then) =
      __$$GroupsStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GroupsStateInitialImplCopyWithImpl<$Res>
    extends _$GroupsStateCopyWithImpl<$Res, _$GroupsStateInitialImpl>
    implements _$$GroupsStateInitialImplCopyWith<$Res> {
  __$$GroupsStateInitialImplCopyWithImpl(_$GroupsStateInitialImpl _value,
      $Res Function(_$GroupsStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GroupsStateInitialImpl implements _GroupsStateInitial {
  const _$GroupsStateInitialImpl();

  @override
  String toString() {
    return 'GroupsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GroupsStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialGroup> groups) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialGroup> groups)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialGroup> groups)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GroupsStateInitial value) initial,
    required TResult Function(_GroupsStateLoading value) loading,
    required TResult Function(_GroupsStateLoaded value) loaded,
    required TResult Function(_GroupsStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GroupsStateInitial value)? initial,
    TResult? Function(_GroupsStateLoading value)? loading,
    TResult? Function(_GroupsStateLoaded value)? loaded,
    TResult? Function(_GroupsStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GroupsStateInitial value)? initial,
    TResult Function(_GroupsStateLoading value)? loading,
    TResult Function(_GroupsStateLoaded value)? loaded,
    TResult Function(_GroupsStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _GroupsStateInitial implements GroupsState {
  const factory _GroupsStateInitial() = _$GroupsStateInitialImpl;
}

/// @nodoc
abstract class _$$GroupsStateLoadingImplCopyWith<$Res> {
  factory _$$GroupsStateLoadingImplCopyWith(_$GroupsStateLoadingImpl value,
          $Res Function(_$GroupsStateLoadingImpl) then) =
      __$$GroupsStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GroupsStateLoadingImplCopyWithImpl<$Res>
    extends _$GroupsStateCopyWithImpl<$Res, _$GroupsStateLoadingImpl>
    implements _$$GroupsStateLoadingImplCopyWith<$Res> {
  __$$GroupsStateLoadingImplCopyWithImpl(_$GroupsStateLoadingImpl _value,
      $Res Function(_$GroupsStateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GroupsStateLoadingImpl implements _GroupsStateLoading {
  const _$GroupsStateLoadingImpl();

  @override
  String toString() {
    return 'GroupsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GroupsStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialGroup> groups) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialGroup> groups)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialGroup> groups)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GroupsStateInitial value) initial,
    required TResult Function(_GroupsStateLoading value) loading,
    required TResult Function(_GroupsStateLoaded value) loaded,
    required TResult Function(_GroupsStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GroupsStateInitial value)? initial,
    TResult? Function(_GroupsStateLoading value)? loading,
    TResult? Function(_GroupsStateLoaded value)? loaded,
    TResult? Function(_GroupsStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GroupsStateInitial value)? initial,
    TResult Function(_GroupsStateLoading value)? loading,
    TResult Function(_GroupsStateLoaded value)? loaded,
    TResult Function(_GroupsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _GroupsStateLoading implements GroupsState {
  const factory _GroupsStateLoading() = _$GroupsStateLoadingImpl;
}

/// @nodoc
abstract class _$$GroupsStateLoadedImplCopyWith<$Res> {
  factory _$$GroupsStateLoadedImplCopyWith(_$GroupsStateLoadedImpl value,
          $Res Function(_$GroupsStateLoadedImpl) then) =
      __$$GroupsStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<SocialGroup> groups});
}

/// @nodoc
class __$$GroupsStateLoadedImplCopyWithImpl<$Res>
    extends _$GroupsStateCopyWithImpl<$Res, _$GroupsStateLoadedImpl>
    implements _$$GroupsStateLoadedImplCopyWith<$Res> {
  __$$GroupsStateLoadedImplCopyWithImpl(_$GroupsStateLoadedImpl _value,
      $Res Function(_$GroupsStateLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
  }) {
    return _then(_$GroupsStateLoadedImpl(
      null == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<SocialGroup>,
    ));
  }
}

/// @nodoc

class _$GroupsStateLoadedImpl implements _GroupsStateLoaded {
  const _$GroupsStateLoadedImpl(final List<SocialGroup> groups)
      : _groups = groups;

  final List<SocialGroup> _groups;
  @override
  List<SocialGroup> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  @override
  String toString() {
    return 'GroupsState.loaded(groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupsStateLoadedImpl &&
            const DeepCollectionEquality().equals(other._groups, _groups));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_groups));

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupsStateLoadedImplCopyWith<_$GroupsStateLoadedImpl> get copyWith =>
      __$$GroupsStateLoadedImplCopyWithImpl<_$GroupsStateLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialGroup> groups) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(groups);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialGroup> groups)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(groups);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialGroup> groups)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(groups);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GroupsStateInitial value) initial,
    required TResult Function(_GroupsStateLoading value) loading,
    required TResult Function(_GroupsStateLoaded value) loaded,
    required TResult Function(_GroupsStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GroupsStateInitial value)? initial,
    TResult? Function(_GroupsStateLoading value)? loading,
    TResult? Function(_GroupsStateLoaded value)? loaded,
    TResult? Function(_GroupsStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GroupsStateInitial value)? initial,
    TResult Function(_GroupsStateLoading value)? loading,
    TResult Function(_GroupsStateLoaded value)? loaded,
    TResult Function(_GroupsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _GroupsStateLoaded implements GroupsState {
  const factory _GroupsStateLoaded(final List<SocialGroup> groups) =
      _$GroupsStateLoadedImpl;

  List<SocialGroup> get groups;

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupsStateLoadedImplCopyWith<_$GroupsStateLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GroupsStateErrorImplCopyWith<$Res> {
  factory _$$GroupsStateErrorImplCopyWith(_$GroupsStateErrorImpl value,
          $Res Function(_$GroupsStateErrorImpl) then) =
      __$$GroupsStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$GroupsStateErrorImplCopyWithImpl<$Res>
    extends _$GroupsStateCopyWithImpl<$Res, _$GroupsStateErrorImpl>
    implements _$$GroupsStateErrorImplCopyWith<$Res> {
  __$$GroupsStateErrorImplCopyWithImpl(_$GroupsStateErrorImpl _value,
      $Res Function(_$GroupsStateErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$GroupsStateErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GroupsStateErrorImpl implements _GroupsStateError {
  const _$GroupsStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'GroupsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupsStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupsStateErrorImplCopyWith<_$GroupsStateErrorImpl> get copyWith =>
      __$$GroupsStateErrorImplCopyWithImpl<_$GroupsStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<SocialGroup> groups) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<SocialGroup> groups)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<SocialGroup> groups)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GroupsStateInitial value) initial,
    required TResult Function(_GroupsStateLoading value) loading,
    required TResult Function(_GroupsStateLoaded value) loaded,
    required TResult Function(_GroupsStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GroupsStateInitial value)? initial,
    TResult? Function(_GroupsStateLoading value)? loading,
    TResult? Function(_GroupsStateLoaded value)? loaded,
    TResult? Function(_GroupsStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GroupsStateInitial value)? initial,
    TResult Function(_GroupsStateLoading value)? loading,
    TResult Function(_GroupsStateLoaded value)? loaded,
    TResult Function(_GroupsStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _GroupsStateError implements GroupsState {
  const factory _GroupsStateError(final String message) =
      _$GroupsStateErrorImpl;

  String get message;

  /// Create a copy of GroupsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupsStateErrorImplCopyWith<_$GroupsStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FriendsOfFriendsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Map<String, dynamic>> friendsOfFriends)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FriendsOfFriendsStateInitial value) initial,
    required TResult Function(_FriendsOfFriendsStateLoading value) loading,
    required TResult Function(_FriendsOfFriendsStateLoaded value) loaded,
    required TResult Function(_FriendsOfFriendsStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult? Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult? Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult? Function(_FriendsOfFriendsStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult Function(_FriendsOfFriendsStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendsOfFriendsStateCopyWith<$Res> {
  factory $FriendsOfFriendsStateCopyWith(FriendsOfFriendsState value,
          $Res Function(FriendsOfFriendsState) then) =
      _$FriendsOfFriendsStateCopyWithImpl<$Res, FriendsOfFriendsState>;
}

/// @nodoc
class _$FriendsOfFriendsStateCopyWithImpl<$Res,
        $Val extends FriendsOfFriendsState>
    implements $FriendsOfFriendsStateCopyWith<$Res> {
  _$FriendsOfFriendsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FriendsOfFriendsStateInitialImplCopyWith<$Res> {
  factory _$$FriendsOfFriendsStateInitialImplCopyWith(
          _$FriendsOfFriendsStateInitialImpl value,
          $Res Function(_$FriendsOfFriendsStateInitialImpl) then) =
      __$$FriendsOfFriendsStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FriendsOfFriendsStateInitialImplCopyWithImpl<$Res>
    extends _$FriendsOfFriendsStateCopyWithImpl<$Res,
        _$FriendsOfFriendsStateInitialImpl>
    implements _$$FriendsOfFriendsStateInitialImplCopyWith<$Res> {
  __$$FriendsOfFriendsStateInitialImplCopyWithImpl(
      _$FriendsOfFriendsStateInitialImpl _value,
      $Res Function(_$FriendsOfFriendsStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FriendsOfFriendsStateInitialImpl
    implements _FriendsOfFriendsStateInitial {
  const _$FriendsOfFriendsStateInitialImpl();

  @override
  String toString() {
    return 'FriendsOfFriendsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsOfFriendsStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Map<String, dynamic>> friendsOfFriends)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FriendsOfFriendsStateInitial value) initial,
    required TResult Function(_FriendsOfFriendsStateLoading value) loading,
    required TResult Function(_FriendsOfFriendsStateLoaded value) loaded,
    required TResult Function(_FriendsOfFriendsStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult? Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult? Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult? Function(_FriendsOfFriendsStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult Function(_FriendsOfFriendsStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _FriendsOfFriendsStateInitial implements FriendsOfFriendsState {
  const factory _FriendsOfFriendsStateInitial() =
      _$FriendsOfFriendsStateInitialImpl;
}

/// @nodoc
abstract class _$$FriendsOfFriendsStateLoadingImplCopyWith<$Res> {
  factory _$$FriendsOfFriendsStateLoadingImplCopyWith(
          _$FriendsOfFriendsStateLoadingImpl value,
          $Res Function(_$FriendsOfFriendsStateLoadingImpl) then) =
      __$$FriendsOfFriendsStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FriendsOfFriendsStateLoadingImplCopyWithImpl<$Res>
    extends _$FriendsOfFriendsStateCopyWithImpl<$Res,
        _$FriendsOfFriendsStateLoadingImpl>
    implements _$$FriendsOfFriendsStateLoadingImplCopyWith<$Res> {
  __$$FriendsOfFriendsStateLoadingImplCopyWithImpl(
      _$FriendsOfFriendsStateLoadingImpl _value,
      $Res Function(_$FriendsOfFriendsStateLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FriendsOfFriendsStateLoadingImpl
    implements _FriendsOfFriendsStateLoading {
  const _$FriendsOfFriendsStateLoadingImpl();

  @override
  String toString() {
    return 'FriendsOfFriendsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsOfFriendsStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Map<String, dynamic>> friendsOfFriends)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FriendsOfFriendsStateInitial value) initial,
    required TResult Function(_FriendsOfFriendsStateLoading value) loading,
    required TResult Function(_FriendsOfFriendsStateLoaded value) loaded,
    required TResult Function(_FriendsOfFriendsStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult? Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult? Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult? Function(_FriendsOfFriendsStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult Function(_FriendsOfFriendsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _FriendsOfFriendsStateLoading implements FriendsOfFriendsState {
  const factory _FriendsOfFriendsStateLoading() =
      _$FriendsOfFriendsStateLoadingImpl;
}

/// @nodoc
abstract class _$$FriendsOfFriendsStateLoadedImplCopyWith<$Res> {
  factory _$$FriendsOfFriendsStateLoadedImplCopyWith(
          _$FriendsOfFriendsStateLoadedImpl value,
          $Res Function(_$FriendsOfFriendsStateLoadedImpl) then) =
      __$$FriendsOfFriendsStateLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Map<String, dynamic>> friendsOfFriends});
}

/// @nodoc
class __$$FriendsOfFriendsStateLoadedImplCopyWithImpl<$Res>
    extends _$FriendsOfFriendsStateCopyWithImpl<$Res,
        _$FriendsOfFriendsStateLoadedImpl>
    implements _$$FriendsOfFriendsStateLoadedImplCopyWith<$Res> {
  __$$FriendsOfFriendsStateLoadedImplCopyWithImpl(
      _$FriendsOfFriendsStateLoadedImpl _value,
      $Res Function(_$FriendsOfFriendsStateLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendsOfFriends = null,
  }) {
    return _then(_$FriendsOfFriendsStateLoadedImpl(
      null == friendsOfFriends
          ? _value._friendsOfFriends
          : friendsOfFriends // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc

class _$FriendsOfFriendsStateLoadedImpl
    implements _FriendsOfFriendsStateLoaded {
  const _$FriendsOfFriendsStateLoadedImpl(
      final List<Map<String, dynamic>> friendsOfFriends)
      : _friendsOfFriends = friendsOfFriends;

  final List<Map<String, dynamic>> _friendsOfFriends;
  @override
  List<Map<String, dynamic>> get friendsOfFriends {
    if (_friendsOfFriends is EqualUnmodifiableListView)
      return _friendsOfFriends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsOfFriends);
  }

  @override
  String toString() {
    return 'FriendsOfFriendsState.loaded(friendsOfFriends: $friendsOfFriends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsOfFriendsStateLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._friendsOfFriends, _friendsOfFriends));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_friendsOfFriends));

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendsOfFriendsStateLoadedImplCopyWith<_$FriendsOfFriendsStateLoadedImpl>
      get copyWith => __$$FriendsOfFriendsStateLoadedImplCopyWithImpl<
          _$FriendsOfFriendsStateLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Map<String, dynamic>> friendsOfFriends)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(friendsOfFriends);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(friendsOfFriends);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(friendsOfFriends);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FriendsOfFriendsStateInitial value) initial,
    required TResult Function(_FriendsOfFriendsStateLoading value) loading,
    required TResult Function(_FriendsOfFriendsStateLoaded value) loaded,
    required TResult Function(_FriendsOfFriendsStateError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult? Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult? Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult? Function(_FriendsOfFriendsStateError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult Function(_FriendsOfFriendsStateError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _FriendsOfFriendsStateLoaded implements FriendsOfFriendsState {
  const factory _FriendsOfFriendsStateLoaded(
          final List<Map<String, dynamic>> friendsOfFriends) =
      _$FriendsOfFriendsStateLoadedImpl;

  List<Map<String, dynamic>> get friendsOfFriends;

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendsOfFriendsStateLoadedImplCopyWith<_$FriendsOfFriendsStateLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FriendsOfFriendsStateErrorImplCopyWith<$Res> {
  factory _$$FriendsOfFriendsStateErrorImplCopyWith(
          _$FriendsOfFriendsStateErrorImpl value,
          $Res Function(_$FriendsOfFriendsStateErrorImpl) then) =
      __$$FriendsOfFriendsStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FriendsOfFriendsStateErrorImplCopyWithImpl<$Res>
    extends _$FriendsOfFriendsStateCopyWithImpl<$Res,
        _$FriendsOfFriendsStateErrorImpl>
    implements _$$FriendsOfFriendsStateErrorImplCopyWith<$Res> {
  __$$FriendsOfFriendsStateErrorImplCopyWithImpl(
      _$FriendsOfFriendsStateErrorImpl _value,
      $Res Function(_$FriendsOfFriendsStateErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FriendsOfFriendsStateErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FriendsOfFriendsStateErrorImpl implements _FriendsOfFriendsStateError {
  const _$FriendsOfFriendsStateErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'FriendsOfFriendsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendsOfFriendsStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendsOfFriendsStateErrorImplCopyWith<_$FriendsOfFriendsStateErrorImpl>
      get copyWith => __$$FriendsOfFriendsStateErrorImplCopyWithImpl<
          _$FriendsOfFriendsStateErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Map<String, dynamic>> friendsOfFriends)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Map<String, dynamic>> friendsOfFriends)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FriendsOfFriendsStateInitial value) initial,
    required TResult Function(_FriendsOfFriendsStateLoading value) loading,
    required TResult Function(_FriendsOfFriendsStateLoaded value) loaded,
    required TResult Function(_FriendsOfFriendsStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult? Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult? Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult? Function(_FriendsOfFriendsStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FriendsOfFriendsStateInitial value)? initial,
    TResult Function(_FriendsOfFriendsStateLoading value)? loading,
    TResult Function(_FriendsOfFriendsStateLoaded value)? loaded,
    TResult Function(_FriendsOfFriendsStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _FriendsOfFriendsStateError implements FriendsOfFriendsState {
  const factory _FriendsOfFriendsStateError(final String message) =
      _$FriendsOfFriendsStateErrorImpl;

  String get message;

  /// Create a copy of FriendsOfFriendsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendsOfFriendsStateErrorImplCopyWith<_$FriendsOfFriendsStateErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DoubleDateState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<String> friends) selecting,
    required TResult Function(List<String> friends) creating,
    required TResult Function(List<String> friends) created,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<String> friends)? selecting,
    TResult? Function(List<String> friends)? creating,
    TResult? Function(List<String> friends)? created,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<String> friends)? selecting,
    TResult Function(List<String> friends)? creating,
    TResult Function(List<String> friends)? created,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DoubleDateStateInitial value) initial,
    required TResult Function(_DoubleDateStateSelecting value) selecting,
    required TResult Function(_DoubleDateStateCreating value) creating,
    required TResult Function(_DoubleDateStateCreated value) created,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DoubleDateStateInitial value)? initial,
    TResult? Function(_DoubleDateStateSelecting value)? selecting,
    TResult? Function(_DoubleDateStateCreating value)? creating,
    TResult? Function(_DoubleDateStateCreated value)? created,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DoubleDateStateInitial value)? initial,
    TResult Function(_DoubleDateStateSelecting value)? selecting,
    TResult Function(_DoubleDateStateCreating value)? creating,
    TResult Function(_DoubleDateStateCreated value)? created,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoubleDateStateCopyWith<$Res> {
  factory $DoubleDateStateCopyWith(
          DoubleDateState value, $Res Function(DoubleDateState) then) =
      _$DoubleDateStateCopyWithImpl<$Res, DoubleDateState>;
}

/// @nodoc
class _$DoubleDateStateCopyWithImpl<$Res, $Val extends DoubleDateState>
    implements $DoubleDateStateCopyWith<$Res> {
  _$DoubleDateStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DoubleDateStateInitialImplCopyWith<$Res> {
  factory _$$DoubleDateStateInitialImplCopyWith(
          _$DoubleDateStateInitialImpl value,
          $Res Function(_$DoubleDateStateInitialImpl) then) =
      __$$DoubleDateStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DoubleDateStateInitialImplCopyWithImpl<$Res>
    extends _$DoubleDateStateCopyWithImpl<$Res, _$DoubleDateStateInitialImpl>
    implements _$$DoubleDateStateInitialImplCopyWith<$Res> {
  __$$DoubleDateStateInitialImplCopyWithImpl(
      _$DoubleDateStateInitialImpl _value,
      $Res Function(_$DoubleDateStateInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DoubleDateStateInitialImpl implements _DoubleDateStateInitial {
  const _$DoubleDateStateInitialImpl();

  @override
  String toString() {
    return 'DoubleDateState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleDateStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<String> friends) selecting,
    required TResult Function(List<String> friends) creating,
    required TResult Function(List<String> friends) created,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<String> friends)? selecting,
    TResult? Function(List<String> friends)? creating,
    TResult? Function(List<String> friends)? created,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<String> friends)? selecting,
    TResult Function(List<String> friends)? creating,
    TResult Function(List<String> friends)? created,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DoubleDateStateInitial value) initial,
    required TResult Function(_DoubleDateStateSelecting value) selecting,
    required TResult Function(_DoubleDateStateCreating value) creating,
    required TResult Function(_DoubleDateStateCreated value) created,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DoubleDateStateInitial value)? initial,
    TResult? Function(_DoubleDateStateSelecting value)? selecting,
    TResult? Function(_DoubleDateStateCreating value)? creating,
    TResult? Function(_DoubleDateStateCreated value)? created,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DoubleDateStateInitial value)? initial,
    TResult Function(_DoubleDateStateSelecting value)? selecting,
    TResult Function(_DoubleDateStateCreating value)? creating,
    TResult Function(_DoubleDateStateCreated value)? created,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _DoubleDateStateInitial implements DoubleDateState {
  const factory _DoubleDateStateInitial() = _$DoubleDateStateInitialImpl;
}

/// @nodoc
abstract class _$$DoubleDateStateSelectingImplCopyWith<$Res> {
  factory _$$DoubleDateStateSelectingImplCopyWith(
          _$DoubleDateStateSelectingImpl value,
          $Res Function(_$DoubleDateStateSelectingImpl) then) =
      __$$DoubleDateStateSelectingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> friends});
}

/// @nodoc
class __$$DoubleDateStateSelectingImplCopyWithImpl<$Res>
    extends _$DoubleDateStateCopyWithImpl<$Res, _$DoubleDateStateSelectingImpl>
    implements _$$DoubleDateStateSelectingImplCopyWith<$Res> {
  __$$DoubleDateStateSelectingImplCopyWithImpl(
      _$DoubleDateStateSelectingImpl _value,
      $Res Function(_$DoubleDateStateSelectingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
  }) {
    return _then(_$DoubleDateStateSelectingImpl(
      null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$DoubleDateStateSelectingImpl implements _DoubleDateStateSelecting {
  const _$DoubleDateStateSelectingImpl(final List<String> friends)
      : _friends = friends;

  final List<String> _friends;
  @override
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  String toString() {
    return 'DoubleDateState.selecting(friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleDateStateSelectingImpl &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_friends));

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleDateStateSelectingImplCopyWith<_$DoubleDateStateSelectingImpl>
      get copyWith => __$$DoubleDateStateSelectingImplCopyWithImpl<
          _$DoubleDateStateSelectingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<String> friends) selecting,
    required TResult Function(List<String> friends) creating,
    required TResult Function(List<String> friends) created,
  }) {
    return selecting(friends);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<String> friends)? selecting,
    TResult? Function(List<String> friends)? creating,
    TResult? Function(List<String> friends)? created,
  }) {
    return selecting?.call(friends);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<String> friends)? selecting,
    TResult Function(List<String> friends)? creating,
    TResult Function(List<String> friends)? created,
    required TResult orElse(),
  }) {
    if (selecting != null) {
      return selecting(friends);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DoubleDateStateInitial value) initial,
    required TResult Function(_DoubleDateStateSelecting value) selecting,
    required TResult Function(_DoubleDateStateCreating value) creating,
    required TResult Function(_DoubleDateStateCreated value) created,
  }) {
    return selecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DoubleDateStateInitial value)? initial,
    TResult? Function(_DoubleDateStateSelecting value)? selecting,
    TResult? Function(_DoubleDateStateCreating value)? creating,
    TResult? Function(_DoubleDateStateCreated value)? created,
  }) {
    return selecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DoubleDateStateInitial value)? initial,
    TResult Function(_DoubleDateStateSelecting value)? selecting,
    TResult Function(_DoubleDateStateCreating value)? creating,
    TResult Function(_DoubleDateStateCreated value)? created,
    required TResult orElse(),
  }) {
    if (selecting != null) {
      return selecting(this);
    }
    return orElse();
  }
}

abstract class _DoubleDateStateSelecting implements DoubleDateState {
  const factory _DoubleDateStateSelecting(final List<String> friends) =
      _$DoubleDateStateSelectingImpl;

  List<String> get friends;

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoubleDateStateSelectingImplCopyWith<_$DoubleDateStateSelectingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoubleDateStateCreatingImplCopyWith<$Res> {
  factory _$$DoubleDateStateCreatingImplCopyWith(
          _$DoubleDateStateCreatingImpl value,
          $Res Function(_$DoubleDateStateCreatingImpl) then) =
      __$$DoubleDateStateCreatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> friends});
}

/// @nodoc
class __$$DoubleDateStateCreatingImplCopyWithImpl<$Res>
    extends _$DoubleDateStateCopyWithImpl<$Res, _$DoubleDateStateCreatingImpl>
    implements _$$DoubleDateStateCreatingImplCopyWith<$Res> {
  __$$DoubleDateStateCreatingImplCopyWithImpl(
      _$DoubleDateStateCreatingImpl _value,
      $Res Function(_$DoubleDateStateCreatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
  }) {
    return _then(_$DoubleDateStateCreatingImpl(
      null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$DoubleDateStateCreatingImpl implements _DoubleDateStateCreating {
  const _$DoubleDateStateCreatingImpl(final List<String> friends)
      : _friends = friends;

  final List<String> _friends;
  @override
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  String toString() {
    return 'DoubleDateState.creating(friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleDateStateCreatingImpl &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_friends));

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleDateStateCreatingImplCopyWith<_$DoubleDateStateCreatingImpl>
      get copyWith => __$$DoubleDateStateCreatingImplCopyWithImpl<
          _$DoubleDateStateCreatingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<String> friends) selecting,
    required TResult Function(List<String> friends) creating,
    required TResult Function(List<String> friends) created,
  }) {
    return creating(friends);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<String> friends)? selecting,
    TResult? Function(List<String> friends)? creating,
    TResult? Function(List<String> friends)? created,
  }) {
    return creating?.call(friends);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<String> friends)? selecting,
    TResult Function(List<String> friends)? creating,
    TResult Function(List<String> friends)? created,
    required TResult orElse(),
  }) {
    if (creating != null) {
      return creating(friends);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DoubleDateStateInitial value) initial,
    required TResult Function(_DoubleDateStateSelecting value) selecting,
    required TResult Function(_DoubleDateStateCreating value) creating,
    required TResult Function(_DoubleDateStateCreated value) created,
  }) {
    return creating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DoubleDateStateInitial value)? initial,
    TResult? Function(_DoubleDateStateSelecting value)? selecting,
    TResult? Function(_DoubleDateStateCreating value)? creating,
    TResult? Function(_DoubleDateStateCreated value)? created,
  }) {
    return creating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DoubleDateStateInitial value)? initial,
    TResult Function(_DoubleDateStateSelecting value)? selecting,
    TResult Function(_DoubleDateStateCreating value)? creating,
    TResult Function(_DoubleDateStateCreated value)? created,
    required TResult orElse(),
  }) {
    if (creating != null) {
      return creating(this);
    }
    return orElse();
  }
}

abstract class _DoubleDateStateCreating implements DoubleDateState {
  const factory _DoubleDateStateCreating(final List<String> friends) =
      _$DoubleDateStateCreatingImpl;

  List<String> get friends;

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoubleDateStateCreatingImplCopyWith<_$DoubleDateStateCreatingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoubleDateStateCreatedImplCopyWith<$Res> {
  factory _$$DoubleDateStateCreatedImplCopyWith(
          _$DoubleDateStateCreatedImpl value,
          $Res Function(_$DoubleDateStateCreatedImpl) then) =
      __$$DoubleDateStateCreatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> friends});
}

/// @nodoc
class __$$DoubleDateStateCreatedImplCopyWithImpl<$Res>
    extends _$DoubleDateStateCopyWithImpl<$Res, _$DoubleDateStateCreatedImpl>
    implements _$$DoubleDateStateCreatedImplCopyWith<$Res> {
  __$$DoubleDateStateCreatedImplCopyWithImpl(
      _$DoubleDateStateCreatedImpl _value,
      $Res Function(_$DoubleDateStateCreatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
  }) {
    return _then(_$DoubleDateStateCreatedImpl(
      null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$DoubleDateStateCreatedImpl implements _DoubleDateStateCreated {
  const _$DoubleDateStateCreatedImpl(final List<String> friends)
      : _friends = friends;

  final List<String> _friends;
  @override
  List<String> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  String toString() {
    return 'DoubleDateState.created(friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleDateStateCreatedImpl &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_friends));

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleDateStateCreatedImplCopyWith<_$DoubleDateStateCreatedImpl>
      get copyWith => __$$DoubleDateStateCreatedImplCopyWithImpl<
          _$DoubleDateStateCreatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(List<String> friends) selecting,
    required TResult Function(List<String> friends) creating,
    required TResult Function(List<String> friends) created,
  }) {
    return created(friends);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(List<String> friends)? selecting,
    TResult? Function(List<String> friends)? creating,
    TResult? Function(List<String> friends)? created,
  }) {
    return created?.call(friends);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(List<String> friends)? selecting,
    TResult Function(List<String> friends)? creating,
    TResult Function(List<String> friends)? created,
    required TResult orElse(),
  }) {
    if (created != null) {
      return created(friends);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DoubleDateStateInitial value) initial,
    required TResult Function(_DoubleDateStateSelecting value) selecting,
    required TResult Function(_DoubleDateStateCreating value) creating,
    required TResult Function(_DoubleDateStateCreated value) created,
  }) {
    return created(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DoubleDateStateInitial value)? initial,
    TResult? Function(_DoubleDateStateSelecting value)? selecting,
    TResult? Function(_DoubleDateStateCreating value)? creating,
    TResult? Function(_DoubleDateStateCreated value)? created,
  }) {
    return created?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DoubleDateStateInitial value)? initial,
    TResult Function(_DoubleDateStateSelecting value)? selecting,
    TResult Function(_DoubleDateStateCreating value)? creating,
    TResult Function(_DoubleDateStateCreated value)? created,
    required TResult orElse(),
  }) {
    if (created != null) {
      return created(this);
    }
    return orElse();
  }
}

abstract class _DoubleDateStateCreated implements DoubleDateState {
  const factory _DoubleDateStateCreated(final List<String> friends) =
      _$DoubleDateStateCreatedImpl;

  List<String> get friends;

  /// Create a copy of DoubleDateState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoubleDateStateCreatedImplCopyWith<_$DoubleDateStateCreatedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
