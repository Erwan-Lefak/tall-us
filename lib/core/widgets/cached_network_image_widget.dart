import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget d'image réseau optimisé avec cache
///
/// Utilise cached_network_image pour:
/// - Mettre en cache les images téléchargées
/// - Afficher des placeholders pendant le chargement
/// - Gérer les erreurs de chargement
/// - Améliorer les performances de l'application
class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration? fadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Si l'URL est vide, retourner un placeholder
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(error),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }

  /// Placeholder par défaut (shimmer effect)
  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey[400]!,
            ),
          ),
        ),
      ),
    );
  }

  /// Widget d'erreur par défaut
  Widget _buildDefaultErrorWidget(Object error) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: const Icon(
        Icons.broken_image,
        size: 32,
        color: Colors.grey,
      ),
    );
  }

  /// Placeholder simple
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
    );
  }
}

/// Widget d'avatar réseau avec cache
class CachedNetworkAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedNetworkAvatarWidget({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: CachedNetworkImageWidget(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          memCacheWidth: (radius * 2).toInt(),
          memCacheHeight: (radius * 2).toInt(),
          placeholder: placeholder,
          errorWidget: errorWidget,
        ),
      ),
    );
  }
}

/// Widget d'image de profil avec cache
///
/// Optimisé pour les photos de profil utilisateur
class CachedProfilePhotoWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const CachedProfilePhotoWidget({
    super.key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImageWidget(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
        placeholder: _buildProfilePlaceholder(),
        errorWidget: _buildProfileErrorWidget(),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: (width ?? 100) * 0.5,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildProfileErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline,
        size: (width ?? 100) * 0.5,
        color: Colors.grey[400],
      ),
    );
  }
}
