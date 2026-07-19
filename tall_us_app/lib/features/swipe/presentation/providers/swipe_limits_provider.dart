import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/swipe/presentation/providers/swipe_providers.dart';

/// Daily like / super-like allowance per role (Tall Us business plan).
class _Allowance {
  final int likes;
  final int superLikes;
  const _Allowance(this.likes, this.superLikes);
  static const free = _Allowance(5, 0);
  static const tall = _Allowance(15, 5);
  static const unlimited = _Allowance(-1, -1); // -1 = unlimited
}

/// Snapshot of the current user's daily swipe usage + remaining counts.
class SwipeLimits {
  final int likeLimit; // -1 = unlimited
  final int superLikeLimit;
  final int likesUsedToday;
  final int superLikesUsedToday;

  const SwipeLimits({
    required this.likeLimit,
    required this.superLikeLimit,
    required this.likesUsedToday,
    required this.superLikesUsedToday,
  });

  bool get canLike => likeLimit < 0 || likesUsedToday < likeLimit;
  bool get canSuperLike =>
      superLikeLimit < 0 || superLikesUsedToday < superLikeLimit;
  int get likesRemaining => likeLimit < 0 ? -1 : (likeLimit - likesUsedToday);
  int get superLikesRemaining =>
      superLikeLimit < 0 ? -1 : (superLikeLimit - superLikesUsedToday);

  SwipeLimits copyWith({
    int? likesUsedToday,
    int? superLikesUsedToday,
  }) =>
      SwipeLimits(
        likeLimit: likeLimit,
        superLikeLimit: superLikeLimit,
        likesUsedToday: likesUsedToday ?? this.likesUsedToday,
        superLikesUsedToday: superLikesUsedToday ?? this.superLikesUsedToday,
      );
}

/// Computes the user's allowance based on their role.
_Allowance _allowanceFor(role) {
  final isPremium = role?.maybeWhen(
        premium: () => true,
        admin: () => true,
        orElse: () => false,
      ) ??
      false;
  // Until Stripe is wired, premium/admin are treated as top-tier (unlimited).
  return isPremium ? _Allowance.unlimited : _Allowance.free;
}

final swipeLimitsProvider =
    FutureProvider.autoDispose<SwipeLimits>((ref) async {
  final user = ref.watch(authenticatedUserProvider);
  if (user == null) {
    return const SwipeLimits(
        likeLimit: 5,
        superLikeLimit: 0,
        likesUsedToday: 0,
        superLikesUsedToday: 0);
  }

  final allowance = _allowanceFor(user.role);
  final ds = ref.watch(swipeRemoteDataSourceProvider);

  final likesUsed = allowance.likes < 0
      ? 0
      : await ds.getDailySwipeCount(userId: user.id, action: 'like');
  final superLikesUsed = allowance.superLikes < 0
      ? 0
      : await ds.getDailySwipeCount(userId: user.id, action: 'superLike');

  return SwipeLimits(
    likeLimit: allowance.likes,
    superLikeLimit: allowance.superLikes,
    likesUsedToday: likesUsed,
    superLikesUsedToday: superLikesUsed,
  );
});
