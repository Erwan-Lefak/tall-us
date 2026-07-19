import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/email_template_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';

/// Admin email template edit screen — edit subject, HTML body, text body
class AdminTemplateEditScreen extends ConsumerStatefulWidget {
  final String templateId;

  const AdminTemplateEditScreen({required this.templateId, super.key});

  @override
  ConsumerState<AdminTemplateEditScreen> createState() =>
      _AdminTemplateEditScreenState();
}

class _AdminTemplateEditScreenState
    extends ConsumerState<AdminTemplateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyHtmlController = TextEditingController();
  final _bodyTextController = TextEditingController();

  bool _isSaving = false;
  EmailTemplateEntity? _template;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminTemplatesProvider.notifier).loadTemplates();
    });
  }

  void _loadTemplate(List<EmailTemplateEntity> templates) {
    if (_template != null) return;
    try {
      _template = templates.firstWhere((t) => t.id == widget.templateId);
      _subjectController.text = _template!.subject;
      _bodyHtmlController.text = _template!.bodyHtml;
      _bodyTextController.text = _template!.bodyText ?? '';
      setState(() {});
    } catch (_) {
      // Not found
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyHtmlController.dispose();
    _bodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminTemplatesProvider);
    _loadTemplate(state.templates);

    if (state.isLoading && _template == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.bordeaux),
      );
    }

    if (_template == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Template non trouvé'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/admin/templates'),
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
            onPressed: () => context.go('/admin/templates'),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour aux templates'),
          ),

          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _template!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _template!.slug,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.navy.withValues(alpha: 0.4),
                            fontFamily: 'Courier',
                          ),
                        ),
                        if (_template!.isSystem) ...[
                          const SizedBox(width: 8),
                          Container(
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
                      ],
                    ),
                  ],
                ),
              ),

              // Toggle preview
              TextButton.icon(
                onPressed: () => setState(() => _showPreview = !_showPreview),
                icon: Icon(_showPreview ? Icons.edit : Icons.visibility),
                label: Text(_showPreview ? 'Éditer' : 'Aperçu'),
              ),
            ],
          ),

          // Variables info
          if (_template!.variables.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.navy.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppTheme.navy.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.code, size: 18, color: AppTheme.navy),
                  const SizedBox(width: 8),
                  const Text(
                    'Variables disponibles : ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.navy,
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _template!.variables.map((v) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.bordeaux.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '{{${v}}}',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Courier',
                              color:
                                  AppTheme.bordeaux.withValues(alpha: 0.8),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          if (_showPreview)
            _buildPreview()
          else
            _buildEditForm(),
        ],
      ),
    );
  }

  // ===========================================================================
  // EDIT FORM
  // ===========================================================================

  Widget _buildEditForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Sujet de l\'email *',
                hintText: 'Ex: Bienvenue sur {{appName}} !',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le sujet est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // HTML body
            TextFormField(
              controller: _bodyHtmlController,
              decoration: InputDecoration(
                labelText: 'Corps HTML *',
                hintText: '<h1>Bienvenue {{name}} !</h1>...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 16,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 13),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le corps HTML est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Text body (optional)
            TextFormField(
              controller: _bodyTextController,
              decoration: InputDecoration(
                labelText: 'Corps texte (optionnel)',
                hintText: 'Version texte brut pour les clients email basiques...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 10,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.go('/admin/templates'),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save, size: 18),
                  label: const Text('Sauvegarder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bordeaux,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // PREVIEW
  // ===========================================================================

  Widget _buildPreview() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject preview
          const Text(
            'Sujet',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              _replaceVariables(_subjectController.text),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 24),

          // HTML preview
          const Text(
            'Corps HTML',
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
              _replaceVariables(_bodyHtmlController.text),
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                fontFamily: 'Courier',
              ),
            ),
          ),

          if (_bodyTextController.text.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Corps texte',
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
                _replaceVariables(_bodyTextController.text),
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final notifier = ref.read(adminTemplatesProvider.notifier);

    final success = await notifier.updateTemplate(
      id: widget.templateId,
      subject: _subjectController.text.trim(),
      bodyHtml: _bodyHtmlController.text.trim(),
      bodyText: _bodyTextController.text.trim().isNotEmpty
          ? _bodyTextController.text.trim()
          : null,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Template mis à jour ✓'
              : 'Erreur lors de la sauvegarde'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        context.go('/admin/templates');
      }
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

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
