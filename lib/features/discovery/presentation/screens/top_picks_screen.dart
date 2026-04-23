import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/empty_state_widget.dart';
import 'package:tall_us/core/widgets/error_state_widget.dart';
import 'package:tall_us/core/widgets/skeleton/skeleton_loading.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_extended_providers.dart';
import 'package:tall_us/features/discovery/presentation/widgets/top_picks_widget.dart';

/// Top Picks Screen
///
/// Displays algorithmically matched profiles based on compatibility score
class TopPicksScreen extends ConsumerStatefulWidget {
  const TopPicksScreen({super.key});

  @override
  ConsumerState<TopPicksScreen> createState() => _TopPicksScreenState();
}

class _TopPicksScreenState extends ConsumerState<TopPicksScreen> {
  @override
  void initState() {
    super.initState();
    // Load top picks when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authenticatedUserProvider);
      if (user != null) {
        ref.read(topPicksProvider.notifier).setCurrentUser(
              user.id,
              user.profile?.interests ?? [],
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPicksState = ref.watch(topPicksProvider);
    final premiumState = ref.watch(premiumStatusProvider);

    // Premium gate
    if (!premiumState.isGold) {
      return _buildPremiumGate();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: _buildAppBar(),
      body: topPicksState.when(
        initial: () => _buildLoading(),
        loading: () => _buildLoading(),
        loaded: (state) => _buildContent(state.topPicks),
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
        'Top Picks',
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
            ref.read(topPicksProvider.notifier).refresh();
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
          'Top Picks',
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
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outlined,
                  size: 48,
                  color: AppTheme.bordeaux,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fonctionnalité Gold',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2332),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Passez à l\'abonnement Gold pour voir vos Top Picks - des profils sélectionnés par notre algorithme de compatibilité.',
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
                  backgroundColor: AppTheme.bordeaux,
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
                  'Découvrir Gold',
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

  Widget _buildContent(List<TopPickWithProfile> topPicks) {
    if (topPicks.isEmpty) {
      return EmptyStateWidget.noSearchResults(
        onClearFilters: () {
          ref.read(topPicksProvider.notifier).refresh();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(topPicksProvider.notifier).refresh();
      },
      color: AppTheme.bordeaux,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TopPicksWidget(
          topPicks: topPicks,
          onLike: (profileId) {
            // TODO: Handle like
          },
          onSuperLike: (profileId) {
            // TODO: Handle super like
          },
          onProfileTap: (profile) {
            // TODO: Navigate to profile detail
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return ErrorStateWidget.loadingFailed(
      message: message,
      onRetry: () {
        ref.read(topPicksProvider.notifier).refresh();
      },
    );
  }
}
