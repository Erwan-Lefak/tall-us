import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_state.freezed.dart';

/// State for matches
@freezed
class MatchState with _$MatchState {
  const factory MatchState.initial() = _Initial;
  const factory MatchState.loading() = _Loading;
  const factory MatchState.loaded(List<dynamic> matches) = _Loaded;
  const factory MatchState.error(String message) = _Error;
}
