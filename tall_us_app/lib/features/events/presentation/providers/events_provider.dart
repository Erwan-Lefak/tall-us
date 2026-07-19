import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/events/domain/entities/event_entity.dart';

class EventsNotifier extends StateNotifier<AsyncValue<List<EventEntity>>> {
  final Databases _db;
  EventsNotifier(this._db) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventsCollection,
        queries: [
          Query.greaterThanEqual('eventDate', now),
          Query.orderAsc('eventDate'),
          Query.limit(50),
        ],
      );
      final items = res.documents.map(_mapDoc).toList();
      state = AsyncValue.data(items);
    } catch (e) {
      AppLogger.w('Failed to load events: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  EventEntity _mapDoc(Document doc) => EventEntity(
        id: doc.$id,
        title: doc.data['title'] ?? '',
        type: doc.data['type'] ?? 'soiree',
        eventDate:
            DateTime.tryParse(doc.data['eventDate'] ?? '') ?? DateTime.now(),
        city: doc.data['city'] ?? '',
        venue: doc.data['venue'] ?? '',
        description: doc.data['description'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        priceEur: doc.data['priceEur'] ?? 0,
        spotsLeft: doc.data['spotsLeft'] ?? 0,
      );
}

final eventsProvider =
    StateNotifierProvider<EventsNotifier, AsyncValue<List<EventEntity>>>((ref) {
  return EventsNotifier(ref.watch(databasesProvider));
});

/// Is the current user RSVP'd to a given event?
final isRsvpedProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, eventId) async {
  final userId = ref.watch(authenticatedUserProvider)?.id;
  if (userId == null) return false;
  try {
    final res = await ref.watch(databasesProvider).listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.eventRsvpsCollection,
          queries: [
            Query.equal('eventId', [eventId]),
            Query.equal('userId', [userId]),
            Query.limit(1),
          ],
        );
    return res.documents.isNotEmpty;
  } catch (_) {
    return false;
  }
});

/// Toggle RSVP for the current user on an event. Returns the new state.
Future<bool> toggleRsvp(WidgetRef ref, String eventId) async {
  final db = ref.read(databasesProvider);
  final userId = ref.read(authenticatedUserProvider)?.id;
  if (userId == null) return false;

  // Find existing RSVP doc.
  final existing = await db.listDocuments(
    databaseId: AppwriteConfig.databaseId,
    collectionId: AppwriteConfig.eventRsvpsCollection,
    queries: [
      Query.equal('eventId', [eventId]),
      Query.equal('userId', [userId]),
      Query.limit(1),
    ],
  );

  if (existing.documents.isNotEmpty) {
    await db.deleteDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.eventRsvpsCollection,
      documentId: existing.documents.first.$id,
    );
    ref.invalidate(isRsvpedProvider(eventId));
    return false;
  } else {
    await db.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.eventRsvpsCollection,
      documentId: ID.unique(),
      data: {
        'eventId': eventId,
        'userId': userId,
      },
    );
    ref.invalidate(isRsvpedProvider(eventId));
    return true;
  }
}
