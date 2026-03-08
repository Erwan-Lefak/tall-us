import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';

part 'message_state.freezed.dart';

/// State for chat messages
@freezed
class MessageState with _$MessageState {
  const factory MessageState.initial() = _Initial;
  const factory MessageState.loading() = _Loading;
  const factory MessageState.loaded(List<MessageEntity> messages) = _Loaded;
  const factory MessageState.error(String message) = _Error;
}
