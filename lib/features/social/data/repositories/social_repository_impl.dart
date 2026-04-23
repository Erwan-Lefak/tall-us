import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show Preference;
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';
import 'package:tall_us/features/social/domain/repositories/social_repository.dart';

/// Appwrite implementation of Social Repository
class SocialRepositoryImpl implements SocialRepository {
  final Databases _databases;
  final Realtime _realtime;

  SocialRepositoryImpl({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  // ==================== Events ====================

  @override
  Future<SocialEvent> createEvent(SocialEvent event) async {
    try {
      AppLogger.i('Creating event: ${event.title}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventsCollection,
        documentId: event.id,
        data: {
          'title': event.title,
          'description': event.description,
          'location': event.location,
          'dateTime': event.dateTime.toIso8601String(),
          'attendees': event.attendees,
          'maxAttendees': event.maxAttendees,
          'hostId': event.hostId,
          'imageUrl': event.imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      AppLogger.i('Event created successfully: ${document.$id}');
      return event.copyWith(
        id: document.$id,
        createdAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to create event', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<SocialEvent>> getEvents({int limit = 20, int offset = 0}) async {
    try {
      AppLogger.i('Fetching events (limit: $limit, offset: $offset)');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventsCollection,
        queries: [
          Query.orderDesc('dateTime'),
          Query.limit(limit),
          Query.offset(offset),
          Query.gte('dateTime', DateTime.now().toIso8601String()),
        ],
      );

      final events = documents.documents.map((doc) {
        final data = doc.data;
        return SocialEvent(
          id: doc.$id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          location: data['location'] ?? '',
          dateTime: DateTime.parse(data['dateTime']),
          attendees: List<String>.from(data['attendees'] ?? []),
          maxAttendees: data['maxAttendees'] ?? 10,
          hostId: data['hostId'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          createdAt: data['createdAt'] != null
              ? DateTime.parse(data['createdAt'])
              : null,
        );
      }).toList();

      AppLogger.i('Retrieved ${events.length} events');
      return events;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch events', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      AppLogger.i('User $userId joining event $eventId');

      // Get current event
      final document = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventsCollection,
        documentId: eventId,
      );

      final attendees = List<String>.from(document.data['attendees'] ?? []);

      if (!attendees.contains(userId)) {
        attendees.add(userId);

        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.eventsCollection,
          documentId: eventId,
          data: {'attendees': attendees},
        );

        AppLogger.i('User $userId joined event $eventId successfully');
      } else {
        AppLogger.i('User $userId already in event $eventId');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Failed to join event', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ==================== Groups ====================

  @override
  Future<SocialGroup> createGroup(SocialGroup group) async {
    try {
      AppLogger.i('Creating group: ${group.name}');

      final document = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupsCollection,
        documentId: group.id,
        data: {
          'name': group.name,
          'description': group.description,
          'category': group.category,
          'members': group.members,
          'maxMembers': group.maxMembers,
          'hostId': group.hostId,
          'imageUrl': group.imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      AppLogger.i('Group created successfully: ${document.$id}');
      return group.copyWith(
        id: document.$id,
        createdAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to create group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<SocialGroup>> getGroups({int limit = 20, int offset = 0}) async {
    try {
      AppLogger.i('Fetching groups (limit: $limit, offset: $offset)');

      final documents = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupsCollection,
        queries: [
          Query.orderDesc('createdAt'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      final groups = documents.documents.map((doc) {
        final data = doc.data;
        return SocialGroup(
          id: doc.$id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          members: List<String>.from(data['members'] ?? []),
          maxMembers: data['maxMembers'] ?? 50,
          hostId: data['hostId'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          createdAt: data['createdAt'] != null
              ? DateTime.parse(data['createdAt'])
              : null,
        );
      }).toList();

      AppLogger.i('Retrieved ${groups.length} groups');
      return groups;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch groups', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    try {
      AppLogger.i('User $userId joining group $groupId');

      final document = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupsCollection,
        documentId: groupId,
      );

      final members = List<String>.from(document.data['members'] ?? []);

      if (!members.contains(userId) &&
          members.length < document.data['maxMembers']) {
        members.add(userId);

        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.groupsCollection,
          documentId: groupId,
          data: {'members': members},
        );

        AppLogger.i('User $userId joined group $groupId successfully');
      } else {
        AppLogger.i('User $userId already in group $groupId or group is full');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Failed to join group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ==================== Friends of Friends ====================

  @override
  Future<List<Map<String, dynamic>>> getFriendsOfFriends(String userId) async {
    try {
      AppLogger.i('Fetching friends of friends for user $userId');

      // This is a simplified implementation
      // In production, you'd query a friends/connections table
      // and then query their friends

      // Placeholder implementation
      return [];
    } catch (e, stackTrace) {
      AppLogger.e('Failed to fetch friends of friends',
          error: e, stackTrace: stackTrace);
      return [];
    }
  }

  // ==================== Realtime Subscriptions ====================

  Stream<Map<String, dynamic>> subscribeToEventUpdates(String eventId) {
    return _realtime
        .subscribe(
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.eventsCollection}.documents.$eventId',
    )
        .map((event) {
      if (event.events.isNotEmpty) {
        final payload = event.events.first.payload;
        return {
          'event': event.event,
          'data': payload,
        };
      }
      return {};
    });
  }

  Stream<Map<String, dynamic>> subscribeToGroupUpdates(String groupId) {
    return _realtime
        .subscribe(
      'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.groupsCollection}.documents.$groupId',
    )
        .map((event) {
      if (event.events.isNotEmpty) {
        final payload = event.events.first.payload;
        return {
          'event': event.event,
          'data': payload,
        };
      }
      return {};
    });
  }
}
