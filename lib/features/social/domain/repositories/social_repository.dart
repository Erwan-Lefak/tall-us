import 'package:tall_us/features/social/domain/entities/social_entities.dart';

/// Social Repository Interface
abstract class SocialRepository {
  // ==================== Events ====================

  /// Create a new social event
  Future<SocialEvent> createEvent(SocialEvent event);

  /// Get list of events
  Future<List<SocialEvent>> getEvents({int limit, int offset});

  /// User joins an event
  Future<void> joinEvent(String eventId, String userId);

  // ==================== Groups ====================

  /// Create a new social group
  Future<SocialGroup> createGroup(SocialGroup group);

  /// Get list of groups
  Future<List<SocialGroup>> getGroups({int limit, int offset});

  /// User joins a group
  Future<void> joinGroup(String groupId, String userId);

  // ==================== Friends of Friends ====================

  /// Get potential matches who are friends of friends
  Future<List<Map<String, dynamic>>> getFriendsOfFriends(String userId);

  // ==================== Realtime ====================

  /// Subscribe to event updates
  Stream<Map<String, dynamic>> subscribeToEventUpdates(String eventId);

  /// Subscribe to group updates
  Stream<Map<String, dynamic>> subscribeToGroupUpdates(String groupId);
}
