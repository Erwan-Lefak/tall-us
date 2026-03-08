import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';

/// Profile completion screen - guides users through completing their profile
class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  final _pageController = PageController();
  final _bioController = TextEditingController();
  int _currentStep = 0;

  // Form data
  final List<String> _selectedPhotos = [];
  String? _selectedPromptId;

  final int _totalSteps = 3;

  @override
  void dispose() {
    _pageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeProfile() async {
    // TODO: Implement profile completion
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.1),
              AppTheme.navy.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Progress indicator
              _buildProgressIndicator(),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    _buildPhotosStep(),
                    _buildBioStep(),
                    _buildPromptStep(),
                  ],
                ),
              ),

              // Navigation buttons
              _buildNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Complétez votre profil',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '3 étapes pour rencontrer des personnes exceptionnelles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.navy.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(
        children: List.generate(
          _totalSteps,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index < _totalSteps - 1 ? 8 : 0,
              ),
              height: 4,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppTheme.bordeaux
                    : AppTheme.navy.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Photo grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final hasPhoto = index < _selectedPhotos.length;
                return GestureDetector(
                  onTap: () => _addPhoto(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasPhoto ? null : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasPhoto
                            ? Colors.transparent
                            : AppTheme.navy.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      image: hasPhoto
                          ? DecorationImage(
                              image: NetworkImage(_selectedPhotos[index]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: hasPhoto
                        ? Stack(
                            children: [
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _removePhoto(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  index == 0 ? Icons.add_a_photo : Icons.add,
                                  size: 40,
                                  color: AppTheme.navy.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  index == 0 ? 'Photo principale' : 'Ajouter',
                                  style: TextStyle(
                                    color: AppTheme.navy.withValues(alpha: 0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Minimum 1 photo (max 6)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.navy.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parlez-nous de vous',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Décrivez votre personnalité, vos passions, ce que vous recherchez...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.navy.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.navy.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _bioController,
                maxLines: null,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Votre bio...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptStep() {
    final popularPrompts = TallPrompts.getPopular(limit: 4);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez un prompt',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sélectionnez une question pour briser la glace',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.navy.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: popularPrompts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final prompt = popularPrompts[index];
                final isSelected = _selectedPromptId == prompt.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPromptId = prompt.id;
                    });
                    _showPromptAnswerDialog(prompt);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.bordeaux.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.bordeaux : AppTheme.navy.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? AppTheme.bordeaux : AppTheme.navy.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            prompt.text,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.navy,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    final isFirstStep = _currentStep == 0;
    final isLastStep = _currentStep == _totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Row(
          children: [
            if (!isFirstStep)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: AppTheme.bordeaux),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Retour',
                    style: TextStyle(
                      color: AppTheme.bordeaux,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (!isFirstStep) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.bordeaux,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isLastStep ? 'Terminer' : 'Continuer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPhoto(int index) async {
    // TODO: Implement photo picker
    setState(() {
      if (index < _selectedPhotos.length) {
        // Photo already exists, do nothing
      } else if (_selectedPhotos.isEmpty) {
        // Add placeholder for demo
        _selectedPhotos.add('https://via.placeholder.com/400x600');
      }
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  Future<void> _showPromptAnswerDialog(PromptEntity prompt) async {
    final answer = await showDialog<String>(
      context: context,
      builder: (context) => _PromptAnswerDialog(prompt: prompt),
    );

    if (answer != null && answer.isNotEmpty) {
      setState(() {
        // Store the answer - will be saved when completing profile
        _selectedPromptId = prompt.id;
      });
    }
  }
}

class _PromptAnswerDialog extends StatefulWidget {
  final PromptEntity prompt;

  const _PromptAnswerDialog({required this.prompt});

  @override
  State<_PromptAnswerDialog> createState() => _PromptAnswerDialogState();
}

class _PromptAnswerDialogState extends State<_PromptAnswerDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.prompt.text),
      content: TextField(
        controller: _controller,
        maxLength: 200,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Votre réponse...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
