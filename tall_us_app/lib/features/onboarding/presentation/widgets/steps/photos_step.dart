import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';

/// Photo upload step (up to 6 photos).
class PhotosStep extends ConsumerStatefulWidget {
  const PhotosStep({super.key});

  @override
  ConsumerState<PhotosStep> createState() => _PhotosStepState();
}

class _PhotosStepState extends ConsumerState<PhotosStep> {
  bool _uploading = false;

  Future<void> _pickImage() async {
    final data = ref.read(onboardingProvider);
    if (data == null || data.photoUrls.length >= 6) return;

    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        imageQuality: 85,
      );
      if (xfile == null) return;

      setState(() => _uploading = true);
      final userId = ref.read(authenticatedUserProvider)?.id ?? data.userId;
      // Web-safe upload: read the picked image as bytes and upload via the
      // bytes path (the File(path) path uses dart:io and fails on web).
      final bytes = await xfile.readAsBytes();
      final filename =
          'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result =
          await ref.read(profileRepositoryProvider).uploadPhotoBytes(
                userId: userId,
                bytes: bytes,
                filename: filename,
              );
      final url = result.fold((_) => null, (url) => url);
      if (url != null) {
        ref.read(onboardingProvider.notifier).addPhoto(url);
      }
    } catch (e) {
      AppLogger.e('Photo upload failed', error: e);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);
    final photos = data?.photoUrls ?? const <String>[];

    return OnboardingStepScaffold(
      question: 'Ajoute tes photos',
      hint: 'Au moins 1 photo pour continuer. Maximum 6.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index < photos.length) {
                  return _PhotoTile(
                    url: photos[index],
                    onRemove: () => ref
                        .read(onboardingProvider.notifier)
                        .removePhoto(photos[index]),
                  );
                }
                final isAdd = index == photos.length;
                return _AddTile(
                  onTap: isAdd && !_uploading ? _pickImage : null,
                  uploading: _uploading && isAdd,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String url;
  final VoidCallback onRemove;
  const _PhotoTile({required this.url, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close,
                  color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback? onTap;
  final bool uploading;
  const _AddTile({required this.onTap, required this.uploading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bordeaux.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.bordeaux.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: uploading
            ? const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppTheme.bordeaux),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      color: AppTheme.bordeaux, size: 28),
                  const SizedBox(height: 6),
                  Text('Ajouter',
                      style: TextStyle(
                          color: AppTheme.bordeaux,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
      ),
    );
  }
}
