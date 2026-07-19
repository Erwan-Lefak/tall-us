import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/newsletter_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';

/// Admin newsletters management screen — list, filter, create, send
class AdminNewslettersScreen extends ConsumerStatefulWidget {
  const AdminNewslettersScreen({super.key});

  @override
  ConsumerState<AdminNewslettersScreen> createState() =>
      _AdminNewslettersScreenState();
}

class _AdminNewslettersScreenState
    extends ConsumerState<AdminNewslettersScreen> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminNewslettersProvider.notifier).loadNewsletters(resetPage: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminNewslettersProvider);

    return Column(
      children: [
        // Filters + actions bar
        _buildFiltersBar(state),

        // Data table
        Expanded(
          child: state.isLoading && state.newsletters.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.bordeaux),
                )
              : state.error != null && state.newsletters.isEmpty
                  ? _buildError(state.error!)
                  : state.newsletters.isEmpty
                      ? _buildEmptyState()
                      : _buildNewslettersTable(state),
        ),
      ],
    );
  }

  // ===========================================================================
  // FILTERS BAR
  // ===========================================================================

  Widget _buildFiltersBar(AdminNewslettersState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Status filter
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String?>(
              initialValue: _statusFilter,
              decoration: InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Tous'),
                ),
                DropdownMenuItem<String?>(
                  value: 'draft',
                  child: Text('Brouillon'),
                ),
                DropdownMenuItem<String?>(
                  value: 'sent',
                  child: Text('Envoyée'),
                ),
              ],
              onChanged: (value) {
                setState(() => _statusFilter = value);
                ref.read(adminNewslettersProvider.notifier).setStatusFilter(value);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.navy),
            onPressed: () {
              ref.read(adminNewslettersProvider.notifier).loadNewsletters();
            },
            tooltip: 'Actualiser',
          ),

          const Spacer(),

          // Count
          Text(
            '${state.newsletters.length} newsletter${state.newsletters.length != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.6),
            ),
          ),

          const SizedBox(width: 16),

          // Create button
          ElevatedButton.icon(
            onPressed: () => context.go('/admin/newsletters/new'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Nouvelle newsletter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // NEWSLETTERS TABLE
  // ===========================================================================

  Widget _buildNewslettersTable(AdminNewslettersState state) {
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
            DataColumn(label: Text('Titre')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Segment')),
            DataColumn(label: Text('Destinataires')),
            DataColumn(label: Text('Créée le')),
            DataColumn(label: Text('Envoyée le')),
            DataColumn(label: Text('Actions')),
          ],
          rows: state.newsletters.map((nl) {
            return DataRow(cells: [
              // Title
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: Text(
                    nl.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Status
              DataCell(_buildStatusChip(nl.status)),

              // Segment rules
              DataCell(
                Text(
                  nl.segmentRules ?? 'Tous les utilisateurs',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.6),
                  ),
                ),
              ),

              // Recipient count
              DataCell(Text('${nl.recipientCount}')),

              // Created at
              DataCell(Text(_formatDate(nl.createdAt))),

              // Sent at
              DataCell(Text(nl.sentAt != null ? _formatDate(nl.sentAt!) : '—')),

              // Actions
              DataCell(_buildActionButtons(nl)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // ===========================================================================
  // ACTION BUTTONS
  // ===========================================================================

  Widget _buildActionButtons(NewsletterEntity nl) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit (draft only)
        if (nl.status == 'draft')
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: 'Éditer',
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: AppTheme.navy),
                onPressed: () =>
                    context.go('/admin/newsletters/${nl.id}/edit'),
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

        // Send (draft only)
        if (nl.status == 'draft')
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: 'Envoyer',
              child: IconButton(
                icon: const Icon(Icons.send, size: 18, color: Colors.green),
                onPressed: () => _confirmSend(nl),
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

        // Preview
        Tooltip(
          message: 'Aperçu',
          child: IconButton(
            icon: Icon(Icons.visibility,
                size: 18, color: AppTheme.navy.withValues(alpha: 0.5)),
            onPressed: () => _showPreview(nl),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, size: 64,
              color: AppTheme.navy.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text(
            'Aucune newsletter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre première newsletter pour commencer',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/admin/newsletters/new'),
            icon: const Icon(Icons.add),
            label: const Text('Créer une newsletter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
            ),
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
                ref.read(adminNewslettersProvider.notifier).loadNewsletters(),
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
  // ACTIONS
  // ===========================================================================

  Future<void> _confirmSend(NewsletterEntity nl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Envoyer la newsletter'),
        content: Text(
          'Êtes-vous sûr de vouloir envoyer "${nl.title}" ?\n\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Envoyer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(adminNewslettersProvider.notifier);
      final success = await notifier.sendNewsletter(nl.id, nl.recipientCount);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Newsletter envoyée ✓'
                : 'Erreur lors de l\'envoi'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  void _showPreview(NewsletterEntity nl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        nl.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meta info
                      Row(
                        children: [
                          _buildMetaChip('Statut', nl.status),
                          const SizedBox(width: 8),
                          if (nl.sentAt != null)
                            _buildMetaChip(
                                'Envoyée', _formatDate(nl.sentAt!)),
                        ],
                      ),
                      const Divider(height: 32),

                      // Content body
                      SelectableText(
                        nl.content,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppTheme.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'draft':
        color = Colors.grey;
        label = 'Brouillon';
        break;
      case 'sent':
        color = Colors.green;
        label = 'Envoyée';
        break;
      default:
        color = Colors.blue;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.navy.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.navy.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
