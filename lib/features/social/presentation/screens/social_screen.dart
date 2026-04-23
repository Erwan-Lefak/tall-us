import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/social/presentation/widgets/social_features_widget.dart';
import 'package:tall_us/features/social/presentation/providers/social_providers.dart';

/// Social Screen
///
/// Displays social features including:
/// - Events (create/join social events)
/// - Groups (join interest-based groups)
/// - Friends of Friends (see mutual connections)
/// - Double Date mode (select friends for double dating)
class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-load events and groups on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventsProvider.notifier).loadEvents();
      ref.read(groupsProvider.notifier).loadGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsProvider);
    final groupsState = ref.watch(groupsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Events Section
                    _buildSection(
                      title: 'Événements',
                      subtitle:
                          'Rencontrer d\'autres personnes lors d\'événements',
                      icon: Icons.event_outlined,
                      child: SocialFeaturesWidget(
                        type: SocialFeatureType.events,
                        events: eventsState.events,
                        groups: groupsState.groups,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Groups Section
                    _buildSection(
                      title: 'Groupes',
                      subtitle: 'Rejoignez des groupes selon vos intérêts',
                      icon: Icons.group_outlined,
                      child: SocialFeaturesWidget(
                        type: SocialFeatureType.groups,
                        events: eventsState.events,
                        groups: groupsState.groups,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Friends of Friends Section
                    _buildSection(
                      title: 'Amis d\'amis',
                      subtitle: 'Découvrez des personnes via vos amis',
                      icon: Icons.people_outline,
                      child: const SocialFeaturesWidget(
                        type: SocialFeatureType.friendsOfFriends,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Double Date Section
                    _buildSection(
                      title: 'Double Date',
                      subtitle: 'Sélectionnez des amis pour un rendez-vous à 4',
                      icon: Icons.favorite_border,
                      child: const SocialFeaturesWidget(
                        type: SocialFeatureType.doubleDate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Événements, groupes et plus',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.navy.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.bordeaux.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.bordeaux,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2332),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.navy.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
