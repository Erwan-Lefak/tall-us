import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/storage/presentation/providers/upload_providers.dart';

/// Widget for uploading photos with gallery/camera options
class PhotoUploadWidget extends ConsumerStatefulWidget {
  final int maxPhotos;
  final List<String> existingPhotos;
  final Function(List<String>) onPhotosUpdated;

  const PhotoUploadWidget({
    super.key,
    this.maxPhotos = 6,
    this.existingPhotos = const [],
    required this.onPhotosUpdated,
  });

  @override
  ConsumerState<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends ConsumerState<PhotoUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _photos = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.existingPhotos);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_photos.length >= widget.maxPhotos) {
      _showSnackBar('Maximum ${widget.maxPhotos} photos allowed', isError: true);
      return;
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        // Upload photo
        final file = File(pickedFile.path);
        await ref.read(uploadNotifierProvider.notifier).uploadPhoto(
          file: file,
          userId: 'current_user_id', // TODO: Get from auth
        );

        // Listen to upload state
        ref.listen<UploadState>(uploadNotifierProvider, (previous, next) {
          next.when(
            initial: () {},
            uploading: (progress) {
              // Show progress if needed
            },
            success: (url) {
              setState(() {
                _photos.add(url);
                _isUploading = false;
              });
              widget.onPhotosUpdated(_photos);
              ref.read(uploadNotifierProvider.notifier).reset();
              _showSnackBar('Photo uploaded successfully!');
            },
            error: (message) {
              setState(() {
                _isUploading = false;
              });
              _showSnackBar('Failed to upload photo: $message', isError: true);
              ref.read(uploadNotifierProvider.notifier).reset();
            },
          );
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showSnackBar('Failed to pick image: $e', isError: true);
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosUpdated(_photos);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.navy.withValues(alpha: 0.8) : AppTheme.bordeaux,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Add Photo',
          style: TextStyle(
            color: AppTheme.navy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.bordeaux),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(color: AppTheme.navy),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.bordeaux),
              title: const Text(
                'Take Photo',
                style: TextStyle(color: AppTheme.navy),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Photos',
              style: const TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_photos.length}/${widget.maxPhotos}',
              style: TextStyle(
                color: AppTheme.navy.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Photos grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _photos.length + 1,
          itemBuilder: (context, index) {
            // Add photo button
            if (index == _photos.length) {
              return _buildAddPhotoButton();
            }

            // Photo thumbnail
            return _buildPhotoThumbnail(index);
          },
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    final isEnabled = _photos.length < widget.maxPhotos && !_isUploading;

    return GestureDetector(
      onTap: isEnabled ? _showSourceDialog : null,
      child: Container(
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? AppTheme.bordeaux.withValues(alpha: 0.3)
                : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: _isUploading
            ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                  ),
                ),
              )
            : Icon(
                Icons.add,
                size: 40,
                color: isEnabled ? AppTheme.bordeaux.withValues(alpha: 0.5) : Colors.grey.shade400,
              ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.bordeaux.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              _photos[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: AppTheme.navy,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
