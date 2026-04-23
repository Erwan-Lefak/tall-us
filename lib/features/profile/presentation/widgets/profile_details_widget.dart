import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Job and Education Widget
class JobEducationWidget extends StatefulWidget {
  final String? jobTitle;
  final String? company;
  final String? school;
  final String? degree;
  final Function(String?, String?, String?, String?) onUpdate;

  const JobEducationWidget({
    super.key,
    this.jobTitle,
    this.company,
    this.school,
    this.degree,
    required this.onUpdate,
  });

  @override
  State<JobEducationWidget> createState() => _JobEducationWidgetState();
}

class _JobEducationWidgetState extends State<JobEducationWidget> {
  late TextEditingController _jobController;
  late TextEditingController _companyController;
  late TextEditingController _schoolController;
  late TextEditingController _degreeController;

  @override
  void initState() {
    super.initState();
    _jobController = TextEditingController(text: widget.jobTitle ?? '');
    _companyController = TextEditingController(text: widget.company ?? '');
    _schoolController = TextEditingController(text: widget.school ?? '');
    _degreeController = TextEditingController(text: widget.degree ?? '');
  }

  @override
  void dispose() {
    _jobController.dispose();
    _companyController.dispose();
    _schoolController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Information Professionnelle',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),

          Text(
            'Partagez votre parcours pour plus de crédibilité',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          // Job section
          _buildSection(
            icon: Icons.work,
            title: 'Travail',
            fields: [
              _buildTextField(
                controller: _jobController,
                label: 'Poste',
                hint: 'Ex: Ingénieur logiciel',
                icon: Icons.badge,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _companyController,
                label: 'Entreprise',
                hint: 'Ex: Google',
                icon: Icons.business,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Education section
          _buildSection(
            icon: Icons.school,
            title: 'Éducation',
            fields: [
              _buildTextField(
                controller: _schoolController,
                label: 'École/Université',
                hint: 'Ex: École Polytechnique',
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _degreeController,
                label: 'Diplôme',
                hint: 'Ex: Master en Informatique',
                icon: Icons.stars,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onUpdate(
                  _jobController.text.trim().isEmpty
                      ? null
                      : _jobController.text.trim(),
                  _companyController.text.trim().isEmpty
                      ? null
                      : _companyController.text.trim(),
                  _schoolController.text.trim().isEmpty
                      ? null
                      : _schoolController.text.trim(),
                  _degreeController.text.trim().isEmpty
                      ? null
                      : _degreeController.text.trim(),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> fields,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppTheme.bordeaux,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...fields,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.bordeaux),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppTheme.bordeaux,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// Lifestyle Preferences Widget
class LifestyleWidget extends StatefulWidget {
  final String? drinkingPreference;
  final String? smokingPreference;
  final String? workoutFrequency;
  final Function(String?, String?, String?) onUpdate;

  const LifestyleWidget({
    super.key,
    this.drinkingPreference,
    this.smokingPreference,
    this.workoutFrequency,
    required this.onUpdate,
  });

  @override
  State<LifestyleWidget> createState() => _LifestyleWidgetState();
}

class _LifestyleWidgetState extends State<LifestyleWidget> {
  String? _drinking;
  String? _smoking;
  String? _workout;

  final List<String> drinkingOptions = [
    'Souvent',
    'Sociallement',
    'Rarement',
    'Jamais',
    'Je ne bois pas',
  ];

  final List<String> smokingOptions = [
    'Fumeur',
    'Parfois',
    'En essayant d\'arrêter',
    'Quand je sors',
    'Non-fumeur',
  ];

  final List<String> workoutOptions = [
    'Tous les jours',
    '3-5 fois/semaine',
    '1-2 fois/semaine',
    'Rarement',
    'Jamais',
  ];

  @override
  void initState() {
    super.initState();
    _drinking = widget.drinkingPreference;
    _smoking = widget.smokingPreference;
    _workout = widget.workoutFrequency;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Style de Vie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),

          Text(
            'Vos préférences pour des matchs compatibles',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          // Drinking
          _buildLifestyleSelector(
            icon: Icons.local_bar,
            label: 'Consommation d\'alcool',
            options: drinkingOptions,
            selected: _drinking,
            onSelect: (value) => setState(() => _drinking = value),
          ),

          const SizedBox(height: 20),

          // Smoking
          _buildLifestyleSelector(
            icon: Icons.smoking_rooms,
            label: 'Tabac',
            options: smokingOptions,
            selected: _smoking,
            onSelect: (value) => setState(() => _smoking = value),
          ),

          const SizedBox(height: 20),

          // Workout
          _buildLifestyleSelector(
            icon: Icons.fitness_center,
            label: 'Sport',
            options: workoutOptions,
            selected: _workout,
            onSelect: (value) => setState(() => _workout = value),
          ),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onUpdate(_drinking, _smoking, _workout);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildLifestyleSelector({
    required IconData icon,
    required String label,
    required List<String> options,
    required String? selected,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.bordeaux, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelect(option),
              selectedColor: AppTheme.bordeaux.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.bordeaux,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.bordeaux : AppTheme.navy,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppTheme.gray100,
              side: BorderSide(
                color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Zodiac and Pronouns Widget
class ZodiacPronounsWidget extends StatefulWidget {
  final String? zodiacSign;
  final String? pronouns;
  final List<String> selectedGenders;
  final Function(String?, String?, List<String>) onUpdate;

  const ZodiacPronounsWidget({
    super.key,
    this.zodiacSign,
    this.pronouns,
    this.selectedGenders = const [],
    required this.onUpdate,
  });

  @override
  State<ZodiacPronounsWidget> createState() => _ZodiacPronounsWidgetState();
}

class _ZodiacPronounsWidgetState extends State<ZodiacPronounsWidget> {
  String? _zodiac;
  String? _pronouns;
  late List<String> _genders;

  final List<String> zodiacSigns = [
    'Bélier',
    'Taureau',
    'Gémeaux',
    'Cancer',
    'Lion',
    'Vierge',
    'Balance',
    'Scorpion',
    'Sagittaire',
    'Capricorne',
    'Verseau',
    'Poissons',
  ];

  final List<String> pronounOptions = [
    'il/lui',
    'elle/elle',
    'iel/iel',
    'eux/eux',
    'Autre',
  ];

  final List<String> genderOptions = [
    'Homme',
    'Femme',
    'Non-binaire',
    'Genre fluide',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _zodiac = widget.zodiacSign;
    _pronouns = widget.pronouns;
    _genders = List.from(widget.selectedGenders);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Identité',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),

          Text(
            'Exprimez-vous comme vous le souhaitez',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          // Gender selection
          _buildGenderSelector(),

          const SizedBox(height: 20),

          // Pronouns
          _buildPronounsSelector(),

          const SizedBox(height: 20),

          // Zodiac
          _buildZodiacSelector(),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onUpdate(_zodiac, _pronouns, _genders);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.wc,
              color: AppTheme.bordeaux,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Genre',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genderOptions.map((gender) {
            final isSelected = _genders.contains(gender);
            return FilterChip(
              label: Text(gender),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  if (isSelected) {
                    _genders.remove(gender);
                  } else {
                    _genders.add(gender);
                  }
                });
              },
              selectedColor: AppTheme.bordeaux.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.bordeaux,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.bordeaux : AppTheme.navy,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppTheme.gray100,
              side: BorderSide(
                color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPronounsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.record_voice_over,
              color: AppTheme.bordeaux,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Pronoms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pronounOptions.map((pronoun) {
            final isSelected = _pronouns == pronoun;
            return FilterChip(
              label: Text(pronoun),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _pronouns = pronoun);
              },
              selectedColor: AppTheme.bordeaux.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.bordeaux,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.bordeaux : AppTheme.navy,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppTheme.gray100,
              side: BorderSide(
                color: isSelected ? AppTheme.bordeaux : AppTheme.gray300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildZodiacSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              color: AppTheme.gold,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Signe Astrologique',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2,
          ),
          itemCount: zodiacSigns.length,
          itemBuilder: (context, index) {
            final sign = zodiacSigns[index];
            final isSelected = _zodiac == sign;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _zodiac = _zodiac == sign ? null : sign;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.gold : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.gold : AppTheme.gray300,
                  ),
                ),
                child: Center(
                  child: Text(
                    sign,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
