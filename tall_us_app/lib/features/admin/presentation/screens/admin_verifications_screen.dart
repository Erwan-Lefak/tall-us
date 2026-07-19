import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Admin verifications review screen — list, filter, approve/reject height verifications
class AdminVerificationsScreen extends ConsumerStatefulWidget {
  const AdminVerificationsScreen({super.key});

  @override
  ConsumerState<AdminVerificationsScreen> createState() =>
      _AdminVerificationsScreenState();
}

class _AdminVerificationsScreenState
    extends ConsumerState<AdminVerificationsScreen> {
  HeightVerificationStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminVerificationsProvider.notifier).loadVerifications(resetPage: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminVerificationsProvider);

    return Column(
      children: [
        // Summary cards
        _buildSummaryCards(),

        // Filters + actions bar
        _buildFiltersBar(state),

        // Data table
        Expanded(
          child: state.isLoading && state.verifications.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.bordeaux),
                )
              : state.error != null && state.verifications.isEmpty
                  ? _buildError(state.error!)
                  : _buildVerificationsTable(state),
        ),

        // Pagination
        if (state.verifications.isNotEmpty) _buildPagination(state),
      ],
    );
  }

  // ===========================================================================
  // SUMMARY CARDS
  // ===========================================================================

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          _buildSummaryCard(
            'En attente',
            Icons.schedule,
            Colors.orange,
            () => _setFilter(HeightVerificationStatus.submitted),
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            'En revue',
            Icons.visibility,
            Colors.blue,
            () => _setFilter(HeightVerificationStatus.underReview),
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            'Approuvées',
            Icons.check_circle,
            Colors.green,
            () => _setFilter(HeightVerificationStatus.verified),
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            'Rejetées',
            Icons.cancel,
            Colors.red,
            () => _setFilter(HeightVerificationStatus.rejected),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FILTERS BAR
  // ===========================================================================

  Widget _buildFiltersBar(AdminVerificationsState state) {
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
            width: 180,
            child: DropdownButtonFormField<HeightVerificationStatus?>(
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
                DropdownMenuItem<HeightVerificationStatus?>(
                  value: null,
                  child: Text('Tous les statuts'),
                ),
                DropdownMenuItem<HeightVerificationStatus?>(
                  value: HeightVerificationStatus.submitted,
                  child: Text('En attente'),
                ),
                DropdownMenuItem<HeightVerificationStatus?>(
                  value: HeightVerificationStatus.underReview,
                  child: Text('En revue'),
                ),
                DropdownMenuItem<HeightVerificationStatus?>(
                  value: HeightVerificationStatus.verified,
                  child: Text('Approuvée'),
                ),
                DropdownMenuItem<HeightVerificationStatus?>(
                  value: HeightVerificationStatus.rejected,
                  child: Text('Rejetée'),
                ),
              ],
              onChanged: (value) {
                _setFilter(value);
              },
            ),
          ),

          const SizedBox(width: 12),

          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.navy),
            onPressed: () {
              ref.read(adminVerificationsProvider.notifier).loadVerifications();
            },
            tooltip: 'Actualiser',
          ),

          const Spacer(),

          // Count
          Text(
            '${state.totalCount} vérification${state.totalCount != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _setFilter(HeightVerificationStatus? status) {
    setState(() => _statusFilter = status);
    ref.read(adminVerificationsProvider.notifier).setStatusFilter(status);
  }

  // ===========================================================================
  // VERIFICATIONS TABLE
  // ===========================================================================

  Widget _buildVerificationsTable(AdminVerificationsState state) {
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
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Utilisateur')),
            DataColumn(label: Text('Taille déclarée')),
            DataColumn(label: Text('Photo')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Soumis le')),
            DataColumn(label: Text('Traité le')),
            DataColumn(label: Text('Actions')),
          ],
          rows: state.verifications.map((v) {
            return DataRow(cells: [
              // ID (truncated)
              DataCell(
                Text(
                  v.id.length > 12 ? '${v.id.substring(0, 12)}...' : v.id,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                ),
              ),

              // User ID
              DataCell(
                Text(
                  v.userId.length > 12
                      ? '${v.userId.substring(0, 12)}...'
                      : v.userId,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                ),
              ),

              // Claimed height
              DataCell(
                Text(
                  v.displayHeight,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              // Photo
              DataCell(
                v.photoUrl != null
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => _showPhotoPreview(v.photoUrl!),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300),
                              image: DecorationImage(
                                image: NetworkImage(v.photoUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: v.photoUrl == null
                                ? const Icon(Icons.photo_camera, size: 18)
                                : null,
                          ),
                        ),
                      )
                    : const Icon(Icons.photo_camera_outlined,
                        size: 20, color: Colors.grey),
              ),

              // Status
              DataCell(_buildStatusChip(v.status)),

              // Submitted at
              DataCell(Text(v.submittedAt != null ? _formatDate(v.submittedAt!) : '—')),

              // Reviewed at
              DataCell(Text(v.reviewedAt != null ? _formatDate(v.reviewedAt!) : '—')),

              // Actions
              DataCell(_buildActionButtons(v)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // ===========================================================================
  // ACTION BUTTONS
  // ===========================================================================

  Widget _buildActionButtons(HeightVerificationEntity v) {
    final isPending = v.status == HeightVerificationStatus.submitted;
    final isUnderReview = v.status == HeightVerificationStatus.underReview;
    final canAct = isPending || isUnderReview;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mark under review
        if (isPending)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: 'Marquer en revue',
              child: IconButton(
                icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
                onPressed: () => _markUnderReview(v.id),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

        // Approve
        if (canAct)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: 'Approuver',
              child: IconButton(
                icon: const Icon(Icons.check_circle,
                    size: 18, color: Colors.green),
                onPressed: () => _approve(v),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),

        // Reject
        if (canAct)
          Tooltip(
            message: 'Rejeter',
            child: IconButton(
              icon: const Icon(Icons.cancel, size: 18, color: Colors.red),
              onPressed: () => _reject(v),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ),

        // View rejection reason (if rejected)
        if (v.status == HeightVerificationStatus.rejected &&
            v.rejectionReason != null)
          Tooltip(
            message: 'Raison: ${v.rejectionReason}',
            child: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
          ),
      ],
    );
  }

  // ===========================================================================
  // PAGINATION
  // ===========================================================================

  Widget _buildPagination(AdminVerificationsState state) {
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
                ? () =>
                    ref.read(adminVerificationsProvider.notifier).previousPage()
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
                ? () =>
                    ref.read(adminVerificationsProvider.notifier).nextPage()
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
            onPressed: () => ref
                .read(adminVerificationsProvider.notifier)
                .loadVerifications(),
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

  Future<void> _markUnderReview(String verificationId) async {
    final notifier = ref.read(adminVerificationsProvider.notifier);
    final success = await notifier.markUnderReview(verificationId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Marquée comme en revue'
              : 'Erreur lors de la mise à jour'),
          backgroundColor: success ? Colors.blue : Colors.red,
        ),
      );
      if (success) notifier.loadVerifications();
    }
  }

  Future<void> _approve(HeightVerificationEntity v) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approuver la vérification'),
        content: Text(
          'Approuver la taille déclarée de ${v.displayHeight} pour l\'utilisateur ${v.userId} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child:
                const Text('Approuver', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(adminVerificationsProvider.notifier);
      final success = await notifier.approve(v.id, v.userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Vérification approuvée ✓'
                : 'Erreur lors de l\'approbation'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) notifier.loadVerifications();
      }
    }
  }

  Future<void> _reject(HeightVerificationEntity v) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter la vérification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rejeter la vérification de ${v.displayHeight} ?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Raison du rejet',
                hintText: 'Expliquez pourquoi la vérification est rejetée...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Rejeter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.isNotEmpty) {
      final notifier = ref.read(adminVerificationsProvider.notifier);
      final success = await notifier.reject(v.id, v.userId, controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Vérification rejetée'
                : 'Erreur lors du rejet'),
            backgroundColor: success ? Colors.orange : Colors.red,
          ),
        );
        if (success) notifier.loadVerifications();
      }
    }
  }

  // ===========================================================================
  // PHOTO PREVIEW DIALOG
  // ===========================================================================

  void _showPhotoPreview(String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Photo de vérification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.navy,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Image
              Flexible(
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Impossible de charger l\'image'),
                      ],
                    ),
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

  Widget _buildStatusChip(HeightVerificationStatus status) {
    Color color;
    String label;
    switch (status) {
      case HeightVerificationStatus.submitted:
        color = Colors.orange;
        label = 'En attente';
        break;
      case HeightVerificationStatus.underReview:
        color = Colors.blue;
        label = 'En revue';
        break;
      case HeightVerificationStatus.verified:
        color = Colors.green;
        label = 'Approuvée';
        break;
      case HeightVerificationStatus.rejected:
        color = Colors.red;
        label = 'Rejetée';
        break;
      default:
        color = Colors.grey;
        label = 'Non vérifié';
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
