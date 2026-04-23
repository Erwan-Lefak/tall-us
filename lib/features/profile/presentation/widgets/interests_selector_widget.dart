import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/constants/interests_constants.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Widget to select interests (Tinder-style tag selector)
class InterestsSelectorWidget extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsUpdated;
  final int maxInterests;

  const InterestsSelectorWidget({
    super.key,
    this.selectedInterests = const [],
    required this.onInterestsUpdated,
    this.maxInterests = 5,
  });

  @override
  State<InterestsSelectorWidget> createState() =>
      _InterestsSelectorWidgetState();
}

class _InterestsSelectorWidgetState extends State<InterestsSelectorWidget> {
  late List<String> _selectedInterests;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tout';

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.selectedInterests);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else if (_selectedInterests.length < widget.maxInterests) {
        _selectedInterests.add(interest);
      }
    });
    widget.onInterestsUpdated(_selectedInterests);
  }

  List<String> get _filteredInterests {
    var interests = _selectedCategory == 'Tout'
        ? TallInterests.popularInterests
        : TallInterests.interestsByCategory[_selectedCategory] ?? [];

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      interests = interests
          .where((i) => i.toLowerCase().contains(searchLower))
          .toList();
    }

    return interests;
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
              'Mes Intérêts',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Text(
              '${_selectedInterests.length}/${widget.maxInterests}',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.navy.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Selected interests chips
        if (_selectedInterests.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedInterests.map((interest) {
              return _InterestChip(
                interest: interest,
                isSelected: true,
                onTap: () => _toggleInterest(interest),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Search field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher un intérêt...',
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

        // Category filter
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: TallInterests.interestsByCategory.keys.length + 1,
            itemBuilder: (context, index) {
              final categories = [
                'Tout',
                ...TallInterests.interestsByCategory.keys
              ];
              final category = categories[index];
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
                  selectedColor: AppTheme.bordeaux.withValues(alpha: 0.3),
                  checkmarkColor: AppTheme.bordeaux,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.bordeaux : AppTheme.navy,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Interests grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemCount: _filteredInterests.length,
          itemBuilder: (context, index) {
            final interest = _filteredInterests[index];
            final isSelected = _selectedInterests.contains(interest);
            return _InterestChip(
              interest: interest,
              isSelected: isSelected,
              onTap: () => _toggleInterest(interest),
            );
          },
        ),
      ],
    );
  }
}

/// Individual interest chip
class _InterestChip extends StatelessWidget {
  final String interest;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.bordeaux : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.bordeaux.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              interest,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.navy,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0).scale(
            duration: 200.ms,
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
          ),
    );
  }
}

/// Dialog to select interests
class InterestsSelectionDialog extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsSelected;
  final int maxInterests;

  const InterestsSelectionDialog({
    super.key,
    this.selectedInterests = const [],
    required this.onInterestsSelected,
    this.maxInterests = 5,
  });

  @override
  State<InterestsSelectionDialog> createState() =>
      _InterestsSelectionDialogState();
}

class _InterestsSelectionDialogState extends State<InterestsSelectionDialog> {
  late List<String> _selectedInterests;

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.selectedInterests);
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else if (_selectedInterests.length < widget.maxInterests) {
        _selectedInterests.add(interest);
      }
    });
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
                    'Sélectionnez vos intérêts',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choisissez jusqu\'à ${widget.maxInterests} intérêts',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress indicator
                  LinearProgressIndicator(
                    value: _selectedInterests.length / widget.maxInterests,
                    backgroundColor: AppTheme.gray200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedInterests.length}/${widget.maxInterests}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.bordeaux,
                    ),
                  ),
                ],
              ),
            ),

            // Interests list
            Expanded(
              child: InterestsSelectorWidget(
                selectedInterests: _selectedInterests,
                onInterestsUpdated: (interests) {
                  setState(() {
                    _selectedInterests = interests;
                  });
                },
                maxInterests: widget.maxInterests,
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.gray200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: AppTheme.navy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedInterests.isNotEmpty
                          ? () {
                              widget.onInterestsSelected(_selectedInterests);
                              Navigator.of(context).pop();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.bordeaux,
                        disabledBackgroundColor: AppTheme.gray400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Confirmer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
