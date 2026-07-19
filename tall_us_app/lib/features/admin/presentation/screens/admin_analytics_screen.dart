import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/admin_kpi_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';
import 'package:tall_us/features/admin/utils/csv_export.dart';

/// Admin analytics screen with charts and statistics
class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminAnalyticsProvider.notifier).loadAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminAnalyticsProvider);

    if (state.isLoading && state.kpis == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.bordeaux),
      );
    }

    if (state.error != null && state.kpis == null) {
      return _buildError(state.error!);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              const Spacer(),
              // Export CSV
              OutlinedButton.icon(
                onPressed: state.kpis != null ? _exportAnalyticsCsv : null,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export CSV'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.navy,
                  side: BorderSide(color: AppTheme.navy.withValues(alpha: 0.3)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.navy),
                onPressed: () =>
                    ref.read(adminAnalyticsProvider.notifier).loadAnalytics(),
                tooltip: 'Actualiser',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Top row: Line chart (user growth) + Pie chart (gender)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User growth line chart
              Expanded(
                flex: 3,
                child: _buildChartCard(
                  title: 'Croissance utilisateurs (30 jours)',
                  child: _buildUserGrowthChart(state),
                ),
              ),
              const SizedBox(width: 16),
              // Gender distribution pie chart
              Expanded(
                flex: 2,
                child: _buildChartCard(
                  title: 'Répartition par genre',
                  child: _buildGenderPieChart(state),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bottom row: Bar chart (matches/messages) + Role pie chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Matches & Messages bar chart
              Expanded(
                flex: 3,
                child: _buildChartCard(
                  title: 'Matchs & Messages (30 jours)',
                  child: _buildMatchMessageChart(state),
                ),
              ),
              const SizedBox(width: 16),
              // Role distribution pie chart
              Expanded(
                flex: 2,
                child: _buildChartCard(
                  title: 'Répartition par rôle',
                  child: _buildRolePieChart(state),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // KPI summary row
          if (state.kpis != null) _buildKpiSummary(state.kpis!),
        ],
      ),
    );
  }

  // ===========================================================================
  // CHART CARD WRAPPER
  // ===========================================================================

  Widget _buildChartCard({
    required String title,
    required Widget child,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: child,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // USER GROWTH LINE CHART
  // ===========================================================================

  Widget _buildUserGrowthChart(AdminAnalyticsState state) {
    if (state.userGrowthData.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < state.userGrowthData.length; i++) {
      spots.add(FlSpot(i.toDouble(), state.userGrowthData[i].value.toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateInterval(spots),
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.navy.withValues(alpha: 0.4),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 7,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < state.userGrowthData.length) {
                  final date = state.userGrowthData[value.toInt()].date;
                  return Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.navy.withValues(alpha: 0.4),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.bordeaux,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.bordeaux.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()} utilisateurs',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MATCH & MESSAGE BAR CHART
  // ===========================================================================

  Widget _buildMatchMessageChart(AdminAnalyticsState state) {
    if (state.matchTrendData.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    final matchSpots = <BarChartGroupData>[];
    for (int i = 0; i < state.matchTrendData.length; i++) {
      final matchVal = state.matchTrendData[i].value.toDouble();
      final messageVal = state.messageTrendData[i].value.toDouble();
      matchSpots.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: matchVal,
            color: AppTheme.bordeaux,
            width: 6,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
          ),
          BarChartRodData(
            toY: messageVal,
            color: AppTheme.navy.withValues(alpha: 0.6),
            width: 6,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
          ),
        ],
      ));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _maxY(state) / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.navy.withValues(alpha: 0.4),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 7,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < state.matchTrendData.length) {
                  final date = state.matchTrendData[value.toInt()].date;
                  return Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.navy.withValues(alpha: 0.4),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: matchSpots,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = rodIndex == 0 ? 'Matchs' : 'Messages';
              return BarTooltipItem(
                '$label: ${rod.toY.toInt()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // GENDER PIE CHART
  // ===========================================================================

  Widget _buildGenderPieChart(AdminAnalyticsState state) {
    if (state.genderDistribution.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    final entries = state.genderDistribution.entries.toList();
    final total = entries.fold(0, (sum, e) => sum + e.value);
    final colors = [AppTheme.bordeaux, Colors.blue, Colors.purple, Colors.teal];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: entries.asMap().entries.map((entry) {
                final percent =
                    total > 0 ? (entry.value.value / total * 100) : 0.0;
                return PieChartSectionData(
                  value: entry.value.value.toDouble(),
                  color: colors[entry.key % colors.length],
                  radius: 60,
                  title: '${percent.toStringAsFixed(0)}%',
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          children: entries.asMap().entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[entry.key % colors.length],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_translateGender(entry.value.key)}: ${entry.value.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // ROLE PIE CHART
  // ===========================================================================

  Widget _buildRolePieChart(AdminAnalyticsState state) {
    if (state.roleDistribution.isEmpty) {
      return const Center(child: Text('Aucune donnée'));
    }

    final entries = state.roleDistribution.entries.toList();
    final total = entries.fold(0, (sum, e) => sum + e.value);
    final colors = [Colors.grey, AppTheme.gold, AppTheme.bordeaux];

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: entries.asMap().entries.map((entry) {
                final percent =
                    total > 0 ? (entry.value.value / total * 100) : 0.0;
                return PieChartSectionData(
                  value: entry.value.value.toDouble(),
                  color: colors[entry.key % colors.length],
                  radius: 60,
                  title: '${percent.toStringAsFixed(0)}%',
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          children: entries.asMap().entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[entry.key % colors.length],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_translateRole(entry.value.key)}: ${entry.value.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // KPI SUMMARY
  // ===========================================================================

  Widget _buildKpiSummary(AdminKpiEntity kpis) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Résumé global',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              _buildStatItem('Utilisateurs totaux', '${kpis.totalUsers}',
                  Icons.people, AppTheme.navy),
              _buildStatItem('Nouveaux (aujourd\'hui)', '${kpis.newUsersToday}',
                  Icons.person_add, Colors.green),
              _buildStatItem('Nouveaux (semaine)', '${kpis.newUsersThisWeek}',
                  Icons.trending_up, Colors.blue),
              _buildStatItem('Nouveaux (mois)', '${kpis.newUsersThisMonth}',
                  Icons.calendar_month, Colors.orange),
              _buildStatItem('Premium', '${kpis.premiumCount}',
                  Icons.workspace_premium, AppTheme.gold),
              _buildStatItem('Matchs', '${kpis.matchesCount}',
                  Icons.favorite, AppTheme.bordeaux),
              _buildStatItem('Messages', '${kpis.messagesCount}',
                  Icons.chat_bubble, Colors.blue),
              _buildStatItem('Vérifications en attente',
                  '${kpis.verificationPendingCount}',
                  Icons.pending_actions, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.navy.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 16),
          Text('Erreur: $error',
              style: const TextStyle(color: AppTheme.navy)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.read(adminAnalyticsProvider.notifier).loadAnalytics(),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.bordeaux),
            child:
                const Text('Réessayer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EXPORT CSV
  // ===========================================================================

  void _exportAnalyticsCsv() {
    final kpis = ref.read(adminAnalyticsProvider).kpis;
    if (kpis == null) return;

    CsvExport.exportKpis({
      'totalUsers': kpis.totalUsers,
      'newUsersToday': kpis.newUsersToday,
      'newUsersThisWeek': kpis.newUsersThisWeek,
      'newUsersThisMonth': kpis.newUsersThisMonth,
      'premiumCount': kpis.premiumCount,
      'matchesCount': kpis.matchesCount,
      'messagesCount': kpis.messagesCount,
      'verificationPendingCount': kpis.verificationPendingCount,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics exportées en CSV'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  double _calculateInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    final maxVal = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) return 1;
    return (maxVal / 5).ceilToDouble();
  }

  double _maxY(AdminAnalyticsState state) {
    double maxVal = 1;
    for (final d in state.matchTrendData) {
      if (d.value > maxVal) maxVal = d.value.toDouble();
    }
    for (final d in state.messageTrendData) {
      if (d.value > maxVal) maxVal = d.value.toDouble();
    }
    return maxVal;
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

  String _translateRole(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'premium':
        return 'Premium';
      default:
        return 'Gratuit';
    }
  }
}
