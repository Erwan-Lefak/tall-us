import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/domain/entities/newsletter_entity.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';

/// Admin newsletter create/edit screen
class AdminNewsletterEditScreen extends ConsumerStatefulWidget {
  final String? newsletterId;

  const AdminNewsletterEditScreen({this.newsletterId, super.key});

  @override
  ConsumerState<AdminNewsletterEditScreen> createState() =>
      _AdminNewsletterEditScreenState();
}

class _AdminNewsletterEditScreenState
    extends ConsumerState<AdminNewsletterEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _segmentController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;
  NewsletterEntity? _existingNewsletter;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.newsletterId != null;
    if (_isEditing) {
      _loadNewsletter();
    }
  }

  void _loadNewsletter() {
    final state = ref.read(adminNewslettersProvider);
    try {
      _existingNewsletter = state.newsletters.firstWhere(
        (nl) => nl.id == widget.newsletterId,
      );
      _titleController.text = _existingNewsletter!.title;
      _contentController.text = _existingNewsletter!.content;
      _segmentController.text = _existingNewsletter!.segmentRules ?? '';
    } catch (_) {
      // Newsletter not found in current list
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _segmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            onPressed: () => context.go('/admin/newsletters'),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour aux newsletters'),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            _isEditing ? 'Éditer la newsletter' : 'Nouvelle newsletter',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),

          const SizedBox(height: 24),

          // Form
          Container(
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
                  // Title field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titre *',
                      hintText: 'Ex: Mise à jour mensuelle - Juin 2026',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le titre est requis';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Content field
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Contenu *',
                      hintText: 'Rédigez le contenu de votre newsletter...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 12,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le contenu est requis';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Segment rules
                  TextFormField(
                    controller: _segmentController,
                    decoration: InputDecoration(
                      labelText: 'Règles de segment (optionnel)',
                      hintText:
                          'Ex: {"gender": "male", "role": "premium"}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      helperText:
                          'Laissez vide pour envoyer à tous les utilisateurs vérifiés',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info text
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isEditing
                                ? 'Les modifications seront sauvegardées comme brouillon.'
                                : 'La newsletter sera créée comme brouillon. Vous pourrez l\'envoyer depuis la liste.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.navy.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/admin/newsletters'),
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
                        label: Text(_isEditing ? 'Sauvegarder' : 'Créer'),
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
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final notifier = ref.read(adminNewslettersProvider.notifier);
    bool success;

    if (_isEditing && _existingNewsletter != null) {
      success = await notifier.updateNewsletter(
        id: _existingNewsletter!.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        segmentRules: _segmentController.text.trim().isNotEmpty
            ? _segmentController.text.trim()
            : null,
      );
    } else {
      final user = ref.read(authenticatedUserProvider);
      final createdBy = user?.id ?? 'admin';

      success = await notifier.createNewsletter(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        segmentRules: _segmentController.text.trim().isNotEmpty
            ? _segmentController.text.trim()
            : null,
        createdBy: createdBy,
      );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? _isEditing
                  ? 'Newsletter mise à jour ✓'
                  : 'Newsletter créée ✓'
              : 'Erreur lors de la sauvegarde'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        context.go('/admin/newsletters');
      }
    }
  }
}
