import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Achievement entity
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int progress;
  final int maxProgress;
  final int xpReward;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.progress = 0,
    this.maxProgress = 1,
    this.xpReward = 100,
  });

  double get progressPercentage => maxProgress > 0 ? progress / maxProgress : 0;
}

/// Achievements Dashboard Widget
class AchievementsDashboard extends StatelessWidget {
  final List<Achievement> achievements;
  final int totalXP;
  final int level;

  const AchievementsDashboard({
    super.key,
    required this.achievements,
    required this.totalXP,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Succès',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.gold,
                      AppTheme.gold.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$totalXP XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          // Level card
          _buildLevelCard().animate().fadeIn(duration: 300.ms).then(),

          const SizedBox(height: 20),

          // Achievements list
          Text(
            'Vos Succès',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 12),

          ...achievements.map((achievement) =>
              _buildAchievementCard(achievement)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .then()),
        ],
      ),
    );
  }

  Widget _buildLevelCard() {
    final xpForCurrentLevel = level * 1000;
    final xpForNextLevel = (level + 1) * 1000;
    final xpProgress = totalXP - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    final levelProgress = xpProgress / xpNeeded;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bordeaux.withValues(alpha: 0.1),
            AppTheme.navy.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.bordeaux.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.bordeaux,
                          AppTheme.bordeaux.withValues(alpha: 0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        level.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Niveau Actuel',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray600,
                        ),
                      ),
                      Text(
                        'Level $level',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$xpProgress / $xpNeeded XP',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray600,
                    ),
                  ),
                  Text(
                    '${xpNeeded - xpProgress} XP restants',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.bordeaux,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: levelProgress,
              backgroundColor: AppTheme.gray200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? achievement.color.withValues(alpha: 0.1)
            : AppTheme.gray100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? achievement.color.withValues(alpha: 0.3)
              : AppTheme.gray200,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? achievement.color.withValues(alpha: 0.2)
                  : AppTheme.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color:
                  achievement.isUnlocked ? achievement.color : AppTheme.gray400,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked
                              ? AppTheme.navy
                              : AppTheme.gray600,
                        ),
                      ),
                    ),
                    if (achievement.isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: achievement.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.white,
                              size: 10,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+${achievement.xpReward} XP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: achievement.isUnlocked
                        ? AppTheme.gray700
                        : AppTheme.gray500,
                  ),
                ),
                if (!achievement.isUnlocked && achievement.maxProgress > 1) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: achievement.progressPercentage,
                      backgroundColor: AppTheme.gray300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achievement.color,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${achievement.progress} / ${achievement.maxProgress}',
                    style: TextStyle(
                      fontSize: 11,
                      color: achievement.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Achievement unlocked dialog
class AchievementUnlockedDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockedDialog({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              achievement.color.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: achievement.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                color: achievement.color,
                size: 40,
              ),
            ).animate().scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 16),

            const Text(
              'Succès Débloqué !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              achievement.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: achievement.color,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              achievement.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: achievement.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: achievement.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continuer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// XP Progress Bar Widget
class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int level;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final xpForCurrentLevel = level * 1000;
    final xpForNextLevel = (level + 1) * 1000;
    final xpProgress = currentXP - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    final progress = xpProgress / xpNeeded;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Niveau $level',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              Text(
                '$xpProgress / $xpNeeded XP',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.gray600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.gray200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
