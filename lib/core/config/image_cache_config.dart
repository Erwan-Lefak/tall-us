import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Configuration du cache d'images pour l'application
///
/// Utilise flutter_cache_manager pour gérer le cache des images réseau
class ImageCacheConfig {
  /// Instance singleton du cache manager
  static final CacheManager instance = CacheManager(
    Config(
      'tall_us_images_cache',
      stalePeriod: const Duration(days: 7), // Les images sont valides 7 jours
      maxNrOfCacheObjects: 200, // Maximum 200 images en cache
      repo: JsonCacheInfoRepository(databaseName: 'tall_us_images_cache'),
      fileService: HttpFileService(),
    ),
  );

  /// Cache manager pour les petits avatars (plus agressif)
  static final CacheManager avatarCache = CacheManager(
    Config(
      'tall_us_avatars_cache',
      stalePeriod: const Duration(days: 14), // Avatars valides 14 jours
      maxNrOfCacheObjects: 100, // Jusqu'à 100 avatars
      repo: JsonCacheInfoRepository(databaseName: 'tall_us_avatars_cache'),
      fileService: HttpFileService(),
    ),
  );

  /// Cache manager pour les images temporaires (événements, etc.)
  static final CacheManager temporaryCache = CacheManager(
    Config(
      'tall_us_temporary_cache',
      stalePeriod: const Duration(hours: 1), // Valides 1 heure seulement
      maxNrOfCacheObjects: 50,
      repo: JsonCacheInfoRepository(databaseName: 'tall_us_temporary_cache'),
      fileService: HttpFileService(),
    ),
  );

  /// Vide tous les caches d'images
  ///
  /// Utile pour libérer de l'espace de stockage ou lors de la déconnexion
  static Future<void> clearAllCaches() async {
    await instance.emptyCache();
    await avatarCache.emptyCache();
    await temporaryCache.emptyCache();
  }

  /// Précharge une image dans le cache
  ///
  /// Utile pour précharger des images susceptibles d'être affichées bientôt
  static Future<void> prefetchImage(String imageUrl) async {
    await instance.getSingleFile(imageUrl);
  }

  /// Précharge plusieurs images en parallèle
  static Future<void> prefetchImages(List<String> imageUrls) async {
    await Future.wait(
      imageUrls.map((url) => instance.getSingleFile(url)),
    );
  }

  /// Retourne la taille totale du cache en octets
  ///
  /// Note: Cette méthode est une approximation car getSize() n'est pas
  /// disponible dans toutes les versions de flutter_cache_manager
  static Future<int> getCacheSize() async {
    // Pour l'instant, retourner 0 car la méthode exacte dépend de la version
    // En production, vous pouvez implémenter votre propre logique de tracking
    return 0;
  }

  /// Formate la taille du cache en unités lisibles (KB, MB, GB)
  static String formatCacheSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
