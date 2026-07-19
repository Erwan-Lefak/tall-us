import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';
import 'package:tall_us/features/verification/presentation/providers/height_verification_provider.dart';

/// Height Verification Screen
///
/// User captures a full-body photo next to a reference object (door frame /
/// measuring tape) + today's date on paper, then submits it for admin review.
class HeightVerificationScreen extends ConsumerStatefulWidget {
  const HeightVerificationScreen({super.key});

  @override
  ConsumerState<HeightVerificationScreen> createState() =>
      _HeightVerificationScreenState();
}

class _HeightVerificationScreenState
    extends ConsumerState<HeightVerificationScreen> {
  // On web we keep bytes (File won't work); on mobile we could keep a path,
  // but we always upload via bytes for consistency.
  List<int>? _imageBytes;
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      // Prefer camera (live capture, anti-fraud); fall back to gallery on web.
      final source = kIsWeb ? ImageSource.gallery : ImageSource.camera;
      final xfile = await picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 85,
      );
      if (xfile == null) return;
      final bytes = await xfile.readAsBytes();
      setState(() => _imageBytes = bytes);
    } catch (e) {
      AppLogger.e('Image pick failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sélection d\'image impossible: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    final bytes = _imageBytes;
    if (bytes == null) return;

    final user = ref.read(authenticatedUserProvider);
    final profile = ref.read(profileProvider).profile;
    if (user == null || profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil introuvable, reconnecte-toi.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      // 1. Upload the photo (web-safe bytes path) to the photos bucket.
      final filename =
          'verify_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadResult =
          await ref.read(profileRepositoryProvider).uploadPhotoBytes(
                userId: user.id,
                bytes: bytes,
                filename: filename,
              );
      final url = uploadResult.fold((_) => null, (url) => url);
      if (url == null) {
        throw Exception('upload failed');
      }

      // 2. Create the verification document (status = submitted).
      await ref.read(heightVerificationRepositoryProvider).submitVerification(
            userId: user.id,
            claimedHeightCm: profile.heightCm,
            photoUrl: url,
          );

      // 3. Refresh status + go home.
      ref.invalidate(heightVerificationStatusProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vérification envoyée ✓ — en attente de validation.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      AppLogger.e('Height verification submit failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).profile;
    final heightCm = profile?.heightCm ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Vérifie ta taille',
          style: TextStyle(
            color: AppTheme.navy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.bordeaux.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user,
                      color: AppTheme.bordeaux, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Badge « Vérifié Tall »',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.navy)),
                      const SizedBox(height: 2),
                      Text('Ta taille déclarée : ${(heightCm / 100).toStringAsFixed(2)} m ($heightCm cm)',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.navy.withValues(alpha: 0.6))),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Guide
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comment te faire vérifier',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.navy)),
                  const SizedBox(height: 12),
                  _guideStep(Icons.person, 'Tiens-toi debout, en pleine longueur, de pieds ferms.'),
                  _guideStep(Icons.door_front_door, 'À côté d\'un cadre de porte standard (~2,03 m) ou d\'un mètre déroulé.'),
                  _guideStep(Icons.edit, 'Tiens une feuille avec la date du jour et ton prénom.'),
                  _guideStep(Icons.camera_alt, 'Prends la photo maintenant (capture live exigée).'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Photo preview / picker
            GestureDetector(
              onTap: _isSubmitting ? null : _pickImage,
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppTheme.bordeaux.withValues(alpha: 0.3),
                      width: 1.5),
                ),
                child: _imageBytes == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(kIsWeb ? Icons.upload_file : Icons.camera_alt,
                              size: 48,
                              color: AppTheme.bordeaux.withValues(alpha: 0.6)),
                          const SizedBox(height: 10),
                          Text(
                            kIsWeb ? 'Choisir une photo' : 'Prendre une photo',
                            style: TextStyle(
                                color: AppTheme.bordeaux,
                                fontWeight: FontWeight.w700,
                                fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Format pleine longueur + référence',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.navy.withValues(alpha: 0.5)),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(
                              Uint8List.fromList(_imageBytes!),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _isSubmitting
                                    ? null
                                    : () => setState(() => _imageBytes = null),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.refresh,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: (_imageBytes == null || _isSubmitting) ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.bordeaux,
                  disabledBackgroundColor:
                      AppTheme.bordeaux.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Envoyer la vérification',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              'Ta demande sera examinée par notre équipe. Tu pourras liker dès qu\'elle est validée.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideStep(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.bordeaux),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.8))),
          ),
        ],
      ),
    );
  }
}
