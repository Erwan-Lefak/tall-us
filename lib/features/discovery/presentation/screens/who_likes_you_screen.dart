import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/empty_state_widget.dart';
import 'package:tall_us/core/widgets/error_state_widget.dart';
import 'package:tall_us/core/widgets/skeleton/skeleton_loading.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_extended_providers.dart';
import 'package:tall_us/features/discovery/presentation/widgets/top_picks_widget.dart';

/// Who Likes You Screen
///
/// Shows all users who have liked the current user
class WhoLikesYouScreen extends ConsumerStatefulWidget {
  const WhoLikesYouScreen({super.key});

  @override
  ConsumerState<WhoLikesYouScreen> createState() => _WhoLikesYouScreenState();
}

class _WhoLikesYouScreenState extends ConsumerState<WhoLikesYouScreen> {
  @override
  void initState() {
    super.initState();
    // Load who likes you when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authenticatedUserProvider);
      if (user != null) {
        ref.read(whoLikesYouProvider.notifier).setCurrentUser(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final whoLikesYouState = ref.watch(whoLikesYouProvider);
    final premiumState = ref.watch(premiumStatusProvider);

    // Premium gate
    if (!premiumState.isPlatinum) {
      return _buildPremiumGate();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: _buildAppBar(),
      body: whoLikesYouState.when(
        initial: () => _buildLoading(),
        loading: () => _buildLoading(),
        loaded: (users) => _buildContent(users),
        error: (message) => _buildError(message),
        unauthenticated: () => _buildLoading(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF1A2332)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Qui m\'a aimé',
        style: TextStyle(
          color: Color(0xFF1A2332),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_outlined, color: Color(0xFF1A2332)),
          onPressed: () {
            ref.read(whoLikesYouProvider.notifier).refresh();
          },
        ),
      ],
    );
  }

  Widget _buildPremiumGate() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A2332)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Qui m\'a aimé',
          style: TextStyle(
            color: Color(0xFF1A2332),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E4E2).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  size: 48,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fonctionnalité Platinum',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2332),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Passez à l\'abonnement Platinum pour voir toutes les personnes qui vous ont liké.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF757575),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Découvrir Platinum',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: ProfileGridSkeleton(),
    );
  }

  Widget _buildContent(List<UserProfileEntity> users) {
    if (users.isEmpty) {
      return EmptyStateWidget.noMatches(
        onDiscover: () {
          Navigator.pop(context);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(whoLikesYouProvider.notifier).refresh();
      },
      color: AppTheme.bordeaux,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(UserProfileEntity user) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to profile detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: user.photoUrls.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(user.photoUrls.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user.photoUrls.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: AppTheme.bordeaux,
                            ),
                          )
                        : null,
                  ),
                  // Age badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_calculateAge(user.birthday)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2332),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF616161),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user.city,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF616161),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (user.heightVerified) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: AppTheme.bordeaux,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Taille vérifiée',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF722F37),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return ErrorStateWidget.loadingFailed(
      message: message,
      onRetry: () {
        ref.read(whoLikesYouProvider.notifier).refresh();
      },
    );
  }

  int _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
