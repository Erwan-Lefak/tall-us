import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';

/// Profile Statistics Dashboard - Shows profile metrics and insights
class ProfileStatisticsDashboard extends StatelessWidget {
  final UserProfileEntity profile;
  final Map<String, dynamic> stats;

  const ProfileStatisticsDashboard({
    super.key,
    required this.profile,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques du Profil',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Profile completion
          _buildCompletionCard().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 16),

          // Main stats grid
          _buildStatsGrid().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 16),

          // Performance insights
          _buildPerformanceInsights().animate().fadeIn(duration: 300.ms).then(),

          const SizedBox(height: 16),

          // Tips to improve
          _buildTipsSection().animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildCompletionCard() {
    final completion = profile.getCompletionPercentage();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bordeaux.withValues(alpha: 0.1),
            AppTheme.navy.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.bordeaux.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Complétion du Profil',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getCompletionColor(completion).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${completion.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getCompletionColor(completion),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completion / 100,
              backgroundColor: AppTheme.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCompletionColor(completion),
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _getCompletionMessage(completion),
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.navy.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // Checklist
          _buildCompletionChecklist(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(
          icon: Icons.visibility,
          label: 'Vues',
          value: _formatNumber(stats['profileViews'] ?? 0),
          color: AppTheme.blue,
        ),
        _buildStatCard(
          icon: Icons.favorite,
          label: 'Likes Reçus',
          value: _formatNumber(stats['likesReceived'] ?? 0),
          color: AppTheme.bordeaux,
        ),
        _buildStatCard(
          icon: Icons.people,
          label: 'Matchs',
          value: _formatNumber(stats['matches'] ?? 0),
          color: AppTheme.purple,
        ),
        _buildStatCard(
          icon: Icons.message,
          label: 'Messages',
          value: _formatNumber(stats['messages'] ?? 0),
          color: AppTheme.teal,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    final matchRate = stats['matches'] > 0 && stats['likesReceived'] > 0
        ? (stats['matches'] / stats['likesReceived'] * 100).toInt()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          _buildInsightRow(
            'Taux de Match',
            '$matchRate%',
            _getPerformanceColor(matchRate),
          ),
          const SizedBox(height: 8),
          _buildInsightRow(
            'Réponse aux Messages',
            '${stats['responseRate'] ?? 0}%',
            AppTheme.teal,
          ),
          const SizedBox(height: 8),
          _buildInsightRow(
            'Temps de Réponse Moyen',
            _formatTime(stats['avgResponseTime'] ?? 0),
            AppTheme.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.gray700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    final tips = _getProfileTips();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.gold.withValues(alpha: 0.1),
            AppTheme.gold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: AppTheme.gold,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Conseils pour Améliorer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.gold,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.navy.withValues(alpha: 0.8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCompletionChecklist() {
    final items = [
      ('Photos', profile.photoUrls.length >= 3),
      ('Bio', profile.bio.isNotEmpty),
      ('Prompts', profile.prompts.isNotEmpty),
      ('Intérêts', profile.interests.isNotEmpty),
      ('Emploi', profile.jobTitle != null),
      ('Éducation', profile.school != null),
      ('Vérification Taille', profile.heightVerified),
    ];

    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      item.$2 ? Icons.check_circle : Icons.circle,
                      color: item.$2 ? AppTheme.bordeaux : AppTheme.gray400,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 12,
                        color: item.$2 ? AppTheme.navy : AppTheme.gray600,
                        decoration: item.$2 ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Color _getCompletionColor(double completion) {
    if (completion >= 80) return AppTheme.green;
    if (completion >= 50) return AppTheme.gold;
    return AppTheme.orange;
  }

  String _getCompletionMessage(double completion) {
    if (completion >= 80) {
      return 'Excellent ! Votre profil est très complet et attire beaucoup d\'attention.';
    } else if (completion >= 50) {
      return 'Bon départ ! Complétez davantage votre profil pour plus de matchs.';
    } else {
      return 'Votre profil a besoin de plus d\'informations pour être mis en avant.';
    }
  }

  Color _getPerformanceColor(int rate) {
    if (rate >= 30) return AppTheme.green;
    if (rate >= 15) return AppTheme.gold;
    return AppTheme.orange;
  }

  List<String> _getProfileTips() {
    final tips = <String>[];

    if (profile.photoUrls.length < 3) {
      tips.add(
          'Ajoutez au moins 3 photos pour montrer différents aspects de votre personnalité');
    }
    if (profile.prompts.isEmpty) {
      tips.add('Répondez à des prompts pour briser la glace plus facilement');
    }
    if (profile.interests.isEmpty) {
      tips.add(
          'Ajoutez vos centres d\'intérêt pour trouver des profils compatibles');
    }
    if (profile.bio.isEmpty) {
      tips.add('Rédigez une bio accrocheuse qui vous représente');
    }
    if (!profile.heightVerified) {
      tips.add('Faites vérifier votre taille pour gagner en crédibilité');
    }

    if (tips.isEmpty) {
      tips.add(
          'Votre profil est excellent ! Continuez à être actif pour maximiser vos matchs');
    }

    return tips;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    } else {
      return '${minutes ~/ 1440}j';
    }
  }
}
