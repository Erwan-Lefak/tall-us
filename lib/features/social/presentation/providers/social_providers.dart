import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/social/data/repositories/social_repository_impl.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';
import 'package:tall_us/features/social/domain/repositories/social_repository.dart';

part 'social_providers.freezed.dart';

// ==================== Repository Provider ====================

/// Provider for SocialRepository
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final databases = ref.watch(databasesProvider);
  final realtime = ref.watch(realtimeProvider);

  return SocialRepositoryImpl(
    databases: databases,
    realtime: realtime,
  );
});

// ==================== Events Providers ====================

/// Notifier for Events State
class EventsNotifier extends StateNotifier<EventsState> {
  final SocialRepository _repository;

  EventsNotifier(this._repository) : super(const EventsState.initial());

  Future<void> loadEvents() async {
    state = const EventsState.loading();

    try {
      final events = await _repository.getEvents();
      state = EventsState.loaded(events);
    } catch (e, st) {
      state = EventsState.error(e.toString());
    }
  }

  Future<void> createEvent(SocialEvent event) async {
    state = const EventsState.loading();

    try {
      final created = await _repository.createEvent(event);
      await loadEvents(); // Refresh list
    } catch (e) {
      state = EventsState.error(e.toString());
    }
  }

  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await _repository.joinEvent(eventId, userId);
      await loadEvents(); // Refresh to update attendee count
    } catch (e) {
      // Handle error - maybe show snackbar
    }
  }
}

/// Provider for EventsNotifier
final eventsProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return EventsNotifier(repository);
});

@freezed
class EventsState with _$EventsState {
  const factory EventsState.initial() = _EventsStateInitial;
  const factory EventsState.loading() = _EventsStateLoading;
  const factory EventsState.loaded(List<SocialEvent> events) = _EventsStateLoaded;
  const factory EventsState.error(String message) = _EventsStateError;
}

// ==================== Groups Providers ====================

/// Notifier for Groups State
class GroupsNotifier extends StateNotifier<GroupsState> {
  final SocialRepository _repository;

  GroupsNotifier(this._repository) : super(const GroupsState.initial());

  Future<void> loadGroups() async {
    state = const GroupsState.loading();

    try {
      final groups = await _repository.getGroups();
      state = GroupsState.loaded(groups);
    } catch (e, st) {
      state = GroupsState.error(e.toString());
    }
  }

  Future<void> createGroup(SocialGroup group) async {
    state = const GroupsState.loading();

    try {
      final created = await _repository.createGroup(group);
      await loadGroups(); // Refresh list
    } catch (e) {
      state = GroupsState.error(e.toString());
    }
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await _repository.joinGroup(groupId, userId);
      await loadGroups(); // Refresh to update member count
    } catch (e) {
      // Handle error
    }
  }
}

/// Provider for GroupsNotifier
final groupsProvider =
    StateNotifierProvider<GroupsNotifier, GroupsState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return GroupsNotifier(repository);
});

@freezed
class GroupsState with _$GroupsState {
  const factory GroupsState.initial() = _GroupsStateInitial;
  const factory GroupsState.loading() = _GroupsStateLoading;
  const factory GroupsState.loaded(List<SocialGroup> groups) = _GroupsStateLoaded;
  const factory GroupsState.error(String message) = _GroupsStateError;
}

// ==================== Friends of Friends Providers ====================

/// Notifier for Friends of Friends State
class FriendsOfFriendsNotifier extends StateNotifier<FriendsOfFriendsState> {
  final SocialRepository _repository;

  FriendsOfFriendsNotifier(this._repository)
      : super(const FriendsOfFriendsState.initial());

  Future<void> loadFriendsOfFriends(String userId) async {
    state = const FriendsOfFriendsState.loading();

    try {
      final friendsOfFriends = await _repository.getFriendsOfFriends(userId);
      state = FriendsOfFriendsState.loaded(friendsOfFriends);
    } catch (e, st) {
      state = FriendsOfFriendsState.error(e.toString());
    }
  }
}

/// Provider for FriendsOfFriendsNotifier
final friendsOfFriendsProvider =
    StateNotifierProvider<FriendsOfFriendsNotifier, FriendsOfFriendsState>(
        (ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return FriendsOfFriendsNotifier(repository);
});

@freezed
class FriendsOfFriendsState with _$FriendsOfFriendsState {
  const factory FriendsOfFriendsState.initial() = _FriendsOfFriendsStateInitial;
  const factory FriendsOfFriendsState.loading() = _FriendsOfFriendsStateLoading;
  const factory FriendsOfFriendsState.loaded(
      List<Map<String, dynamic>> friendsOfFriends) = _FriendsOfFriendsStateLoaded;
  const factory FriendsOfFriendsState.error(String message) =
      _FriendsOfFriendsStateError;
}

// ==================== Double Date Providers ====================

/// Notifier for Double Date State
class DoubleDateNotifier extends StateNotifier<DoubleDateState> {
  DoubleDateNotifier() : super(const DoubleDateState.initial());

  void selectFriend(String friendId) {
    final current = state.selectedFriends;

    if (current.contains(friendId)) {
      state = DoubleDateState(
        selectedFriends: current.where((id) => id != friendId).toList(),
        isCreating: false,
        isCreated: false,
      );
    } else if (current.length < 2) {
      state = DoubleDateState(
        selectedFriends: [...current, friendId],
        isCreating: false,
        isCreated: false,
      );
    }
  }

  void clearSelection() {
    state = const DoubleDateState.initial();
  }

  Future<void> createDoubleDate(List<String> friendIds) async {
    state = DoubleDateState(
      selectedFriends: friendIds,
      isCreating: true,
      isCreated: false,
    );
    // TODO: Implement double date creation logic
    await Future.delayed(const Duration(seconds: 1));
    state = DoubleDateState(
      selectedFriends: friendIds,
      isCreating: false,
      isCreated: true,
    );
  }
}

/// Provider for DoubleDateNotifier
final doubleDateProvider =
    StateNotifierProvider<DoubleDateNotifier, DoubleDateState>((ref) {
  return DoubleDateNotifier();
});

@freezed
class DoubleDateState with _$DoubleDateState {
  const factory DoubleDateState.initial() = _DoubleDateStateInitial;
  const factory DoubleDateState.selecting(List<String> friends) =
      _DoubleDateStateSelecting;
  const factory DoubleDateState.creating(List<String> friends) =
      _DoubleDateStateCreating;
  const factory DoubleDateState.created(List<String> friends) =
      _DoubleDateStateCreated;
}
