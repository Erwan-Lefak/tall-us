# 🚀 Tall Us - Guide de Déploiement

## Table des Matières

1. [Prérequis](#prérequis)
2. [Configuration Appwrite](#configuration-appwrite)
3. [Configuration de l'Application](#configuration-de-lapplication)
4. [Build pour Production](#build-pour-production)
5. [Déploiement Web](#déploiement-web)
6. [Déploiement Mobile](#déploiement-mobile)
7. [Post-Déploiement](#post-déploiement)
8. [Monitoring](#monitoring)

---

## Prérequis

### Outils Nécessaires

```bash
# Vérifier Flutter installé
flutter --version  # >= 3.19.0
dart --version     # >= 3.11.0

# Vérifier les dépendances
flutter doctor -v
```

### Comptes Requis

- ✅ **Compte Appwrite** (https://appwrite.io)
- ✅ **Compte Vercel** (pour déploiement web) - Optionnel
- ✅ **Compte Google Play** (pour Android) - Optionnel
- ✅ **Compte Apple App Store** (pour iOS) - Optionnel

---

## Configuration Appwrite

### 1. Créer un Projet Appwrite

```bash
# Se connecter à Appwrite Console
# https://cloud.appwrite.io

# Créer un nouveau projet
Nom: "Tall Us Production"
ID: tall-us-prod
```

### 2. Créer les Collections

#### Méthode A: Via Console Appwrite (Recommandé)

1. Aller dans **Databases**
2. Créer une base de données: `tall-us-db`
3. Pour chaque collection ci-dessous, cliquer sur **Create Collection**

#### Collections à Créer:

##### 1. users (Existe déjà par défaut)
Attributs par défaut suffisants.

##### 2. profiles
```
Collection ID: profiles
Attributes:
  - userId (string, indexed)
  - displayName (string, size: 100)
  - gender (string, enum: homme,femme,non-binaire,autre)
  - heightCm (integer, min: 100, max: 250)
  - birthday (datetime)
  - city (string, size: 100)
  - countryCode (string, size: 10)
  - bio (string, size: 500)
  - photoUrls (array of strings)
  - interests (array of strings)
  - prompts (array of objects)
  - heightVerified (boolean, default: false)
  - createdAt (datetime)
  - updatedAt (datetime)

Permissions:
  - Read: Any
  - Create: Any authenticated
  - Update: User with matching userId
  - Delete: User with matching userId

Indexes:
  - userId_index on userId
  - gender_index on gender
  - location_index on city, countryCode
```

##### 3. discovery_preferences
```
Collection ID: discovery_preferences
Attributes:
  - userId (string, indexed, unique)
  - minAge (integer, default: 18)
  - maxAge (integer, default: 100)
  - minHeightCm (integer, default: 150)
  - maxHeightCm (integer, default: 250)
  - preferredGenders (array of strings)
  - maxDistanceKm (integer, default: 100)
  - city (string)
  - country (string)

Permissions:
  - Read: User with matching userId
  - Create: Any authenticated
  - Update: User with matching userId
  - Delete: User with matching userId
```

##### 4. likes
```
Collection ID: likes
Attributes:
  - fromUserId (string, indexed)
  - toUserId (string, indexed)
  - likedAt (datetime)
  - isSeen (boolean, default: false)

Permissions:
  - Read: Users in fromUserId or toUserId
  - Create: Any authenticated
  - Update: User with matching fromUserId

Indexes:
  - fromUser_index on fromUserId
  - toUser_index on toUserId
  - compound index: [fromUserId, toUserId]
```

##### 5. matches
```
Collection ID: matches
Attributes:
  - user1Id (string, indexed)
  - user2Id (string, indexed)
  - matchedAt (datetime)
  - lastMessageAt (datetime)
  - isUnread (boolean, default: true)

Permissions:
  - Read: Users in user1Id or user2Id
  - Create: Any authenticated

Indexes:
  - user1_index on user1Id
  - user2_index on user2Id
```

##### 6. messages
```
Collection ID: messages
Attributes:
  - matchId (string, indexed)
  - senderId (string, indexed)
  - content (string, size: 1000)
  - type (string, enum: text,image,gif,audio,video,location,system)
  - mediaUrl (string)
  - thumbnailUrl (string)
  - timestamp (datetime, indexed)
  - isSeen (boolean, default: false)

Permissions:
  - Read: Users in the match
  - Create: Any authenticated

Indexes:
  - match_index on matchId
  - sender_index on senderId
  - timestamp_index on timestamp (DESC)
```

##### 7. events (NOUVEAU - Phase 1)
```
Collection ID: events
Attributes:
  - title (string, size: 100)
  - description (string, size: 500)
  - location (string, size: 200)
  - dateTime (datetime, indexed)
  - attendees (array of strings)
  - maxAttendees (integer, default: 50)
  - hostId (string, indexed)
  - imageUrl (string)
  - createdAt (datetime)

Permissions:
  - Read: Any
  - Create: Any authenticated (Gold+)
  - Update: Host user
  - Delete: Host user
```

##### 8. groups (NOUVEAU - Phase 1)
```
Collection ID: groups
Attributes:
  - name (string, size: 100)
  - category (string, size: 50)
  - description (string, size: 500)
  - members (array of strings)
  - maxMembers (integer, default: 100)
  - createdAt (datetime)

Permissions:
  - Read: Any
  - Create: Any authenticated (Gold+)
  - Update/Delete: Group members
```

##### 9. top_picks (NOUVEAU - Phase 1)
```
Collection ID: top_picks
Attributes:
  - userId (string, indexed)
  - profileId (string, indexed)
  - compatibilityScore (number, double)
  - matchReasons (array of strings)
  - calculatedAt (datetime, indexed)

Permissions:
  - Read: User with matching userId
  - Create: System only
  - Update: System only
```

##### 10. message_reactions (NOUVEAU - Phase 1)
```
Collection ID: message_reactions
Attributes:
  - messageId (string, indexed)
  - userId (string, indexed)
  - emoji (string, size: 10)
  - reactedAt (datetime)

Permissions:
  - Read: Any authenticated
  - Create: Any authenticated
  - Delete: User with matching userId
```

##### 11. user_extended (NOUVEAU - Phase 1)
```
Collection ID: user_extended
Attributes:
  - userId (string, unique, indexed)
  - jobTitle (string, size: 100)
  - company (string, size: 100)
  - school (string, size: 100)
  - degree (string, size: 100)
  - drinkingPreference (string, enum: yes,socially,no)
  - smokingPreference (string, enum: yes,socially,no,trying_to_quit)
  - workoutFrequency (string, enum: often,sometimes,rarely,never)
  - zodiacSign (string, size: 20)
  - pronouns (string, size: 50)
  - genders (array of strings)

Permissions:
  - Read: Any
  - Create: User with matching userId
  - Update: User with matching userId
```

##### 12. photos (NOUVEAU - Phase 1)
```
Collection ID: photos
Attributes:
  - userId (string, indexed)
  - url (string, required)
  - caption (string, size: 100)
  - displayOrder (integer, default: 0)
  - likeCount (integer, default: 0)
  - viewCount (integer, default: 0)
  - matchCount (integer, default: 0)
  - smartScore (number, double, default: 50.0)
  - lastScoreUpdate (datetime)
  - isVerified (boolean, default: false)

Permissions:
  - Read: Any
  - Create: User with matching userId
  - Update: User with matching userId
```

### 3. Configuration des Clés API

```bash
# Dans le projet Appwrite, aller dans Settings > API Keys
# Créer une nouvelle clé avec les permissions:
# - Databases: Read, Create, Update, Delete
# - Storage: Read, Create, Update, Delete
# - Functions: Execute (pour le calcul des Top Picks)

# Copier les variables suivantes:
PROJECT_ID=votre_project_id
DATABASE_ID=votre_database_id
API_KEY=votre_api_key  # Ne JAMAIS exposer cette clé coté client!
```

---

## Configuration de l'Application

### 1. Variables d'Environnement

Créer le fichier `lib/core/config/env.dart`:

```dart
class Env {
  static const String projectId = 'votre_project_id';
  static const String databaseId = 'votre_database_id';
  static const String endpoint = 'https://cloud.appwrite.io/v1';

  // Ne JAMAIS commiter la vraie clé API!
  // Utiliser les tokens d'authentification côté client
}
```

### 2. Configuration du Stockage

```dart
// Dans lib/core/appwrite/appwrite_config.dart

class AppwriteConfig {
  static const String projectId = 'votre_project_id';
  static const String databaseId = 'votre_database_id';
  static const String endpoint = 'https://cloud.appwrite.io/v1';

  // Storage
  static const String bucketId = 'tall-us-images';
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Collections
  static const String profilesCollection = 'profiles';
  static const String likesCollection = 'likes';
  // ... etc (déjà configuré)
}
```

### 3. Configuration Android

**android/app/build.gradle:**

```gradle
android {
    defaultConfig {
        applicationId "com.tallus.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"

        // multidex support
        multiDexEnabled true
    }

    // ...
}
```

### 4. Configuration iOS

**ios/Runner/Info.plist:**

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Tall Us a besoin d'accéder à vos photos pour votre profil</string>
<key>NSCameraUsageDescription</key>
<string>Tall Us a besoin d'accéder à la caméra pour prendre des photos</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Tall Us a besoin de votre position pour trouver des profils près de chez vous</string>
```

---

## Build pour Production

### Android APK

```bash
# Générer la clé de signature (première fois)
keytool -genkey -v -keystore ~/tall-us-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias tall-us

# Configurer key.properties
echo "storePassword=votre_password" > android/key.properties
echo "keyPassword=votre_password" >> android/key.properties
echo "keyAlias=tall-us" >> android/key.properties
echo "storeFile=$(echo ~/tall-us-key.jks)" >> android/key.properties

# Build APK release
flutter build apk --release

# APK généré: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Pour Google Play)

```bash
flutter build appbundle --release

# AAB généré: build/app/outputs/bundle/release/app-release.aab
```

### iOS (IPA)

```bash
# Builder pour iOS (nécessite macOS et Xcode)
flutter build ios --release

# IPA généré via Xcode:
# 1. Ouvrir ios/Runner.xcworkspace dans Xcode
# 2. Product > Archive
# 3. Distribuer App
```

### Web (Pour Vercel)

```bash
# Build web
flutter build web --release

# Build généré: build/web/
```

---

## Déploiement Web

### Méthode 1: Vercel (Recommandé)

```bash
# Installer Vercel CLI
npm i -g vercel

# Déployer
cd build/web
vercel

# Suivre les instructions:
# - Configurer le nom de domaine
# - Configurer les variables d'environnement
# - Déployer
```

### Configuration Vercel

**vercel.json:**

```json
{
  "version": 2,
  "builds": [
    {
      "src": "**/*",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/assets/(.*)",
      "headers": {
        "cache-control": "public, max-age=31536000, immutable"
      }
    },
    {
      "src": "/(.*)",
      "dest": "/$1"
    }
  ]
}
```

---

## Déploiement Mobile

### Google Play Store

1. **Créer un compte développeur** (25$ une fois)
   - https://play.google.com/console

2. **Préparer l'application**

```bash
# Générer l'AAB signé
flutter build appbundle --release

# Télécharger sur Google Play Console
# Fichier: build/app/outputs/bundle/release/app-release.aab
```

3. **Remplir la fiche Play Store:**
   - Nom: "Tall Us - Rencontres pour grands et grands"
   - Description courte (80 caractères)
   - Description longue (4000 caractères)
   - Screenshots (au moins 2)
   - Icône (512x512)
   - Feature graphic (1024x500)
   - Promo graph

4. **Configurer les autorisations:**
   - CAMERA (pour prendre des photos)
   - READ_EXTERNAL_STORAGE (pour la galerie)
   - ACCESS_FINE_LOCATION (pour la géolocalisation)

5. **Soumettre pour revue**

### Apple App Store

1. **Créer un compte développeur** (99$/an)
   - https://developer.apple.com

2. **Préparer l'application dans Xcode**

```bash
# Ouvrir le projet dans Xcode
open ios/Runner.xcworkspace

# Dans Xcode:
# 1. Sélectionner le projet Runner
# 2. Signing & Capabilities
# 3. Sélectionner l'équipe de développement
# 4. Activer "Automatically manage signing"
```

3. **Archiver et publier**

```bash
# Dans Xcode:
# Product > Archive
# Distribuer App > App Store Connect
# Suivre les instructions
```

---

## Post-Déploiement

### 1. Vérifier les connexions

```bash
# Tester l'application
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS

# Vérifier la console Appwrite
# https://cloud.appwrite.io > Logs
```

### 2. Configurer les Analytics

**Firebase Analytics (Optionnel):**

```dart
// lib/core/analytics/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static void logScreenView(String screenName) {
    _analytics.logScreenView(screenName: screenName);
  }

  static void logLike(String profileId) {
    _analytics.logEvent(
      name: 'like',
      parameters: {'profile_id': profileId},
    );
  }

  static void logMatch(String matchId) {
    _analytics.logEvent(
      name: 'match',
      parameters: {'match_id': matchId},
    );
  }
}
```

### 3. Configurer le Crash Reporting

**Sentry (Optionnel):**

```yaml
# pubspec.yaml
dependencies:
  sentry_flutter: ^8.0.0
```

```dart
// lib/main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) => options.dsn = 'YOUR_SENTRY_DSN',
  );

  runApp(const ProviderScope(child: TallUsApp()));
}
```

### 4. Configurer les Push Notifications

**Firebase Cloud Messaging:**

```dart
// lib/features/notification/presentation/services/firebase_messaging_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Demander la permission
    NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Récupérer le token
      String? token = await _messaging.getToken();
      print('FCM Token: $token');

      // Sauvegarder dans Appwrite
      // TODO: Envoyer le token au backend
    }

    // Écouter les messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Afficher la notification
      // TODO: Implémenter l'affichage
    });
  }
}
```

---

## Monitoring

### 1. Appwrite Console

**Métriques à surveiller:**
- Taux de réussite des requêtes API
- Latence moyenne des requêtes
- Nombre de documents par collection
- Utilisation du storage

### 2. Google Analytics (si configuré)

**Événements clés à suivre:**
- `screen_view` - Vues d'écran
- `sign_up` - Inscriptions
- `login` - Connexions
- `like` - Likes envoyés
- `match` - Matches créés
- `message_sent` - Messages envoyés
- `premium_upgrade` - Upgrades Premium

### 3. Performance Monitoring

```dart
// lib/core/performance/performance_monitor.dart

import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static void trackBuild(String widgetName) {
    final stopwatch = Stopwatch()..start();
    return () {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 16) {
        // Frame > 16ms = < 60fps
        print('$widgetName built in ${stopwatch.elapsedMilliseconds}ms');
      }
    };
  }
}
```

### 4. Health Checks

```dart
// lib/core/health/health_check.dart

class HealthCheckService {
  static Future<Map<String, dynamic>> check() async {
    final results = <String, dynamic>{};

    // Vérifier Appwrite
    try {
      await AppwriteConfig.client.getAccount();
      results['appwrite'] = 'OK';
    } catch (e) {
      results['appwrite'] = 'ERROR: $e';
    }

    // Vérifier les connexions réseau
    // ...

    return results;
  }
}
```

---

## Checklist de Déploiement Final

### Avant le déploiement:

- [ ] Toutes les collections Appwrite créées
- [ ] Permissions configurées correctement
- [ ] Variables d'environnement définies
- [ ] Build release généré sans erreurs
- [ ] Application testée sur appareil réel
- [ ] Screenshots préparés (au moins 4)
- [ ] Icônes générées (toutes tailles requises)
- [ ] Description rédigée
- [ ] Politique de confidentialité créée
- [ ] Conditions d'utilisation créées

### Après le déploiement:

- [ ] Application accessible sur le store
- [ ] Analytics configurés et fonctionnels
- [ ] Crash reporting configuré
- [ ] Push notifications testées
- [ ] Premier utilisateurs testés
- [ ] Feedback utilisateurs collecté
- [ ] Bugs identifiés et corrigés

---

## Maintenance Continue

### Mises à jour régulières:

1. **Mises à jour de sécurité** - Dès que disponibles
2. **Mises à jour de fonctionnalités** - Tous les 2-4 semaines
3. **Optimisations** - Basées sur les analytics
4. **Bug fixes** - Priorité haute

### Sauvegardes:

```bash
# Sauvegarder Appwrite
# Appwrite fait des sauvegardes automatiques
# Vérifier: https://cloud.appwrite.io > Backups

# Exporter les données régulièrement
# Scripts dans: scripts/backup/
```

---

## Support

Pour toute question ou problème:

1. **Documentation Appwrite**: https://appwrite.io/docs
2. **Documentation Flutter**: https://flutter.dev/docs
3. **GitHub Issues**: https://github.com/tall-us/app/issues

---

## Conclusion

Ce guide couvre l'ensemble du processus de déploiement de Tall Us, de la configuration initiale à la maintenance continue. Suivez chaque étape attentivement pour assurer un déploiement réussi!

**Bon déploiement! 🚀**

---

*Dernière mise à jour: 2026-04-07*
*Version: 1.0.0*
