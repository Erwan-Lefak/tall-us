import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// ID Verification Widget - Upload ID document for age verification
class IDVerificationWidget extends StatefulWidget {
  final bool isVerified;
  final Function(String frontIdPath, String? backIdPath)
      onVerificationSubmitted;
  final VoidCallback onStartVerification;

  const IDVerificationWidget({
    super.key,
    required this.isVerified,
    required this.onVerificationSubmitted,
    required this.onStartVerification,
  });

  @override
  State<IDVerificationWidget> createState() => _IDVerificationWidgetState();
}

class _IDVerificationWidgetState extends State<IDVerificationWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _frontIdPath;
  String? _backIdPath;
  bool _isUploading = false;
  int _currentStep = 0;

  Future<void> _pickFrontId() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _frontIdPath = image.path;
        if (_currentStep == 0) _currentStep = 1;
      });
    }
  }

  Future<void> _pickBackId() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _backIdPath = image.path;
        if (_currentStep == 1) _currentStep = 2;
      });
    }
  }

  void _submitVerification() {
    if (_frontIdPath != null) {
      widget.onVerificationSubmitted(_frontIdPath!, _backIdPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVerified) {
      return _buildVerifiedBadge();
    }

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
          color: AppTheme.bordeaux.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.badge,
                  color: AppTheme.bordeaux,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vérification d\'Identité',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    Text(
                      'Confirmez que vous avez 18 ans ou plus',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.navy.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress steps
          _buildProgressSteps(),

          const SizedBox(height: 20),

          // Instructions
          Container(
            padding: const EdgeInsets.all(12),
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
                    Icon(
                      Icons.security,
                      size: 16,
                      color: AppTheme.bordeaux,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pourquoi vérifier ?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Gagnez un badge de vérification sur votre profil\n'
                  '• Augmentez votre crédibilité auprès des autres utilisateurs\n'
                  '• Accédez à des fonctionnalités exclusives\n'
                  '• Vos données sont chiffrées et sécurisées',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Front ID upload
          _buildIdUploadSection(
            title: 'Recto de la pièce d\'identité',
            subtitle: 'Carte nationale d\'identité, passeport ou permis',
            imagePath: _frontIdPath,
            onTap: _pickFrontId,
            isRequired: true,
          ),

          const SizedBox(height: 16),

          // Back ID upload (optional for some IDs)
          _buildIdUploadSection(
            title: 'Verso de la pièce d\'identité',
            subtitle: 'Optionnel pour certains documents',
            imagePath: _backIdPath,
            onTap: _pickBackId,
            isRequired: false,
          ),

          const SizedBox(height: 20),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_frontIdPath != null && !_isUploading)
                  ? _submitVerification
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Soumettre pour vérification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // Privacy note
          Text(
            'Vos informations sont transmises de manière sécurisée et ne seront jamais partagées avec d\'autres utilisateurs.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.gray600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bordeaux,
            AppTheme.bordeaux.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bordeaux.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Identité Vérifiée',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '18+ confirmé',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().pulse(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
        );
  }

  Widget _buildProgressSteps() {
    return Row(
      children: [
        _buildStep(1, 'Recto', _currentStep >= 0),
        Expanded(
          child: Container(
            height: 2,
            color: _currentStep >= 1 ? AppTheme.bordeaux : AppTheme.gray300,
          ),
        ),
        _buildStep(2, 'Verso', _currentStep >= 1),
        Expanded(
          child: Container(
            height: 2,
            color: _currentStep >= 2 ? AppTheme.bordeaux : AppTheme.gray300,
          ),
        ),
        _buildStep(3, 'Vérifié', _currentStep >= 2),
      ],
    );
  }

  Widget _buildStep(int stepNumber, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.bordeaux : AppTheme.gray300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isActive
                  ? Icon(
                      stepNumber == 3 ? Icons.check : Icons.looks_one,
                      color: Colors.white,
                      size: 18,
                    )
                  : Text(
                      stepNumber.toString(),
                      style: const TextStyle(
                        color: AppTheme.gray600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? AppTheme.bordeaux : AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdUploadSection({
    required String title,
    required String subtitle,
    required String? imagePath,
    required VoidCallback onTap,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.gray600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: imagePath != null ? AppTheme.bordeaux : AppTheme.gray300,
                width: imagePath != null ? 2 : 1,
              ),
            ),
            child: imagePath != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imagePath),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: AppTheme.gray400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Touchez pour ajouter',
                        style: TextStyle(
                          color: AppTheme.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isRequired)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '*Obligatoire',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.bordeaux,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ).animate().fadeIn(duration: 300.ms),
      ],
    );
  }
}
