import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/email_template_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';

/// Admin email templates screen — list all templates with edit/preview
class AdminTemplatesScreen extends ConsumerStatefulWidget {
  const AdminTemplatesScreen({super.key});

  @override
  ConsumerState<AdminTemplatesScreen> createState() =>
      _AdminTemplatesScreenState();
}

class _AdminTemplatesScreenState extends ConsumerState<AdminTemplatesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminTemplatesProvider.notifier).loadTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminTemplatesProvider);

    return Column(
      children: [
        // Header bar
        _buildHeader(state),

        // Templates list
        Expanded(
          child: state.isLoading && state.templates.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.bordeaux),
                )
              : state.error != null && state.templates.isEmpty
                  ? _buildError(state.error!)
                  : state.templates.isEmpty
                      ? _buildEmptyState()
                      : _buildTemplatesGrid(state),
        ),
      ],
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(AdminTemplatesState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.navy),
            onPressed: () =>
                ref.read(adminTemplatesProvider.notifier).loadTemplates(),
            tooltip: 'Actualiser',
          ),
          const Spacer(),
          Text(
            '${state.templates.length} template${state.templates.length != 1 ? 's' : ''}',
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
  // TEMPLATES GRID
  // ===========================================================================

  Widget _buildTemplatesGrid(AdminTemplatesState state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.templates.length,
      itemBuilder: (context, index) {
        final template = state.templates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(EmailTemplateEntity template) {
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go('/admin/templates/${template.id}'),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: name + badges
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        template.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (template.isSystem)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'SYSTÈME',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // Slug
                Text(
                  template.slug,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.4),
                    fontFamily: 'Courier',
                  ),
                ),

                const SizedBox(height: 12),

                // Subject
                Row(
                  children: [
                    Icon(Icons.subject,
                        size: 16,
                        color: AppTheme.navy.withValues(alpha: 0.4)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        template.subject,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.navy.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Variables chips
                if (template.variables.isNotEmpty) ...[
                  Text(
                    'Variables:',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.navy.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: template.variables.map((v) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.bordeaux.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppTheme.bordeaux.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          '{{${v}}}',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Courier',
                            color: AppTheme.bordeaux.withValues(alpha: 0.8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 8),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Preview
                    IconButton(
                      icon: Icon(Icons.visibility,
                          size: 18,
                          color: AppTheme.navy.withValues(alpha: 0.5)),
                      onPressed: () => _showPreview(template),
                      tooltip: 'Aperçu',
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 4),
                    // Edit
                    IconButton(
                      icon: const Icon(Icons.edit,
                          size: 18, color: AppTheme.bordeaux),
                      onPressed: () =>
                          context.go('/admin/templates/${template.id}'),
                      tooltip: 'Éditer',
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
          Icon(Icons.email_outlined, size: 64,
              color: AppTheme.navy.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          const Text(
            'Aucun template email',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les templates sont créés côté serveur.\nUtilisez l\'API Appwrite pour en ajouter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.5),
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
                ref.read(adminTemplatesProvider.notifier).loadTemplates(),
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
  // PREVIEW
  // ===========================================================================

  void _showPreview(EmailTemplateEntity template) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.navy,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            template.slug,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Subject
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Sujet: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.navy,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _replaceVariables(template.subject),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              // Body content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HTML body
                      if (template.bodyHtml.isNotEmpty) ...[
                        const Text(
                          'Version HTML',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppTheme.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: SelectableText(
                            _replaceVariables(template.bodyHtml),
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ],

                      // Text body
                      if (template.bodyText != null &&
                          template.bodyText!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Version texte',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppTheme.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: SelectableText(
                            _replaceVariables(template.bodyText!),
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
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

  /// Replace template variables with sample data for preview
  String _replaceVariables(String content) {
    return content
        .replaceAll('{{name}}', 'Jean Dupont')
        .replaceAll('{{email}}', 'jean@example.com')
        .replaceAll('{{displayName}}', 'Jean')
        .replaceAll('{{userId}}', 'usr_123456')
        .replaceAll('{{link}}', 'https://tall-us.com/verify?token=abc123')
        .replaceAll('{{date}}', DateTime.now().toString().substring(0, 10))
        .replaceAll('{{appName}}', 'Tall Us')
        .replaceAll('{{height}}', "6'1\" (185 cm)");
  }
}
