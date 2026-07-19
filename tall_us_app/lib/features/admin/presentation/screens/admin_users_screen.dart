import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';
import 'package:tall_us/features/admin/utils/csv_export.dart';

/// Admin users management screen with search, filters, and data table
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String? _selectedRole;
  bool? _emailVerifiedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUsersProvider.notifier).loadUsers(resetPage: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);

    return Column(
      children: [
        // Filters bar
        _buildFiltersBar(state),

        // Data table
        Expanded(
          child: state.isLoading && state.users.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.bordeaux),
                )
              : state.error != null && state.users.isEmpty
                  ? _buildError(state.error!)
                  : _buildUsersTable(state),
        ),

        // Pagination
        if (state.users.isNotEmpty) _buildPagination(state),
      ],
    );
  }

  // ===========================================================================
  // FILTERS BAR
  // ===========================================================================

  Widget _buildFiltersBar(AdminUsersState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Search field
          SizedBox(
            width: 280,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par email...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(adminUsersProvider.notifier).setSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              onSubmitted: (value) {
                ref.read(adminUsersProvider.notifier).setSearch(value);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Role filter
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Rôle',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Tous')),
                DropdownMenuItem(value: 'free', child: Text('Gratuit')),
                DropdownMenuItem(value: 'premium', child: Text('Premium')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                setState(() => _selectedRole = value);
                ref.read(adminUsersProvider.notifier).setRoleFilter(value);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Email verified filter
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<bool>(
              initialValue: _emailVerifiedFilter,
              decoration: InputDecoration(
                labelText: 'Email vérifié',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Tous')),
                DropdownMenuItem(value: true, child: Text('Vérifié')),
                DropdownMenuItem(value: false, child: Text('Non vérifié')),
              ],
              onChanged: (value) {
                setState(() => _emailVerifiedFilter = value);
                ref
                    .read(adminUsersProvider.notifier)
                    .setEmailVerifiedFilter(value);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.navy),
            onPressed: () {
              ref.read(adminUsersProvider.notifier).loadUsers();
            },
            tooltip: 'Actualiser',
          ),

          const Spacer(),

          // Export CSV button
          OutlinedButton.icon(
            onPressed: state.users.isEmpty ? null : _exportUsersCsv,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('CSV'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.navy,
              side: BorderSide(color: AppTheme.navy.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),

          const SizedBox(width: 16),

          // User count
          Text(
            '${state.totalCount} utilisateur${state.totalCount != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // USERS TABLE
  // ===========================================================================

  Widget _buildUsersTable(AdminUsersState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFFF5F5F5),
          ),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.navy,
            fontSize: 13,
          ),
          dataTextStyle: TextStyle(
            fontSize: 13,
            color: AppTheme.navy.withValues(alpha: 0.8),
          ),
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: const [
            DataColumn(label: Text('Utilisateur')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Genre')),
            DataColumn(label: Text('Rôle')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Email vérifié')),
            DataColumn(label: Text('Inscription')),
            DataColumn(label: Text('Actions')),
          ],
          rows: state.users.map((user) {
            return DataRow(cells: [
              // User (avatar + name)
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          AppTheme.bordeaux.withValues(alpha: 0.1),
                      child: user.photoUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user.photoUrl!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Text(
                                  user.displayName.isNotEmpty
                                      ? user.displayName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: AppTheme.bordeaux, fontSize: 14),
                                ),
                              ),
                            )
                          : Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: AppTheme.bordeaux, fontSize: 14),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.displayName.isNotEmpty ? user.displayName : '—',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                onTap: () => context.go('/admin/users/${user.id}'),
              ),

              // Email
              DataCell(Text(user.email)),

              // Gender
              DataCell(Text(_translateGender(user.gender))),

              // Role
              DataCell(_buildRoleChip(user.role)),

              // Status
              DataCell(_buildStatusChip(user.status)),

              // Email verified
              DataCell(
                Icon(
                  user.emailVerified ? Icons.check_circle : Icons.cancel,
                  color: user.emailVerified ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),

              // Created at
              DataCell(Text(_formatDate(user.createdAt))),

              // Actions
              DataCell(_buildActionMenu(user)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // ===========================================================================
  // PAGINATION
  // ===========================================================================

  Widget _buildPagination(AdminUsersState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: state.currentPage > 0
                ? () => ref.read(adminUsersProvider.notifier).previousPage()
                : null,
          ),
          Text(
            'Page ${state.currentPage + 1} / ${state.totalPages > 0 ? state.totalPages : 1}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: state.hasMore
                ? () => ref.read(adminUsersProvider.notifier).nextPage()
                : null,
          ),
        ],
      ),
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
                ref.read(adminUsersProvider.notifier).loadUsers(),
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
  // HELPERS
  // ===========================================================================

  Widget _buildRoleChip(String role) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget _buildStatusChip(String status) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget _buildActionMenu(AdminUserEntity user) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (action) => _handleAction(action, user),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('Voir le profil')),
        if (!user.emailVerified)
          const PopupMenuItem(
              value: 'verify_email', child: Text('Vérifier email manuellement')),
        if (user.status == 'active')
          const PopupMenuItem(value: 'ban', child: Text('Bannir')),
        if (user.status == 'banned')
          const PopupMenuItem(value: 'activate', child: Text('Réactiver')),
        const PopupMenuItem(value: 'change_role', child: Text('Changer le rôle')),
      ],
    );
  }

  Future<void> _handleAction(String action, AdminUserEntity user) async {
    final notifier = ref.read(adminUsersProvider.notifier);
    bool success = false;

    switch (action) {
      case 'view':
        context.go('/admin/users/${user.id}');
        return;
      case 'verify_email':
        success = await notifier.verifyEmailManually(user.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email vérifié avec succès')),
          );
        }
        break;
      case 'ban':
        final reason = await _showBanDialog();
        if (reason != null && reason.isNotEmpty) {
          success = await notifier.banUser(user.id, reason);
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Utilisateur banni')),
            );
          }
        } else {
          return;
        }
        break;
      case 'activate':
        success = await notifier.activateUser(user.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Utilisateur réactivé')),
          );
        }
        break;
      case 'change_role':
        final newRole = await _showChangeRoleDialog(user.role);
        if (newRole != null) {
          success = await notifier.changeUserRole(user.id, newRole);
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rôle modifié')),
            );
          }
        } else {
          return;
        }
        break;
    }

    if (success) {
      notifier.loadUsers();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'action'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showBanDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bannir l\'utilisateur'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Raison du bannissement',
            hintText: 'Expliquez pourquoi cet utilisateur est banni...',
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
  }

  Future<String?> _showChangeRoleDialog(String currentRole) {
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Changer le rôle'),
        children: ['free', 'premium', 'admin'].map((role) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, role),
            child: Row(
              children: [
                if (role == currentRole)
                  const Icon(Icons.check, color: AppTheme.bordeaux, size: 18),
                if (role == currentRole) const SizedBox(width: 8),
                Text(_translateRole(role)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _exportUsersCsv() {
    final state = ref.read(adminUsersProvider);
    final rows = state.users.map((u) => {
      'id': u.id,
      'email': u.email,
      'displayName': u.displayName,
      'gender': u.gender,
      'role': u.role,
      'countryCode': u.countryCode,
      'city': u.city,
      'emailVerified': u.emailVerified.toString(),
      'status': u.status,
      'createdAt': u.createdAt.toIso8601String(),
    }).toList();

    CsvExport.exportUsers(rows);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${rows.length} utilisateurs exportés en CSV'),
        backgroundColor: Colors.green,
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
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
