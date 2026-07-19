import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';

/// Admin dashboard screen with KPI cards and charts
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminDashboardProvider.notifier).loadKpis();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminDashboardProvider);

    // While KPIs are not loaded yet, show a spinner (or error if it failed).
    if (state.kpis == null) {
      if (state.error != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
              const SizedBox(height: 16),
              Text('Erreur: ${state.error}',
                  style: const TextStyle(color: AppTheme.navy)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(adminDashboardProvider.notifier).loadKpis(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bordeaux),
                child: const Text('Réessayer',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.bordeaux),
      );
    }

    final kpis = state.kpis!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome header
          Text(
            'Vue d\'ensemble',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bienvenue sur le dashboard d\'administration Tall Us',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),

          // KPI Cards Grid
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildKpiCard(
                title: 'Utilisateurs totaux',
                value: '${kpis.totalUsers}',
                icon: Icons.people,
                color: AppTheme.navy,
                subtitle: '+${kpis.newUsersThisMonth} ce mois',
              ),
              _buildKpiCard(
                title: 'Nouveaux aujourd\'hui',
                value: '${kpis.newUsersToday}',
                icon: Icons.person_add,
                color: Colors.green,
                subtitle: '${kpis.newUsersThisWeek} cette semaine',
              ),
              _buildKpiCard(
                title: 'Abonnés Premium',
                value: '${kpis.premiumCount}',
                icon: Icons.workspace_premium,
                color: AppTheme.gold,
                subtitle:
                    '${kpis.totalUsers > 0 ? ((kpis.premiumCount / kpis.totalUsers) * 100).toStringAsFixed(1) : '0'}% du total',
              ),
              _buildKpiCard(
                title: 'Matchs',
                value: '${kpis.matchesCount}',
                icon: Icons.favorite,
                color: AppTheme.bordeaux,
                subtitle: 'Total sur la plateforme',
              ),
              _buildKpiCard(
                title: 'Messages',
                value: '${kpis.messagesCount}',
                icon: Icons.chat_bubble,
                color: Colors.blue,
                subtitle: 'Total échangés',
              ),
              _buildKpiCard(
                title: 'Vérifications en attente',
                value: '${kpis.verificationPendingCount}',
                icon: Icons.pending_actions,
                color: Colors.orange,
                subtitle: 'À traiter',
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Gender distribution
          if (kpis.genderDistribution.isNotEmpty) ...[
            Text(
              'Répartition par genre',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Wrap(
                spacing: 24,
                runSpacing: 12,
                children: kpis.genderDistribution.entries.map((entry) {
                  final total =
                      kpis.genderDistribution.values.fold(0, (a, b) => a + b);
                  final percent = total > 0
                      ? ((entry.value / total) * 100).toStringAsFixed(1)
                      : '0';
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: entry.key == 'male'
                              ? Colors.blue
                              : entry.key == 'female'
                                  ? AppTheme.bordeaux
                                  : Colors.purple,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_translateGender(entry.key)}: ${entry.value} ($percent%)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.navy,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _translateGender(String gender) {
    switch (gender) {
      case 'male':
        return 'Hommes';
      case 'female':
        return 'Femmes';
      default:
        return 'Autres';
    }
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.navy.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.navy.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
