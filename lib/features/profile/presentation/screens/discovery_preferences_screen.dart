import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';

/// Screen for editing discovery preferences
class DiscoveryPreferencesScreen extends ConsumerStatefulWidget {
  const DiscoveryPreferencesScreen({super.key});

  @override
  ConsumerState<DiscoveryPreferencesScreen> createState() =>
      _DiscoveryPreferencesScreenState();
}

class _DiscoveryPreferencesScreenState
    extends ConsumerState<DiscoveryPreferencesScreen> {
  late DiscoveryPreferencesEntity _preferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with defaults - will be replaced with actual data from provider
    _preferences = const DiscoveryPreferencesEntity(
      userId: '',
      minAge: 18,
      maxAge: 35,
      minHeightCm: 165,
      maxHeightCm: 210,
      preferredGenders: ['femme'],
      maxDistanceKm: 50,
      city: 'Paris',
      country: 'France',
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final profileState = ref.read(profileProvider);
    final userProfile = profileState.profile;
    final preferences = profileState.preferences;

    if (preferences != null) {
      setState(() {
        _preferences = preferences;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Préférences de découverte',
          style: TextStyle(
            color: AppTheme.navy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.bordeaux,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _savePreferences,
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(
                      color: AppTheme.bordeaux,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.05),
              AppTheme.navy.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Age range
            _buildAgeRangeSection(),

            const SizedBox(height: 24),

            // Height range
            _buildHeightRangeSection(),

            const SizedBox(height: 24),

            // Distance
            _buildDistanceSection(),

            const SizedBox(height: 24),

            // Gender preference
            _buildGenderSection(),

            const SizedBox(height: 24),

            // Location
            _buildLocationSection(),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeRangeSection() {
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
          Row(
            children: [
              const Icon(Icons.cake, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Âge',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minimum: ${_preferences.minAge} ans',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    'Maximum: ${_preferences.maxAge} ans',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(
                  _preferences.minAge.toDouble(),
                  _preferences.maxAge.toDouble(),
                ),
                min: 18,
                max: 100,
                activeColor: AppTheme.bordeaux,
                labels: RangeLabels(
                  '${_preferences.minAge} ans',
                  '${_preferences.maxAge} ans',
                ),
                onChanged: (values) {
                  setState(() {
                    _preferences = _preferences.copyWith(
                      minAge: values.start.round(),
                      maxAge: values.end.round(),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeightRangeSection() {
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
          Row(
            children: [
              const Icon(Icons.height, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Taille',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minimum: ${_preferences.minHeightCm} cm',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    'Maximum: ${_preferences.maxHeightCm} cm',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(
                  _preferences.minHeightCm.toDouble(),
                  _preferences.maxHeightCm.toDouble(),
                ),
                min: 140,
                max: 220,
                activeColor: AppTheme.bordeaux,
                divisions: 80,
                labels: RangeLabels(
                  '${_preferences.minHeightCm} cm',
                  '${_preferences.maxHeightCm} cm',
                ),
                onChanged: (values) {
                  setState(() {
                    _preferences = _preferences.copyWith(
                      minHeightCm: values.start.round(),
                      maxHeightCm: values.end.round(),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSection() {
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
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Distance maximum',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_preferences.maxDistanceKm} km',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.bordeaux,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _preferences.maxDistanceKm.toDouble(),
                min: 5,
                max: 200,
                divisions: 39,
                activeColor: AppTheme.bordeaux,
                label: '${_preferences.maxDistanceKm} km',
                onChanged: (value) {
                  setState(() {
                    _preferences = _preferences.copyWith(
                      maxDistanceKm: value.round(),
                    );
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5 km',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.navy.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    '200 km',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.navy.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection() {
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
          Row(
            children: [
              const Icon(Icons.wc, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Je cherche',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              FilterChip(
                label: const Text('Femmes'),
                selected: _preferences.preferredGenders.contains('femme'),
                onSelected: (selected) {
                  setState(() {
                    final genders =
                        List<String>.from(_preferences.preferredGenders);
                    if (selected) {
                      genders.add('femme');
                    } else {
                      genders.remove('femme');
                    }
                    _preferences =
                        _preferences.copyWith(preferredGenders: genders);
                  });
                },
                selectedColor: AppTheme.bordeaux.withValues(alpha: 0.3),
                checkmarkColor: AppTheme.bordeaux,
                labelStyle: TextStyle(
                  color: _preferences.preferredGenders.contains('femme')
                      ? AppTheme.bordeaux
                      : AppTheme.navy.withValues(alpha: 0.7),
                  fontWeight: _preferences.preferredGenders.contains('femme')
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              FilterChip(
                label: const Text('Hommes'),
                selected: _preferences.preferredGenders.contains('homme'),
                onSelected: (selected) {
                  setState(() {
                    final genders =
                        List<String>.from(_preferences.preferredGenders);
                    if (selected) {
                      genders.add('homme');
                    } else {
                      genders.remove('homme');
                    }
                    _preferences =
                        _preferences.copyWith(preferredGenders: genders);
                  });
                },
                selectedColor: AppTheme.bordeaux.withValues(alpha: 0.3),
                checkmarkColor: AppTheme.bordeaux,
                labelStyle: TextStyle(
                  color: _preferences.preferredGenders.contains('homme')
                      ? AppTheme.bordeaux
                      : AppTheme.navy.withValues(alpha: 0.7),
                  fontWeight: _preferences.preferredGenders.contains('homme')
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              FilterChip(
                label: const Text('Non-binaire'),
                selected: _preferences.preferredGenders.contains('non-binaire'),
                onSelected: (selected) {
                  setState(() {
                    final genders =
                        List<String>.from(_preferences.preferredGenders);
                    if (selected) {
                      genders.add('non-binaire');
                    } else {
                      genders.remove('non-binaire');
                    }
                    _preferences =
                        _preferences.copyWith(preferredGenders: genders);
                  });
                },
                selectedColor: AppTheme.bordeaux.withValues(alpha: 0.3),
                checkmarkColor: AppTheme.bordeaux,
                labelStyle: TextStyle(
                  color: _preferences.preferredGenders.contains('non-binaire')
                      ? AppTheme.bordeaux
                      : AppTheme.navy.withValues(alpha: 0.7),
                  fontWeight:
                      _preferences.preferredGenders.contains('non-binaire')
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
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
          Row(
            children: [
              const Icon(Icons.place, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Ma position',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: '${_preferences.city}, ${_preferences.country}',
            decoration: const InputDecoration(
              labelText: 'Ville',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(),
              hintText: 'Entrez votre ville',
            ),
            onChanged: (value) {
              // TODO: Parse city and country
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.navy.withValues(alpha: 0.5),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Les profils seront affichés en fonction de votre position',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);

    try {
      // Save preferences through the repository
      final profileNotifier = ref.read(profileProvider.notifier);

      await profileNotifier.updateDiscoveryPreferences(_preferences);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Préférences enregistrées avec succès !'),
            backgroundColor: AppTheme.bordeaux,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'enregistrement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
