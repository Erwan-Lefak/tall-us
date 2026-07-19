import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' show Document;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';

/// Lightweight provider that reads the current user's in-app notifications
/// from the `notifications` collection (no FCM dependency).
class NotificationListNotifier extends StateNotifier<NotificationListState> {
  final Databases _db;
  final String? _userId;

  NotificationListNotifier(this._db, this._userId)
      : super(const NotificationListState());

  Future<void> refresh({int limit = 50}) async {
    if (_userId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notificationsCollection,
        queries: [
          Query.equal('userId', [_userId!]),
          Query.orderDesc('\$createdAt'),
          Query.limit(limit),
        ],
      );
      final items = res.documents.map(_mapDoc).toList();
      state = NotificationListState(
        notifications: items,
        isLoading: false,
        totalCount: res.total,
      );
    } catch (e) {
      AppLogger.w('Failed to load notifications: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.notificationsCollection,
        documentId: notificationId,
        data: {'isRead': true, 'readAt': DateTime.now().toIso8601String()},
      );
      state = state.copyWith(
        notifications: state.notifications
            .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
            .toList(),
      );
    } catch (e) {
      AppLogger.w('Failed to mark notification read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final unread = state.notifications.where((n) => !n.isRead).toList();
    for (final n in unread) {
      await markAsRead(n.id);
    }
  }

  NotificationEntity _mapDoc(Document doc) {
    return NotificationEntity(
      id: doc.$id,
      userId: doc.data['userId'] ?? '',
      type: _parseType(doc.data['type']),
      title: doc.data['title'] ?? '',
      body: doc.data['body'] ?? '',
      isRead: doc.data['isRead'] ?? false,
      readAt: doc.data['readAt'] != null
          ? DateTime.tryParse(doc.data['readAt'])
          : null,
      createdAt: DateTime.tryParse(doc.$createdAt) ?? DateTime.now(),
    );
  }

  NotificationType _parseType(String? t) {
    switch (t) {
      case 'newMatch':
        return NotificationType.newMatch;
      case 'newMessage':
        return NotificationType.newMessage;
      case 'superLike':
        return NotificationType.superLike;
      case 'profileView':
        return NotificationType.profileView;
      case 'weeklyDigest':
        return NotificationType.weeklyDigest;
      case 'trialExpiration':
        return NotificationType.trialExpiration;
      case 'subscriptionRenewed':
        return NotificationType.subscriptionRenewed;
      case 'subscriptionCanceled':
        return NotificationType.subscriptionCanceled;
      case 'profileApproved':
        return NotificationType.profileApproved;
      case 'photoVerified':
        return NotificationType.photoVerified;
      default:
        return NotificationType.newMessage;
    }
  }
}

class NotificationListState {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? error;
  final int totalCount;

  const NotificationListState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.totalCount = 0,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationListState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? error,
    int? totalCount,
  }) {
    return NotificationListState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

final notificationListProvider = StateNotifierProvider.autoDispose<
    NotificationListNotifier, NotificationListState>((ref) {
  final user = ref.watch(authenticatedUserProvider);
  final notifier =
      NotificationListNotifier(ref.watch(databasesProvider), user?.id);
  notifier.refresh();
  return notifier;
});
