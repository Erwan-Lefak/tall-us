import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/presentation/widgets/profile_card.dart';

/// Discovery/Swipe screen - Tinder-style card stack
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen>
    with TickerProviderStateMixin {
  final List<UserProfileEntity> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isProcessingSwipe = false;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Load profiles from repository
    // For now, use dummy data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleSwipe(SwipeAction action) async {
    if (_isProcessingSwipe || _currentIndex >= _profiles.length) return;

    setState(() {
      _isProcessingSwipe = true;
    });

    final profile = _profiles[_currentIndex];

    // TODO: Process swipe with repository
    AppLogger.i('Swipe ${action.name} on ${profile.displayName}');

    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _currentIndex++;
      _isProcessingSwipe = false;
    });

    // Load more profiles if needed
    if (_currentIndex >= _profiles.length - 2) {
      _loadMoreProfiles();
    }
  }

  Future<void> _loadMoreProfiles() async {
    // TODO: Load more profiles
    AppLogger.i('Loading more profiles...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.05),
              AppTheme.navy.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Cards stack
              Expanded(
                child: _isLoading
                    ? _buildLoadingIndicator()
                    : _profiles.isEmpty
                        ? _buildEmptyState()
                        : _buildCardStack(),
              ),

              // Action buttons
              if (_profiles.isNotEmpty && !_isLoading)
                _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile button
          IconButton(
            icon: const Icon(Icons.person_outline),
            iconSize: 32,
            color: AppTheme.navy,
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),

          // Logo
          Column(
            children: [
              Text(
                'Tall Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bordeaux,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'L\'amour vu d\'en haut',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.navy.withValues(alpha: 0.7),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          // Matches button
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            iconSize: 32,
            color: AppTheme.navy,
            onPressed: () {
              // TODO: Navigate to matches
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    if (_currentIndex >= _profiles.length) {
      return _buildEmptyState();
    }

    // Show current card on top
    return Stack(
      children: [
        // Background cards (for depth effect)
        if (_currentIndex + 1 < _profiles.length)
          Positioned.fill(
            child: Transform.scale(
              scale: 0.95,
              child: Opacity(
                opacity: 0.5,
                child: ProfileCard(profile: _profiles[_currentIndex + 1]),
              ),
            ),
          ),
        if (_currentIndex + 2 < _profiles.length)
          Positioned.fill(
            child: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.3,
                child: ProfileCard(profile: _profiles[_currentIndex + 2]),
              ),
            ),
          ),

        // Current interactive card
        if (_currentIndex < _profiles.length)
          Positioned.fill(
            child: ProfileCard(
              profile: _profiles[_currentIndex],
              onTap: () {
                // TODO: Show full profile view
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass button
          _ActionButton(
            icon: Icons.close,
            color: AppTheme.navy.withValues(alpha: 0.6),
            size: 28,
            onTap: () => _handleSwipe(SwipeAction.pass),
          ),

          // Super Like button
          _ActionButton(
            icon: Icons.star,
            color: AppTheme.gold,
            size: 24,
            onTap: () => _handleSwipe(SwipeAction.superLike),
          ),

          // Like button
          _ActionButton(
            icon: Icons.favorite,
            color: AppTheme.bordeaux,
            size: 28,
            onTap: () => _handleSwipe(SwipeAction.like),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: AppTheme.navy.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Plus de profils',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Élargissez vos critères de recherche',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to preferences
            },
            icon: const Icon(Icons.tune),
            label: const Text('Modifier mes préférences'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
