import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/coaching/domain/entities/coaching_session_entity.dart';

class CoachingNotifier extends StateNotifier<AsyncValue<List<CoachingSessionEntity>>> {
  final Databases _db;
  final String? _userId;
  CoachingNotifier(this._db, this._userId) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    if (_userId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.coachingSessionsCollection,
        queries: [
          Query.equal('userId', [_userId!]),
          Query.orderAsc('scheduledAt'),
          Query.limit(50),
        ],
      );
      final items = res.documents.map(_mapDoc).toList();
      state = AsyncValue.data(items);
    } catch (e) {
      AppLogger.w('Failed to load coaching sessions: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> bookSession(DateTime scheduledAt, {String? topic}) async {
    if (_userId == null) return false;
    try {
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.coachingSessionsCollection,
        documentId: ID.unique(),
        data: {
          'userId': _userId,
          'coachName': 'Coach Tall Us',
          'scheduledAt': scheduledAt.toIso8601String(),
          'durationMin': 30,
          'status': 'requested',
          if (topic != null) 'topic': topic,
        },
      );
      await refresh();
      return true;
    } catch (e) {
      AppLogger.e('Failed to book coaching session', error: e);
      return false;
    }
  }

  Future<bool> cancelSession(String id) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.coachingSessionsCollection,
        documentId: id,
        data: {'status': 'canceled'},
      );
      await refresh();
      return true;
    } catch (e) {
      AppLogger.e('Failed to cancel coaching session', error: e);
      return false;
    }
  }

  CoachingSessionEntity _mapDoc(Document doc) => CoachingSessionEntity(
        id: doc.$id,
        userId: doc.data['userId'] ?? '',
        coachName: doc.data['coachName'],
        scheduledAt:
            DateTime.tryParse(doc.data['scheduledAt'] ?? '') ?? DateTime.now(),
        durationMin: doc.data['durationMin'] ?? 30,
        status: doc.data['status'] ?? 'requested',
        topic: doc.data['topic'],
        meetingLink: doc.data['meetingLink'],
      );
}

final coachingProvider = StateNotifierProvider<CoachingNotifier,
    AsyncValue<List<CoachingSessionEntity>>>((ref) {
  final userId = ref.watch(authenticatedUserProvider)?.id;
  return CoachingNotifier(ref.watch(databasesProvider), userId);
});
