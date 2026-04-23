import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Advanced Discovery Filters - Enhanced search preferences
class AdvancedDiscoveryFilters extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const AdvancedDiscoveryFilters({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<AdvancedDiscoveryFilters> createState() =>
      _AdvancedDiscoveryFiltersState();
}

class _AdvancedDiscoveryFiltersState extends State<AdvancedDiscoveryFilters> {
  late RangeValues _ageRange;
  late RangeValues _heightRange;
  double _maxDistance = 50;
  bool _verifiedOnly = false;
  final List<String> _selectedInterests = [];
  final List<String> _selectedRelationshipTypes = [];
  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
    _ageRange = RangeValues(
      widget.currentFilters['minAge']?.toDouble() ?? 18,
      widget.currentFilters['maxAge']?.toDouble() ?? 100,
    );
    _heightRange = RangeValues(
      widget.currentFilters['minHeight']?.toDouble() ?? 150,
      widget.currentFilters['maxHeight']?.toDouble() ?? 220,
    );
    _maxDistance = widget.currentFilters['maxDistance']?.toDouble() ?? 50;
    _verifiedOnly = widget.currentFilters['verifiedOnly'] ?? false;
    _showInactive = widget.currentFilters['showInactive'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtres Avancés',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Réinitialiser',
                  style: TextStyle(
                    color: AppTheme.bordeaux,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Age filter
          _buildAgeFilter().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 20),

          // Height filter
          _buildHeightFilter().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 20),

          // Distance filter
          _buildDistanceFilter().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 20),

          // Verification filter
          _buildVerificationFilter().animate().fadeIn(duration: 300.ms).then(),
          const SizedBox(height: 20),

          // Relationship type filter
          _buildRelationshipTypeFilter()
              .animate()
              .fadeIn(duration: 300.ms)
              .then(),
          const SizedBox(height: 20),

          // Interests filter
          _buildInterestsFilter().animate().fadeIn(duration: 300.ms).then(),

          const SizedBox(height: 30),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Appliquer les Filtres',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildAgeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cake,
                  color: AppTheme.bordeaux,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Âge',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
            Text(
              '${_ageRange.start.toInt()} - ${_ageRange.end.toInt()} ans',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: _ageRange,
          min: 18,
          max: 100,
          activeColor: AppTheme.bordeaux,
          labels: RangeLabels(
            '${_ageRange.start.toInt()}',
            '${_ageRange.end.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _ageRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHeightFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.height,
                  color: AppTheme.bordeaux,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Taille',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
            Text(
              '${_heightRange.start.toInt()} - ${_heightRange.end.toInt()} cm',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: _heightRange,
          min: 140,
          max: 220,
          activeColor: AppTheme.bordeaux,
          divisions: 80,
          labels: RangeLabels(
            '${_heightRange.start.toInt()}',
            '${_heightRange.end.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _heightRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppTheme.bordeaux,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Distance Maximale',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
            Text(
              '${_maxDistance.toInt()} km',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: _maxDistance,
          min: 1,
          max: 150,
          divisions: 149,
          activeColor: AppTheme.bordeaux,
          label: '${_maxDistance.toInt()} km',
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVerificationFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: AppTheme.bordeaux,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profils Vérifiés Seulement',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                Text(
                  'Afficher uniquement les profils avec identité ou taille vérifiée',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _verifiedOnly,
            onChanged: (value) {
              setState(() {
                _verifiedOnly = value;
              });
            },
            activeColor: AppTheme.bordeaux,
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipTypeFilter() {
    final types = [
      ('Amoureuse', Icons.favorite),
      ('Amicale', Icons.people),
      ('Sans sérieux', Icons.casino),
      ('Épique', Icons.bolt),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type de Relation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) {
            final isSelected = _selectedRelationshipTypes.contains(type.$1);
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.$2,
                      size: 16,
                      color: isSelected ? Colors.white : AppTheme.bordeaux),
                  const SizedBox(width: 4),
                  Text(type.$1),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedRelationshipTypes.add(type.$1);
                  } else {
                    _selectedRelationshipTypes.remove(type.$1);
                  }
                });
              },
              selectedColor: AppTheme.bordeaux,
              backgroundColor: AppTheme.gray100,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.navy,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestsFilter() {
    final interests = [
      'Voyage',
      'Sport',
      'Musique',
      'Cuisine',
      'Art',
      'Cinéma',
      'Mode',
      'Technologie',
      'Nature',
      'Photographie',
      'Danse',
      'Lecture',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Centres d\'Intérêt',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Text(
              '${_selectedInterests.length} sélectionnés',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.gray600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    if (_selectedInterests.length < 5) {
                      _selectedInterests.add(interest);
                    }
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
              },
              selectedColor: AppTheme.bordeaux.withValues(alpha: 0.2),
              backgroundColor: AppTheme.gray100,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.bordeaux : AppTheme.navy,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
                ),
              ),
              checkmarkColor: AppTheme.bordeaux,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _applyFilters() {
    widget.onFiltersChanged({
      'minAge': _ageRange.start.toInt(),
      'maxAge': _ageRange.end.toInt(),
      'minHeight': _heightRange.start.toInt(),
      'maxHeight': _heightRange.end.toInt(),
      'maxDistance': _maxDistance.toInt(),
      'verifiedOnly': _verifiedOnly,
      'interests': _selectedInterests,
      'relationshipTypes': _selectedRelationshipTypes,
      'showInactive': _showInactive,
    });

    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _ageRange = const RangeValues(18, 100);
      _heightRange = const RangeValues(150, 220);
      _maxDistance = 50;
      _verifiedOnly = false;
      _selectedInterests.clear();
      _selectedRelationshipTypes.clear();
      _showInactive = false;
    });
  }
}
