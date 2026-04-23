import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Advanced photo gallery editor with drag & drop reordering
class PhotoGalleryEditor extends StatefulWidget {
  final List<String> photoUrls;
  final Function(List<String>) onPhotosUpdated;
  final int maxPhotos;
  final bool allowReorder;
  final bool allowDelete;

  const PhotoGalleryEditor({
    super.key,
    required this.photoUrls,
    required this.onPhotosUpdated,
    this.maxPhotos = 6,
    this.allowReorder = true,
    this.allowDelete = true,
  });

  @override
  State<PhotoGalleryEditor> createState() => _PhotoGalleryEditorState();
}

class _PhotoGalleryEditorState extends State<PhotoGalleryEditor> {
  late List<String> _photos;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isReordering = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.photoUrls);
  }

  Future<void> _addPhoto() async {
    if (_photos.length >= widget.maxPhotos) {
      _showMaxPhotosWarning();
      return;
    }

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _photos.add(image.path);
      });
      widget.onPhotosUpdated(_photos);
    }
  }

  Future<void> _takePhoto() async {
    if (_photos.length >= widget.maxPhotos) {
      _showMaxPhotosWarning();
      return;
    }

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _photos.add(image.path);
      });
      widget.onPhotosUpdated(_photos);
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosUpdated(_photos);
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = _photos.removeAt(oldIndex);
    setState(() {
      _photos.insert(newIndex, item);
    });
    widget.onPhotosUpdated(_photos);
  }

  void _showMaxPhotosWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum ${widget.maxPhotos} photos autorisées'),
        backgroundColor: AppTheme.bordeaux,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPhotoOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.visibility, color: AppTheme.bordeaux),
                title: const Text('Voir la photo'),
                onTap: () {
                  Navigator.pop(context);
                  _viewPhoto(index);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: AppTheme.bordeaux),
                title: const Text('Supprimer'),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto(index);
                },
              ),
              if (index > 0)
                ListTile(
                  leading: const Icon(Icons.star, color: AppTheme.gold),
                  title: const Text('Définir comme photo principale'),
                  onTap: () {
                    Navigator.pop(context);
                    _reorderPhotos(index, 0);
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _viewPhoto(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PhotoViewer(
          photoUrls: _photos,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mes Photos',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Row(
              children: [
                Text(
                  '${_photos.length}/${widget.maxPhotos}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.navy.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.allowReorder && _photos.length > 1) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isReordering = !_isReordering;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isReordering ? AppTheme.bordeaux : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.bordeaux),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.swap_vert,
                            size: 16,
                            color: _isReordering
                                ? Colors.white
                                : AppTheme.bordeaux,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Réorganiser',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isReordering
                                  ? Colors.white
                                  : AppTheme.bordeaux,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
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
            childAspectRatio: 0.75,
          ),
          itemCount: _photos.length + 1,
          itemBuilder: (context, index) {
            // Add photo button
            if (index == _photos.length) {
              if (_photos.length >= widget.maxPhotos) {
                return const SizedBox.shrink();
              }
              return _AddPhotoButton(
                onAddPhoto: _addPhoto,
                onTakePhoto: _takePhoto,
              );
            }

            // Photo item
            return _PhotoItem(
              photoUrl: _photos[index],
              index: index,
              isFirst: index == 0,
              isReordering: _isReordering,
              onTap: () => _showPhotoOptions(index),
              onReorder: _isReordering ? () => _reorderPhotos(index, 0) : null,
            );
          },
        ),

        const SizedBox(height: 12),

        // Tips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bordeaux.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppTheme.bordeaux),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'La première photo est votre photo principale. Glissez pour réorganiser.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual photo item
class _PhotoItem extends StatelessWidget {
  final String photoUrl;
  final int index;
  final bool isFirst;
  final bool isReordering;
  final VoidCallback onTap;
  final VoidCallback? onReorder;

  const _PhotoItem({
    required this.photoUrl,
    required this.index,
    required this.isFirst,
    required this.isReordering,
    required this.onTap,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReordering ? onReorder : onTap,
      child: Stack(
        children: [
          // Photo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: photoUrl.startsWith('http')
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.gray200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: AppTheme.gray400,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.gray200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: AppTheme.gray400,
                          ),
                        );
                      },
                    ),
            ),
          ),

          // First photo badge
          if (isFirst)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.gold,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Text(
                  'PRINCIPALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Reorder indicator
          if (isReordering)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.swap_vert,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

          // More options button
          if (!isReordering)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: AppTheme.navy,
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale();
  }
}

/// Add photo button
class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onAddPhoto;
  final VoidCallback onTakePhoto;

  const _AddPhotoButton({
    required this.onAddPhoto,
    required this.onTakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoSourceBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.bordeaux.withValues(alpha: 0.5),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.bordeaux.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 32,
                color: AppTheme.bordeaux,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajouter',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  void _showPhotoSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: AppTheme.bordeaux),
                title: const Text('Choisir dans la galerie'),
                onTap: () {
                  Navigator.pop(context);
                  onAddPhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppTheme.bordeaux),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  onTakePhoto();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full screen photo viewer
class _PhotoViewer extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const _PhotoViewer({
    required this.photoUrls,
    required this.initialIndex,
  });

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.photoUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photoUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              child: widget.photoUrls[index].startsWith('http')
                  ? Image.network(
                      widget.photoUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    )
                  : Image.asset(
                      widget.photoUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
