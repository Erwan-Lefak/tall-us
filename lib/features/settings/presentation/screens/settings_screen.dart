import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/discovery/presentation/providers/discovery_extended_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';

/// Settings Screen
///
/// Main settings screen with:
/// - Premium subscription management
/// - Feature toggles
/// - Account settings
/// - Privacy settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final premiumState = ref.watch(premiumStatusProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Premium Status Card
          _buildPremiumCard(premiumState),

          const SizedBox(height: 24),

          // Discovery Settings
          _buildSection(
            title: 'Découverte',
            icon: Icons.explore_outlined,
            children: [
              _buildSwitchTile(
                title: 'Top Picks',
                subtitle: 'Voir vos meilleurs matches par algorithme',
                icon: Icons.star_outlined,
                isEnabled: premiumState.isGold,
                value: false, // TODO: Connect to user preferences
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Qui m\'a aimé',
                subtitle: 'Voir toutes les personnes qui vous ont liké',
                icon: Icons.favorite_outline,
                isEnabled: premiumState.isPlatinum,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile Settings
          _buildSection(
            title: 'Profil',
            icon: Icons.person_outline,
            children: [
              _buildSwitchTile(
                title: 'Photos intelligentes',
                subtitle: 'Réorganiser automatiquement vos photos',
                icon: Icons.photo_library_outlined,
                isEnabled: premiumState.isGold,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Vérification de taille',
                subtitle: 'Afficher le badge de taille vérifiée',
                icon: Icons.height_outlined,
                isEnabled: true, // Free feature
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Social Settings
          _buildSection(
            title: 'Social',
            icon: Icons.groups_outlined,
            children: [
              _buildSwitchTile(
                title: 'Amis d\'amis',
                subtitle: 'Voir les amis de vos amis',
                icon: Icons.people_outline,
                isEnabled: premiumState.isGold,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Double Date',
                subtitle: 'Mode rendez-vous à 4',
                icon: Icons.favorite_border,
                isEnabled: premiumState.isPlatinum,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Événements',
                subtitle: 'Participer aux événements sociaux',
                icon: Icons.event_outlined,
                isEnabled: premiumState.isGold,
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Groupes',
                subtitle: 'Rejoindre des groupes par intérêts',
                icon: Icons.group_work_outlined,
                isEnabled: premiumState.isGold,
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Messaging Settings
          _buildSection(
            title: 'Messagerie',
            icon: Icons.chat_bubble_outline,
            children: [
              _buildSwitchTile(
                title: 'Messages enrichis',
                subtitle: 'GIFs, audio, vidéo dans les conversations',
                icon: Icons.gif_outlined,
                isEnabled: premiumState.isPlatinum,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Réactions aux messages',
                subtitle: 'Réagir avec des emojis',
                icon: Icons.emoji_emotions_outlined,
                isEnabled: true, // Free feature
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Réponses',
                subtitle: 'Répondre à un message spécifique',
                icon: Icons.reply_outlined,
                isEnabled: true, // Free feature
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Privacy Settings
          _buildSection(
            title: 'Confidentialité',
            icon: Icons.lock_outline,
            children: [
              _buildSwitchTile(
                title: 'Profil visible',
                subtitle: 'Les autres peuvent voir votre profil',
                icon: Icons.visibility_outlined,
                isEnabled: true,
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Montrer distance',
                subtitle: 'Afficher la distance sur les profils',
                icon: Icons.location_on_outlined,
                isEnabled: true,
                value: true,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
              _buildSwitchTile(
                title: 'Statut en ligne',
                subtitle: 'Montrer quand vous êtes en ligne',
                icon: Icons.circle_outlined,
                isEnabled: true,
                value: false,
                onChanged: (value) {
                  // TODO: Save preference
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Account Actions
          _buildSection(
            title: 'Compte',
            icon: Icons.settings_outlined,
            children: [
              _buildActionTile(
                title: 'Modifier le profil',
                subtitle: 'Mettre à jour vos informations',
                icon: Icons.edit_outlined,
                onTap: () {
                  // TODO: Navigate to profile edit
                },
              ),
              _buildActionTile(
                title: 'Changer le mot de passe',
                subtitle: 'Mettre à jour votre mot de passe',
                icon: Icons.lock_outline,
                onTap: () {
                  // TODO: Navigate to password change
                },
              ),
              _buildActionTile(
                title: 'Notifications',
                subtitle: 'Gérer les préférences de notification',
                icon: Icons.notifications_outlined,
                onTap: () {
                  // TODO: Navigate to notifications settings
                },
              ),
              _buildActionTile(
                title: 'Supprimer le compte',
                subtitle: 'Supprimer définitivement votre compte',
                icon: Icons.delete_forever_outlined,
                isDestructive: true,
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout
          _buildLogoutButton(authState),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2332)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Paramètres',
        style: TextStyle(
          color: Color(0xFF1A2332),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPremiumCard(PremiumStatusState premiumState) {
    final tier = premiumState.subscriptionTier;
    final tierName = tier == SubscriptionTier.platinum
        ? 'Platinum'
        : tier == SubscriptionTier.gold
            ? 'Gold'
            : 'Gratuit';
    final tierColor = tier == SubscriptionTier.platinum
        ? const Color(0xFFE5E4E2)
        : tier == SubscriptionTier.gold
            ? const Color(0xFFFFD700)
            : const Color(0xFF9E9E9E);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tier == SubscriptionTier.platinum
              ? [const Color(0xFFE5E4E2), const Color(0xFFBDBDBD)]
              : tier == SubscriptionTier.gold
                  ? [const Color(0xFFFFD700), const Color(0xFFFFC107)]
                  : [const Color(0xFF9E9E9E), const Color(0xFF757575)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: tierColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tier == SubscriptionTier.platinum
                  ? Icons.workspace_premium
                  : tier == SubscriptionTier.gold
                      ? Icons.star
                      : Icons.person_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Abonnement $tierName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tier == SubscriptionTier.platinum
                      ? 'Toutes les fonctionnalités débloquées'
                      : tier == SubscriptionTier.gold
                          ? 'Fonctionnalités Premium débloquées'
                          : 'Passez à Premium pour plus de fonctionnalités',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (tier == SubscriptionTier.free)
            ElevatedButton(
              onPressed: () {
                _showUpgradeDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.bordeaux,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Upgrade'),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2332),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isEnabled ? AppTheme.bordeaux : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isEnabled ? const Color(0xFF1A2332) : Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isEnabled ? const Color(0xFF616161) : Colors.grey.shade400,
          fontSize: 12,
        ),
      ),
      trailing: isEnabled
          ? Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.bordeaux,
            )
          : Icon(
              Icons.lock_outlined,
              color: Colors.grey.shade400,
              size: 20,
            ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppTheme.bordeaux,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : const Color(0xFF1A2332),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDestructive
              ? Colors.red.withValues(alpha: 0.7)
              : const Color(0xFF616161),
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(AuthState authState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          ref.read(authStateProvider.notifier).logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.bordeaux,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Se déconnecter',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => _UpgradeDialog(
        onUpgrade: (tier) {
          ref.read(premiumStatusProvider.notifier).updateSubscription(tier);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete account
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

/// Upgrade Dialog
class _UpgradeDialog extends StatelessWidget {
  final Function(SubscriptionTier) onUpgrade;

  const _UpgradeDialog({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choisir un abonnement'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UpgradeOption(
            title: 'Gold',
            price: '9,99 €/mois',
            features: [
              'Top Picks',
              'Photos intelligentes',
              'Amis d\'amis',
              'Événements et Groupes',
            ],
            color: const Color(0xFFFFD700),
            onTap: () => onUpgrade(SubscriptionTier.gold),
          ),
          const SizedBox(height: 12),
          _UpgradeOption(
            title: 'Platinum',
            price: '19,99 €/mois',
            features: [
              'Tout Gold +',
              'Qui m\'a aimé',
              'Double Date',
              'Messages enrichis (GIF, audio, vidéo)',
            ],
            color: const Color(0xFFE5E4E2),
            onTap: () => onUpgrade(SubscriptionTier.platinum),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class _UpgradeOption extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Color color;
  final VoidCallback onTap;

  const _UpgradeOption({
    required this.title,
    required this.price,
    required this.features,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2332),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF616161),
                        ),
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
}
