import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Photo with caption management
class PhotoWithCaption {
  final String url;
  final String? caption;
  final int displayOrder;
  final int likeCount;
  final DateTime? uploadedAt;

  PhotoWithCaption({
    required this.url,
    this.caption,
    required this.displayOrder,
    this.likeCount = 0,
    this.uploadedAt,
  });

  PhotoWithCaption copyWith({
    String? url,
    String? caption,
    int? displayOrder,
    int? likeCount,
    DateTime? uploadedAt,
  }) {
    return PhotoWithCaption(
      url: url ?? this.url,
      caption: caption ?? this.caption,
      displayOrder: displayOrder ?? this.displayOrder,
      likeCount: likeCount ?? this.likeCount,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

/// Photo Captions Widget - Add captions to photos
class PhotoCaptionsWidget extends StatefulWidget {
  final List<PhotoWithCaption> photos;
  final Function(List<PhotoWithCaption>) onPhotosUpdated;

  const PhotoCaptionsWidget({
    super.key,
    required this.photos,
    required this.onPhotosUpdated,
  });

  @override
  State<PhotoCaptionsWidget> createState() => _PhotoCaptionsWidgetState();
}

class _PhotoCaptionsWidgetState extends State<PhotoCaptionsWidget> {
  late List<PhotoWithCaption> _photos;
  final Map<int, TextEditingController> _captionControllers = {};

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.photos);
    for (var photo in _photos) {
      _captionControllers[photo.displayOrder] =
          TextEditingController(text: photo.caption ?? '');
    }
  }

  @override
  void dispose() {
    for (var controller in _captionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateCaption(int index, String caption) {
    setState(() {
      _photos[index] = _photos[index].copyWith(caption: caption);
    });
    widget.onPhotosUpdated(_photos);
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final photo = _photos.removeAt(oldIndex);
      _photos.insert(newIndex, photo);

      // Update display orders
      for (int i = 0; i < _photos.length; i++) {
        _photos[i] = _photos[i].copyWith(displayOrder: i);
      }
    });
    widget.onPhotosUpdated(_photos);
  }

  void _removePhoto(int index) {
    setState(() {
      _captionControllers[_photos[index].displayOrder]?.dispose();
      _captionControllers.remove(_photos[index].displayOrder);
      _photos.removeAt(index);

      // Update display orders
      for (int i = 0; i < _photos.length; i++) {
        _photos[i] = _photos[i].copyWith(displayOrder: i);
      }
    });
    widget.onPhotosUpdated(_photos);
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
            const Text(
              'Photos et Descriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            Text(
              '${_photos.length}/6',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.navy.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Text(
          'Ajoutez des descriptions à vos photos pour plus de matches',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.gray600,
          ),
        ),

        const SizedBox(height: 20),

        // Reorderable photo list
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _photos.length,
          onReorder: _reorderPhotos,
          itemBuilder: (context, index) {
            final photo = _photos[index];
            return _PhotoCaptionCard(
              key: ValueKey(photo.displayOrder),
              photo: photo,
              captionController: _captionControllers[photo.displayOrder]!,
              onCaptionChanged: (caption) => _updateCaption(index, caption),
              onRemove: () => _removePhoto(index),
              index: index,
            );
          },
        ),

        const SizedBox(height: 16),

        // Tips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.bordeaux.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.bordeaux.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.bordeaux,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Conseils pour des descriptions efficaces',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Montrez votre personnalité\n'
                '• Mentionnez où la photo a été prise\n'
                '• Partagez une anecdote\n'
                '• Soyez authentique et original',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms),
      ],
    );
  }
}

/// Individual photo caption card
class _PhotoCaptionCard extends StatelessWidget {
  final PhotoWithCaption photo;
  final TextEditingController captionController;
  final Function(String) onCaptionChanged;
  final VoidCallback onRemove;
  final int index;

  const _PhotoCaptionCard({
    super.key,
    required this.photo,
    required this.captionController,
    required this.onCaptionChanged,
    required this.onRemove,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo and order
          Row(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.drag_handle,
                  color: AppTheme.gray600,
                ),
              ),

              const SizedBox(width: 12),

              // Photo thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(photo.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Order badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppTheme.gold.withValues(alpha: 0.2)
                      : AppTheme.gray100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: index == 0 ? AppTheme.gold : AppTheme.gray300,
                  ),
                ),
                child: Text(
                  index == 0 ? 'Principale' : '#${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: index == 0 ? AppTheme.gold : AppTheme.gray700,
                  ),
                ),
              ),

              const Spacer(),

              // Like count
              if (photo.likeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.bordeaux.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppTheme.bordeaux,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${photo.likeCount}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.bordeaux,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(width: 8),

              // Remove button
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppTheme.gray400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Caption field
          TextField(
            controller: captionController,
            maxLength: 100,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Ajoutez une description à cette photo...',
              hintStyle: TextStyle(
                color: AppTheme.gray400,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.gray200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.bordeaux,
                  width: 2,
                ),
              ),
              counterStyle: TextStyle(
                color: AppTheme.gray500,
                fontSize: 12,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.navy,
            ),
            onChanged: onCaptionChanged,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }
}

/// Photo like button for profile viewing
class PhotoLikeButton extends StatefulWidget {
  final String photoId;
  final int initialLikeCount;
  final bool isLiked;
  final Function(bool, int) onLikeToggle;

  const PhotoLikeButton({
    super.key,
    required this.photoId,
    required this.initialLikeCount,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  State<PhotoLikeButton> createState() => _PhotoLikeButtonState();
}

class _PhotoLikeButtonState extends State<PhotoLikeButton> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.initialLikeCount;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    widget.onLikeToggle(_isLiked, _likeCount);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: _isLiked
              ? AppTheme.bordeaux.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? AppTheme.bordeaux : Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              _likeCount > 0 ? '$_likeCount' : 'Like',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: _isLiked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ).animate(target: _isLiked ? 1 : 0).scale(
          duration: 200.ms,
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
        );
  }
}
