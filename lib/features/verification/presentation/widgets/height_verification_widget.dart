import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Height Verification Widget - Upload photo with measurement
class HeightVerificationWidget extends StatefulWidget {
  final bool isVerified;
  final int heightCm;
  final Function(String) onVerificationSubmitted;
  final VoidCallback onStartVerification;

  const HeightVerificationWidget({
    super.key,
    required this.isVerified,
    required this.heightCm,
    required this.onVerificationSubmitted,
    required this.onStartVerification,
  });

  @override
  State<HeightVerificationWidget> createState() => _HeightVerificationWidgetState();
}

class _HeightVerificationWidgetState extends State<HeightVerificationWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isUploading = false;

  Future<void> _pickVerificationPhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _submitVerification() {
    if (_selectedImagePath != null) {
      widget.onVerificationSubmitted(_selectedImagePath!);
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified,
                  color: AppTheme.bordeaux,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vérification de Taille',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    Text(
                      'Prouvez que vous mesurez ${widget.heightCm} cm',
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

          const SizedBox(height: 16),

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
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.bordeaux,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Comment faire :',
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
                _buildInstructionStep(
                  '1.',
                  'Tenez une photo de vous à côté d\'un objet de référence (porte, mur)',
                ),
                const SizedBox(height: 4),
                _buildInstructionStep(
                  '2.',
                  'Assurez-vous que votre taille est bien visible sur la photo',
                ),
                const SizedBox(height: 4),
                _buildInstructionStep(
                  '3.',
                  'Notre équipe vérifiera votre photo sous 24-48h',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Upload section
          if (_selectedImagePath == null)
            GestureDetector(
              onTap: _pickVerificationPhoto,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.bordeaux,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 32,
                      color: AppTheme.bordeaux,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Télécharger la photo de vérification',
                      style: TextStyle(
                        color: AppTheme.bordeaux,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _selectedImagePath!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppTheme.gray200,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Retake button
                OutlinedButton.icon(
                  onPressed: _pickVerificationPhoto,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reprendre la photo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.navy,
                    side: const BorderSide(color: AppTheme.navy),
                  ),
                ),

                const SizedBox(height: 12),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _submitVerification,
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
              ],
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
            AppTheme.gold,
            AppTheme.gold.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withValues(alpha: 0.4),
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
                'Taille Vérifiée',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.heightCm} cm confirmé',
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

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.bordeaux,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.navy.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
