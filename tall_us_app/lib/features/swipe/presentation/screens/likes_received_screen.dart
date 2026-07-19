import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/swipe/presentation/providers/likes_received_provider.dart';

/// Page listing everyone who liked / super-liked the current user.
class LikesReceivedScreen extends ConsumerStatefulWidget {
  const LikesReceivedScreen({super.key});

  @override
  ConsumerState<LikesReceivedScreen> createState() =>
      _LikesReceivedScreenState();
}

class _LikesReceivedScreenState extends ConsumerState<LikesReceivedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(likesReceivedProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(likesReceivedProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: AppTheme.bordeaux, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Tu as plu à',
              style: TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (state.likes.isNotEmpty) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${state.likes.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
      body: state.isLoading && state.likes.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.bordeaux),
            )
          : state.likes.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  color: AppTheme.bordeaux,
                  onRefresh: () =>
                      ref.read(likesReceivedProvider.notifier).refresh(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: state.likes.length,
                    itemBuilder: (context, index) =>
                        _LikeCard(like: state.likes[index]),
                  ),
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 72, color: AppTheme.bordeaux.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text(
            'Pas encore de likes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continue à swiper, tes likes apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LikeCard extends StatelessWidget {
  final LikeReceived like;
  const _LikeCard({required this.like});

  @override
  Widget build(BuildContext context) {
    final p = like.profile;
    final photo = (p?.photoUrls.isNotEmpty ?? false)
        ? p!.photoUrls.first
        : p?.avatarUrl;
    final isSuper = like.isSuperLike;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: photo != null && photo.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: photo,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white70),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.bordeaux.withValues(alpha: 0.2),
                      child: const Icon(Icons.person,
                          size: 56, color: Colors.white),
                    ),
                  )
                : Container(
                    color: AppTheme.bordeaux.withValues(alpha: 0.2),
                    child: const Icon(Icons.person,
                        size: 56, color: Colors.white),
                  ),
          ),
          // Gradient overlay + info
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.5, 1],
                ),
              ),
            ),
          ),
          // Super like badge
          if (isSuper)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 3),
                    Text('Super Like',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          else
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppTheme.bordeaux,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite,
                    color: Colors.white, size: 14),
              ),
            ),
          // Name + age
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  p != null
                      ? '${p.displayName}${p.birthday != null ? ', ${p.calculateAge()}' : ''}'
                      : 'Profil',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (p != null && p.city.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white70, size: 12),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          p.city,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
