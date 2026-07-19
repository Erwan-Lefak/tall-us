import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// A "like received": a swipe targeting the current user with action
/// `like` or `superLike`, plus the liker's profile.
class LikeReceived {
  final String swipeId;
  final String fromUserId;
  final bool isSuperLike;
  final DateTime createdAt;
  UserProfileEntity? profile;

  LikeReceived({
    required this.swipeId,
    required this.fromUserId,
    required this.isSuperLike,
    required this.createdAt,
    this.profile,
  });
}

class LikesReceivedState {
  final List<LikeReceived> likes;
  final bool isLoading;
  final String? error;

  const LikesReceivedState({
    this.likes = const [],
    this.isLoading = false,
    this.error,
  });

  LikesReceivedState copyWith({
    List<LikeReceived>? likes,
    bool? isLoading,
    String? error,
  }) {
    return LikesReceivedState(
      likes: likes ?? this.likes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LikesReceivedNotifier extends StateNotifier<LikesReceivedState> {
  final Databases _db;
  final String? _userId;

  LikesReceivedNotifier(this._db, this._userId)
      : super(const LikesReceivedState());

  Future<void> refresh() async {
    if (_userId == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Swipes targeting the current user, newest first.
      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.swipesCollection,
        queries: [
          Query.equal('toUserId', [_userId!]),
          Query.orderDesc('\$createdAt'),
          Query.limit(100),
        ],
      );

      // Keep only like / superLike actions.
      final likes = <LikeReceived>[];
      for (final doc in res.documents) {
        final a = doc.data['action'];
        if (a != 'like' && a != 'superLike' && a != 'superlike') continue;
        likes.add(LikeReceived(
          swipeId: doc.$id,
          fromUserId: doc.data['fromUserId'] ?? '',
          isSuperLike: a == 'superLike' || a == 'superlike',
          createdAt: DateTime.tryParse(doc.$createdAt) ?? DateTime.now(),
        ));
      }

      // Load each liker's profile (profile doc id == userId in this app).
      for (final like in likes) {
        try {
          final pdoc = await _db.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.profilesCollection,
            documentId: like.fromUserId,
          );
          like.profile = UserProfileEntity.fromMap(pdoc.data);
        } catch (e) {
          AppLogger.w('Could not load liker profile ${like.fromUserId}: $e');
        }
      }

      state = LikesReceivedState(likes: likes, isLoading: false);
    } catch (e) {
      AppLogger.w('Failed to load likes received: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final likesReceivedProvider = StateNotifierProvider.autoDispose<
    LikesReceivedNotifier, LikesReceivedState>((ref) {
  final user = ref.watch(authenticatedUserProvider);
  final notifier = LikesReceivedNotifier(ref.watch(databasesProvider), user?.id);
  notifier.refresh();
  return notifier;
});
