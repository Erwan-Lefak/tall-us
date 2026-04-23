import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';

/// Screen to select and answer prompts (Tinder-style)
class PromptSelectorWidget extends StatefulWidget {
  final List<UserPrompt> existingPrompts;
  final Function(List<UserPrompt>) onPromptsUpdated;
  final int maxPrompts;

  const PromptSelectorWidget({
    super.key,
    this.existingPrompts = const [],
    required this.onPromptsUpdated,
    this.maxPrompts = 3,
  });

  @override
  State<PromptSelectorWidget> createState() => _PromptSelectorWidgetState();
}

class _PromptSelectorWidgetState extends State<PromptSelectorWidget> {
  late List<UserPrompt> _userPrompts;
  final TextEditingController _answerController = TextEditingController();
  PromptEntity? _selectedPrompt;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _userPrompts = List.from(widget.existingPrompts);
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _showPromptSelector() {
    showDialog(
      context: context,
      builder: (context) => _PromptSelectionDialog(
        onPromptSelected: (prompt) {
          setState(() {
            _selectedPrompt = prompt;
            _isAdding = true;
            _answerController.clear();
          });
          Navigator.of(context).pop();
        },
        existingPromptIds: _userPrompts.map((p) => p.promptId).toList(),
      ),
    );
  }

  void _addPrompt() {
    if (_selectedPrompt != null && _answerController.text.trim().isNotEmpty) {
      setState(() {
        _userPrompts.add(UserPrompt(
          promptId: _selectedPrompt!.id,
          promptText: _selectedPrompt!.text,
          answer: _answerController.text.trim(),
          displayOrder: _userPrompts.length,
        ));
        _isAdding = false;
        _selectedPrompt = null;
        _answerController.clear();
      });
      widget.onPromptsUpdated(_userPrompts);
    }
  }

  void _removePrompt(int index) {
    setState(() {
      _userPrompts.removeAt(index);
      // Reorder
      for (int i = 0; i < _userPrompts.length; i++) {
        _userPrompts[i] = _userPrompts[i].copyWith(displayOrder: i);
      }
    });
    widget.onPromptsUpdated(_userPrompts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mes Prompts',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Text(
              '${_userPrompts.length}/${widget.maxPrompts}',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.navy.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Existing prompts
        ...List.generate(_userPrompts.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PromptCard(
              prompt: _userPrompts[index],
              onRemove: () => _removePrompt(index),
            ),
          );
        }),

        // Add prompt form
        if (_isAdding) ...[
          _AddPromptForm(
            selectedPrompt: _selectedPrompt,
            answerController: _answerController,
            onSubmit: _addPrompt,
            onCancel: () {
              setState(() {
                _isAdding = false;
                _selectedPrompt = null;
                _answerController.clear();
              });
            },
          ),
        ],

        // Add button
        if (_userPrompts.length < widget.maxPrompts && !_isAdding)
          GestureDetector(
            onTap: _showPromptSelector,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.bordeaux.withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 32,
                    color: AppTheme.bordeaux,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajouter un prompt',
                    style: TextStyle(
                      color: AppTheme.bordeaux,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).scale(),
      ],
    );
  }
}

/// Widget displaying a single prompt card
class _PromptCard extends StatelessWidget {
  final UserPrompt prompt;
  final VoidCallback onRemove;

  const _PromptCard({
    required this.prompt,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bordeaux.withValues(alpha: 0.05),
            AppTheme.navy.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.bordeaux.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt question
          Text(
            prompt.promptText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),

          const SizedBox(height: 8),

          // Answer
          Text(
            prompt.answer,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Remove button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.bordeaux.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: AppTheme.bordeaux,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Supprimer',
                      style: TextStyle(
                        color: AppTheme.bordeaux,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }
}

/// Form to add a new prompt
class _AddPromptForm extends StatefulWidget {
  final PromptEntity? selectedPrompt;
  final TextEditingController answerController;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const _AddPromptForm({
    required this.selectedPrompt,
    required this.answerController,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<_AddPromptForm> createState() => _AddPromptFormState();
}

class _AddPromptFormState extends State<_AddPromptForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.bordeaux,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bordeaux.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Text(
            widget.selectedPrompt?.text ?? 'Sélectionnez une question',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),

          const SizedBox(height: 16),

          // Answer field
          TextField(
            controller: widget.answerController,
            maxLines: 3,
            maxLength: 140,
            decoration: InputDecoration(
              hintText: 'Votre réponse...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.bordeaux, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.navy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: AppTheme.navy),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.answerController.text.trim().isNotEmpty
                      ? widget.onSubmit
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bordeaux,
                    disabledBackgroundColor: AppTheme.gray400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Ajouter',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale();
  }
}

/// Dialog to select a prompt
class _PromptSelectionDialog extends StatefulWidget {
  final Function(PromptEntity) onPromptSelected;
  final List<String> existingPromptIds;

  const _PromptSelectionDialog({
    required this.onPromptSelected,
    required this.existingPromptIds,
  });

  @override
  State<_PromptSelectionDialog> createState() => _PromptSelectionDialogState();
}

class _PromptSelectionDialogState extends State<_PromptSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tout';
  final List<String> _categories = [
    'Tout',
    'Conversation',
    'Dating',
    'Personnalité',
    'Divertissement',
    'Voyage',
    'Nourriture',
    'Travail',
    'Aléatoire',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PromptEntity> get _filteredPrompts {
    var prompts = TallPrompts.allPrompts;

    // Filter by category
    if (_selectedCategory != 'Tout') {
      prompts = prompts
          .where((p) =>
              p.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter out existing prompts
    prompts =
        prompts.where((p) => !widget.existingPromptIds.contains(p.id)).toList();

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      prompts = prompts
          .where((p) => p.text.toLowerCase().contains(searchLower))
          .toList();
    }

    // Sort by popularity
    prompts = List.from(prompts);
    prompts.sort((a, b) => b.popularity.compareTo(a.popularity));

    return prompts.take(50).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.gray200, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Choisissez un prompt',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un prompt...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor:
                                AppTheme.bordeaux.withValues(alpha: 0.3),
                            checkmarkColor: AppTheme.bordeaux,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.bordeaux
                                  : AppTheme.navy,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.bordeaux
                                  : AppTheme.gray300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Prompts list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _filteredPrompts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PromptListItem(
                      prompt: prompt,
                      onTap: () {
                        widget.onPromptSelected(prompt);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// List item for a prompt
class _PromptListItem extends StatelessWidget {
  final PromptEntity prompt;
  final VoidCallback onTap;

  const _PromptListItem({
    required this.prompt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.gray300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompt.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: AppTheme.bordeaux,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Popularité: ${prompt.popularity}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.navy.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.bordeaux,
            ),
          ],
        ),
      ),
    );
  }
}
