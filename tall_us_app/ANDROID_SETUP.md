# Tall Us — Setup Android (build APK)

Guide pas-à-pas pour builder l'app sur Android. Le code et la config Android
sont déjà prêts ; il reste à installer le toolchain sur ta machine et à déposer
les fichiers de service (Firebase). iOS nécessite un Mac + Xcode (non couvert
ici).

## 0. Prérequis déjà en place dans ce repo
- Dossier `android/` scaffoldé → applicationId **`com.tallus.tall_us_app`**.
- `android/app/src/main/AndroidManifest.xml` : permissions caméra, photos,
  Internet, notifications (POST_NOTIFICATIONS), VIBRATE, WAKE_LOCK.
- `android/app/build.gradle.kts` : `minSdk = 23`, plugin Firebase prêt
  (commenté jusqu'à l'ajout de `google-services.json`).
- Code Dart cross-platform (import conditionnel `dart:html`, gardes `kIsWeb`).

## 1. Installer le toolchain (une seule fois)
1. Installe **Android Studio** : https://developer.android.com/studio
   - Au premier lancement, il installe l'**Android SDK** + un **JDK 17+**.
2. Vérifie :
   ```bash
   flutter doctor
   ```
   → "Android toolchain" doit être ✓.
3. Accepte les licences SDK :
   ```bash
   flutter doctor --android-licenses
   ```
   (tape `y` à chaque).

> Si Flutter ne trouve pas le SDK :
> `flutter config --android-sdk="C:\Users\<toi>\AppData\Local\Android\Sdk"`
> Et pour Java (Gradle veut Java 17–25) :
> `flutter config --jdk-dir="C:\Program Files\Java\jdk-17"` (adapter le chemin).

## 2. Build debug (pour tester vite)
```bash
flutter run -d <device-id>      # ou un émulateur lancé depuis Android Studio
```
Build debug APK sans signature :
```bash
flutter build apk --debug
```
→ APK dans `build/app/outputs/flutter-apk/app-debug.apk`.

## 3. (Optionnel mais recommandé) Push notifications — Firebase
Seulement si tu actives les notifications push (FCM) :

1. https://console.firebase.google.com → **Add project** (réutilise ton projet).
2. **Add app → Android** → package name **`com.tallus.tall_us_app`**
   (doit correspondre exactement à l'`applicationId`).
3. Télécharge **`google-services.json`** et dépose-le dans **`android/app/`**.
4. Dans **`android/app/build.gradle.kts`**, décommente la ligne :
   ```kotlin
   id("com.google.gms.google-services")
   ```
   (le plugin est déjà déclaré dans `android/settings.gradle.kts`).
5. Dans `lib/main.dart`, décommente l'init Firebase :
   ```dart
   await _initializeFirebase();
   ```
6. Rebuild.

## 4. (Optionnel) Sign-in Google
1. Google Cloud Console → **APIs & Services → Credentials** → crée un
   **OAuth client ID Android** avec le package `com.tallus.tall_us_app` et
   l'empreinte SHA-1 de ton keystore debug :
   ```bash
   cd android
   ./gradlew signingReport        # copie la ligne SHA1 (variant: debug)
   ```
2. Le `google_sign_in` Flutter se configure ensuite côté code (pas de fichier
   supplémentaire Android pour le flux natif). Le SHA-1 doit être enregistré
   dans Google Cloud pour que la connexion fonctionne.

## 5. Sign-in Apple
- Configure un **Services ID** + **Sign in with Apple** dans
  https://developer.apple.com. Côté Android, `sign_in_with_apple` ouvre un
  navigateur (web flow) — pas de config Android native supplémentaire.

## 6. Build release (APK distribuable)
```bash
flutter build apk --release
```
→ `build/app/outputs/flutter-apk/app-release.apk`.

Pour signer une release "production" (keystore dédié) :
```bash
keytool -genkey -v -keystore tallus.keystore -alias tallus \
  -keyalg RSA -keysize 2048 -validity 10000
```
Puis déclare le `signingConfig` release dans `android/app/build.gradle.kts`
(décommente/remplace le bloc `release { signingConfig = ... }`). À ne faire
que pour un envoi Play Store.

## 7. Appwrite — callback de vérification email (deep link)
L'app utilise `APP_URL` (via `run_web.ps1` / `--dart-define`) pour la
callback email. Sur mobile, remplace par un **custom scheme** ou universal
link, ex : `tallus://auth/verify-email`. À régler côté console Appwrite
(Auth → verification URL) + `APP_URL` au build mobile.

## 8. Soucis courants
| Symptôme | Fix |
|---|---|
| `Unable to locate Android SDK` | Installe Android Studio + `flutter config --android-sdk=...` |
| Gradle erreur de version Java | `flutter config --jdk-dir=<JDK17>` |
| `minSdk` trop bas pour un plugin | déjà `23` ici ; monter si message d'erreur |
| `google-services.json missing` | tu as décommenté le plugin sans déposer le fichier → remets en commentaire ou ajoute le json |
| Camera crash au runtime | permissions auto-demandées par `image_picker` ; vérifie l'autorisation dans les réglages de l'app |

## 9. iOS (rappel)
Nécessite **macOS + Xcode**. Sur Mac :
```bash
flutter create --platforms=ios --org com.tallus .
```
puis `Info.plist` (NSCameraUsageDescription, NSPhotoLibraryUsageDescription),
Firebase `GoogleService-Info.plist`, et `flutter build ios`.
