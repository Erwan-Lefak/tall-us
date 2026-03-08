import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Height Verification Screen
///
/// Allows users to submit a verification photo to prove their height
class HeightVerificationScreen extends ConsumerStatefulWidget {
  const HeightVerificationScreen({super.key});

  @override
  ConsumerState<HeightVerificationScreen> createState() =>
      _HeightVerificationScreenState();
}

class _HeightVerificationScreenState extends ConsumerState<HeightVerificationScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  int? _currentHeight;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final userProfile = profileState.profile;

    // Use height from profile or set value
    if (userProfile != null && _currentHeight == null) {
      _currentHeight = userProfile.heightCm;
    }

    final isVerified = userProfile?.heightVerified ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vérification de taille',
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
            // Verification status card
            if (isVerified) _buildVerifiedCard() else _buildPendingCard(),

            const SizedBox(height: 32),

            // Height display
            _buildHeightCard(),

            const SizedBox(height: 32),

            // Instructions
            _buildInstructionsSection(),

            const SizedBox(height: 32),

            // Photo upload section
            _buildPhotoUploadSection(),

            const SizedBox(height: 32),

            // Submit button
            if (!isVerified) _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Verified card shown when height is verified
  Widget _buildVerifiedCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.verified,
            size: 64,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text(
            'Taille vérifiée ✓',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Votre taille de ${_currentHeight ?? 0} cm a été vérifiée',
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.navy,
            ),
          ),
        ],
      ),
    );
  }

  /// Pending card shown when height is not yet verified
  Widget _buildPendingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.pending,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'Taille non vérifiée',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vérifiez votre taille pour augmenter votre visibilité',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Height display card
  Widget _buildHeightCard() {
    final totalInches = ((_currentHeight ?? 0) / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;

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
        children: [
          const Icon(Icons.height, color: AppTheme.bordeaux, size: 32),
          const SizedBox(height: 16),
          Text(
            '$feet\'$inches"',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentHeight ?? 0} cm',
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Instructions section
  Widget _buildInstructionsSection() {
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
              const Icon(Icons.info_outline, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Comment prendre votre photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _InstructionStep(
            number: '1',
            text: 'Trouvez un mur avec un cadre de porte (généralement à environ 2m de hauteur)',
          ),
          const _InstructionStep(
            number: '2',
            text: 'Tenez-vous debout, dos contre le mur, tête droite',
          ),
          const _InstructionStep(
            number: '3',
            text: 'Placez une règle ou un mètre sur le cadre de porte',
          ),
          const _InstructionStep(
            number: '4',
            text: 'Prenez la photo en incluant votre tête et la règle',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bordeaux.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Assurez-vous que la règle est bien visible et que le haut de votre tête est clairement visible.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Photo upload section
  Widget _buildPhotoUploadSection() {
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
              const Icon(Icons.camera_alt, color: AppTheme.bordeaux, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Télécharger votre photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedImage!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.bordeaux.withValues(alpha: 0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 48,
                        color: AppTheme.bordeaux,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Appuyez pour prendre une photo',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.navy.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (_selectedImage != null)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                });
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Supprimer la photo'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  /// Submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedImage != null && !_isLoading ? _submitVerification : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.bordeaux,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Soumettre pour vérification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  /// Pick image from camera or gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir dans la galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Submit verification
  Future<void> _submitVerification() async {
    if (_selectedImage == null || _currentHeight == null) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Upload image to storage and get URL
      // TODO: Submit verification to repository

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vérification soumise avec succès !'),
            backgroundColor: AppTheme.bordeaux,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la soumission: $e'),
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

/// Instruction step widget
class _InstructionStep extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionStep({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.bordeaux,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.navy,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
