import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

part 'discovery_state.freezed.dart';

/// Discovery state
@freezed
class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState.initial() = _Initial;
  const factory DiscoveryState.loading() = _Loading;
  const factory DiscoveryState.loaded(List<UserProfileEntity> profiles) =
      _Loaded;
  const factory DiscoveryState.error(String message) = _Error;
  const factory DiscoveryState.noMoreProfiles() = _NoMoreProfiles;
}
