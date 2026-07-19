import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';

/// Admin user detail screen — shows full user profile with admin actions
class AdminUserDetailScreen extends ConsumerStatefulWidget {
  final String userId;

  const AdminUserDetailScreen({required this.userId, super.key});

  @override
  ConsumerState<AdminUserDetailScreen> createState() =>
      _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends ConsumerState<AdminUserDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUsersProvider.notifier).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);

    // Find the user in the loaded list
    final user = state.users.where((u) => u.id == widget.userId).firstOrNull;

    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Utilisateur non trouvé'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour à la liste'),
          ),

          const SizedBox(height: 24),

          // User header card
          _buildHeaderCard(user),

          const SizedBox(height: 24),

          // Info cards row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile info
              Expanded(child: _buildProfileInfoCard(user)),
              const SizedBox(width: 16),
              // Account info
              Expanded(child: _buildAccountInfoCard(user)),
            ],
          ),

          const SizedBox(height: 24),

          // Admin actions card
          _buildAdminActionsCard(user),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER CARD
  // ===========================================================================

  Widget _buildHeaderCard(AdminUserEntity user) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.bordeaux.withValues(alpha: 0.1),
            child: user.photoUrl != null
                ? ClipOval(
                    child: Image.network(
                      user.photoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Text(
                        user.displayName.isNotEmpty
                            ? user.displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: AppTheme.bordeaux, fontSize: 32),
                      ),
                    ),
                  )
                : Text(
                    user.displayName.isNotEmpty
                        ? user.displayName[0].toUpperCase()
                        : '?',
                    style:
                        const TextStyle(color: AppTheme.bordeaux, fontSize: 32),
                  ),
          ),
          const SizedBox(width: 24),

          // Name + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName.isNotEmpty ? user.displayName : 'Sans nom',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.navy.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRoleBadge(user.role),
                    const SizedBox(width: 8),
                    _buildStatusBadge(user.status),
                    const SizedBox(width: 8),
                    _buildEmailVerifiedBadge(user.emailVerified),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PROFILE INFO CARD
  // ===========================================================================

  Widget _buildProfileInfoCard(AdminUserEntity user) {
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
            'Informations profil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Nom d\'affichage', user.displayName.isNotEmpty ? user.displayName : '—'),
          _buildInfoRow('Genre', _translateGender(user.gender)),
          _buildInfoRow('Pays', user.countryCode.isNotEmpty ? user.countryCode : '—'),
          _buildInfoRow('Ville', user.city.isNotEmpty ? user.city : '—'),
          _buildInfoRow('Date d\'inscription', _formatDate(user.createdAt)),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACCOUNT INFO CARD
  // ===========================================================================

  Widget _buildAccountInfoCard(AdminUserEntity user) {
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
            'Informations compte',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('ID', user.id, isMonospace: true),
          _buildInfoRow('Email', user.email),
          _buildInfoRow('Rôle', _translateRole(user.role)),
          _buildInfoRow('Statut', user.status == 'active' ? 'Actif' : 'Banni'),
          _buildInfoRow('Email vérifié', user.emailVerified ? 'Oui' : 'Non'),
        ],
      ),
    );
  }

  // ===========================================================================
  // ADMIN ACTIONS CARD
  // ===========================================================================

  Widget _buildAdminActionsCard(AdminUserEntity user) {
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
            'Actions administrateur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Change role
              ElevatedButton.icon(
                onPressed: () => _showChangeRoleDialog(user),
                icon: const Icon(Icons.admin_panel_settings, size: 18),
                label: const Text('Changer le rôle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  foregroundColor: Colors.white,
                ),
              ),

              // Verify email
              if (!user.emailVerified)
                ElevatedButton.icon(
                  onPressed: () => _verifyEmail(user),
                  icon: const Icon(Icons.mark_email_read, size: 18),
                  label: const Text('Vérifier email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),

              // Ban / Activate
              if (user.status == 'active')
                ElevatedButton.icon(
                  onPressed: () => _banUser(user),
                  icon: const Icon(Icons.block, size: 18),
                  label: const Text('Bannir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),

              if (user.status == 'banned')
                ElevatedButton.icon(
                  onPressed: () => _activateUser(user),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Réactiver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACTIONS
  // ===========================================================================

  Future<void> _verifyEmail(AdminUserEntity user) async {
    final notifier = ref.read(adminUsersProvider.notifier);
    final success = await notifier.verifyEmailManually(user.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Email vérifié avec succès'
              : 'Erreur lors de la vérification'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) notifier.loadUsers();
    }
  }

  Future<void> _banUser(AdminUserEntity user) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bannir l\'utilisateur'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Raison du bannissement',
            hintText: 'Expliquez pourquoi...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Bannir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (reason != null && reason.isNotEmpty) {
      final notifier = ref.read(adminUsersProvider.notifier);
      final success = await notifier.banUser(user.id, reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Utilisateur banni'
                : 'Erreur lors du bannissement'),
            backgroundColor: success ? Colors.orange : Colors.red,
          ),
        );
        if (success) notifier.loadUsers();
      }
    }
  }

  Future<void> _activateUser(AdminUserEntity user) async {
    final notifier = ref.read(adminUsersProvider.notifier);
    final success = await notifier.activateUser(user.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Utilisateur réactivé'
              : 'Erreur lors de la réactivation'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) notifier.loadUsers();
    }
  }

  Future<void> _showChangeRoleDialog(AdminUserEntity user) async {
    final newRole = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Changer le rôle'),
        children: ['free', 'premium', 'admin'].map((role) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, role),
            child: Row(
              children: [
                if (role == user.role)
                  const Icon(Icons.check, color: AppTheme.bordeaux, size: 18),
                if (role == user.role) const SizedBox(width: 8),
                Text(_translateRole(role)),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (newRole != null && newRole != user.role) {
      final notifier = ref.read(adminUsersProvider.notifier);
      final success = await notifier.changeUserRole(user.id, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Rôle modifié vers ${_translateRole(newRole)}'
                : 'Erreur lors du changement de rôle'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) notifier.loadUsers();
      }
    }
  }

  // ===========================================================================
  // WIDGET HELPERS
  // ===========================================================================

  Widget _buildInfoRow(String label, String value, {bool isMonospace = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.navy.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.navy,
                fontFamily: isMonospace ? 'Courier' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    String label;
    switch (role) {
      case 'admin':
        color = AppTheme.bordeaux;
        label = 'Admin';
        break;
      case 'premium':
        color = AppTheme.gold;
        label = 'Premium';
        break;
      default:
        color = Colors.grey;
        label = 'Gratuit';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Actif' : 'Banni',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerifiedBadge(bool verified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: verified
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.check_circle : Icons.warning,
            size: 14,
            color: verified ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            verified ? 'Vérifié' : 'Non vérifié',
            style: TextStyle(
              color: verified ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _translateGender(String gender) {
    switch (gender) {
      case 'male':
        return 'Homme';
      case 'female':
        return 'Femme';
      case 'other':
        return 'Autre';
      default:
        return '—';
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
