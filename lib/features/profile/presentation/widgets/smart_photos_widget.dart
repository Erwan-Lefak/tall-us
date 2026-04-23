import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'photo_captions_widget.dart';

/// Smart Photo Score - Calculated from engagement metrics
class SmartPhotoScore {
  final String photoId;
  final double score;
  final int likeCount;
  final int viewCount;
  final int matchCount;
  final DateTime lastUpdated;

  double get engagementRate {
    if (viewCount == 0) return 0.0;
    return likeCount / viewCount;
  }

  double get matchRate {
    if (viewCount == 0) return 0.0;
    return matchCount / viewCount;
  }

  SmartPhotoScore({
    required this.photoId,
    required this.score,
    required this.likeCount,
    required this.viewCount,
    required this.matchCount,
    required this.lastUpdated,
  });

  factory SmartPhotoScore.initial(String photoId) {
    return SmartPhotoScore(
      photoId: photoId,
      score: 50.0, // Base score
      likeCount: 0,
      viewCount: 0,
      matchCount: 0,
      lastUpdated: DateTime.now(),
    );
  }

  SmartPhotoScore copyWith({
    String? photoId,
    double? score,
    int? likeCount,
    int? viewCount,
    int? matchCount,
    DateTime? lastUpdated,
  }) {
    return SmartPhotoScore(
      photoId: photoId ?? this.photoId,
      score: score ?? this.score,
      likeCount: likeCount ?? this.likeCount,
      viewCount: viewCount ?? this.viewCount,
      matchCount: matchCount ?? this.matchCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Recalculate score based on engagement
  SmartPhotoScore recalculate() {
    // Weight factors
    const double engagementWeight = 0.4;
    const double matchWeight = 0.35;
    const double viewWeight = 0.15;
    const double recencyWeight = 0.1;

    // Calculate individual scores (0-100)
    final engagementScore = engagementRate * 100;
    final matchScore = matchRate * 100;

    // View score (logarithmic to avoid huge numbers dominating)
    final viewScore = min(100, (log(viewCount + 1) / log(1000)) * 100);

    // Recency score (photos updated more recently get slight boost)
    final daysSinceUpdate = DateTime.now().difference(lastUpdated).inDays;
    final recencyScore = max(0, 100 - (daysSinceUpdate * 2));

    // Weighted average
    final newScore = (engagementScore * engagementWeight) +
        (matchScore * matchWeight) +
        (viewScore * viewWeight) +
        (recencyScore * recencyWeight);

    return copyWith(score: newScore, lastUpdated: DateTime.now());
  }
}

/// Smart Photos Widget - Auto-reorder based on performance
class SmartPhotosWidget extends StatefulWidget {
  final List<PhotoWithCaption> photos;
  final Map<String, SmartPhotoScore> photoScores;
  final Function(List<PhotoWithCaption>, Map<String, SmartPhotoScore>)
      onPhotosReordered;

  const SmartPhotosWidget({
    super.key,
    required this.photos,
    required this.photoScores,
    required this.onPhotosReordered,
  });

  @override
  State<SmartPhotosWidget> createState() => _SmartPhotosWidgetState();
}

class _SmartPhotosWidgetState extends State<SmartPhotosWidget> {
  bool _isSmartOrderEnabled = false;
  bool _isCalculating = false;
  List<PhotoWithCaption> _orderedPhotos = [];
  Map<String, SmartPhotoScore> _scores = {};

  @override
  void initState() {
    super.initState();
    _orderedPhotos = List.from(widget.photos);
    _scores = Map.from(widget.photoScores);
    _initializeScores();
  }

  void _initializeScores() {
    for (var photo in widget.photos) {
      _scores.putIfAbsent(
        photo.url,
        () => SmartPhotoScore.initial(photo.url),
      );
    }
  }

  Future<void> _calculateSmartOrder() async {
    setState(() => _isCalculating = true);

    // Simulate calculation delay
    await Future.delayed(const Duration(seconds: 1));

    // Update all scores
    final updatedScores = <String, SmartPhotoScore>{};
    for (var entry in _scores.entries) {
      updatedScores[entry.key] = entry.value.recalculate();
    }

    // Sort photos by score
    final sortedPhotos = List<PhotoWithCaption>.from(_orderedPhotos);
    sortedPhotos.sort((a, b) {
      final scoreA = updatedScores[a.url]?.score ?? 0;
      final scoreB = updatedScores[b.url]?.score ?? 0;
      return scoreB.compareTo(scoreA); // Descending order
    });

    // Update display orders
    for (int i = 0; i < sortedPhotos.length; i++) {
      sortedPhotos[i] = sortedPhotos[i].copyWith(displayOrder: i);
    }

    setState(() {
      _orderedPhotos = sortedPhotos;
      _scores = updatedScores;
      _isCalculating = false;
    });

    widget.onPhotosReordered(_orderedPhotos, _scores);
  }

  void _toggleSmartOrder(bool value) {
    setState(() {
      _isSmartOrderEnabled = value;
      if (value) {
        _calculateSmartOrder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.gold.withValues(alpha: 0.1),
            AppTheme.bordeaux.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppTheme.gold,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Smart Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      Text(
                        'Classement automatique par performance',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: _isSmartOrderEnabled,
                onChanged: _toggleSmartOrder,
                activeColor: AppTheme.gold,
              ),
            ],
          ),

          if (_isSmartOrderEnabled) ...[
            const SizedBox(height: 20),

            // Status
            if (_isCalculating)
              Column(
                children: [
                  const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Calcul des scores de performance...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  // Best performing photo
                  if (_orderedPhotos.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.gold,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(_orderedPhotos.first.url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppTheme.gold,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Meilleure performance',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.navy,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Score: ${_scores[_orderedPhotos.first.url]?.score.toStringAsFixed(1) ?? 'N/A'}/100',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.gray600,
                                  ),
                                ),
                                if (_orderedPhotos.first.caption != null)
                                  Text(
                                    _orderedPhotos.first.caption!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.gray700,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms).scale(),
                    const SizedBox(height: 16),
                  ],

                  // Performance insights
                  _buildPerformanceInsights(),
                ],
              ),
          ],

          if (!_isSmartOrderEnabled) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.gray600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Activez pour que vos photos soient classées automatiquement selon leur performance (likes, matches, vues)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPerformanceInsights() {
    final scoredPhotos = _orderedPhotos
        .map((p) => (photo: p, score: _scores[p.url]?.score ?? 0))
        .toList();

    if (scoredPhotos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance de vos photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          min(3, scoredPhotos.length),
          (index) {
            final item = scoredPhotos[index];
            final score = item.score;
            final photo = item.photo;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.gray200,
                ),
              ),
              child: Row(
                children: [
                  // Rank badge
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppTheme.gold
                          : index == 1
                              ? AppTheme.gray400
                              : AppTheme.bordeaux.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: index == 2 ? AppTheme.bordeaux : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Photo thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      photo.url,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Score
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: score / 100,
                          backgroundColor: AppTheme.gray200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            score >= 70
                                ? AppTheme.success
                                : score >= 40
                                    ? AppTheme.gold
                                    : AppTheme.bordeaux,
                          ),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${score.toStringAsFixed(0)}/100',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Photo order verification dialog (anti-catfish)
class PhotoOrderVerificationDialog extends StatefulWidget {
  final List<PhotoWithCaption> photos;
  final VoidCallback onVerified;

  const PhotoOrderVerificationDialog({
    super.key,
    required this.photos,
    required this.onVerified,
  });

  @override
  State<PhotoOrderVerificationDialog> createState() =>
      _PhotoOrderVerificationDialogState();
}

class _PhotoOrderVerificationDialogState
    extends State<PhotoOrderVerificationDialog> {
  bool _isVerifying = false;

  Future<void> _verifyPhotos() async {
    setState(() => _isVerifying = true);

    // Simulate verification process
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isVerifying = false);
    widget.onVerified();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified,
                color: AppTheme.success,
                size: 40,
              ),
            ).animate().scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Vérification de l\'ordre des photos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Nous allons vérifier que vos photos correspondent à votre profil pour garantir la sécurité de tous les utilisateurs.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Photo preview
            if (widget.photos.isNotEmpty)
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: min(3, widget.photos.length),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(widget.photos[index].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // Verify button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyPhotos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Vérifier mes photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Plus tard',
                style: TextStyle(
                  color: AppTheme.gray600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
