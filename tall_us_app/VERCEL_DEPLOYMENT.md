# 🚀 Déploiement sur Vercel - Tall Us

## Prérequis

- Compte Vercel gratuit ([vercel.com](https://vercel.com))
- CLI Vercel installé : `npm i -g vercel`
- Flutter installé sur ta machine

---

## 📋 Étapes de déploiement

### 1. Préparer le projet

```bash
cd /home/erwan/Documents/Projets/Tall\ Us/tall_us_app
```

### 2. Se connecter à Vercel

```bash
vercel login
```

### 3. Déployer sur Vercel

```bash
vercel
```

Vercel va te poser quelques questions :
- **Set up and deploy?** → Continue
- **Which scope?** → Choisis ton compte
- **Link to existing project?** → No
- **Project name?** → `tall-us-web` (ou autre nom)
- **In which directory is your code located?** → `.` (répertoire courant)
- **Want to override the settings?** → Yes
- **Override Build Command?** → `flutter build web --release`
- **Override Output Directory?** → `build/web`

---

## ⚙️ Limitations connues

**Flutter Web sur Vercel :**

| Fonctionnalité | Statut | Notes |
|----------------|--------|-------|
| Landing Page | ✅ Fonctionne | Pages statiques |
| Authentification | ⚠️ Limité | Firebase Auth fonctionne |
| Notifications Push | ❌ Ne fonctionne pas | WebSockets non supportés |
| Stockage local | ⚠️ Limité | `flutter_secure_storage` partiel |
| Géolocalisation | ⚠️ Limité | Fonctionne partiel |

**Solution pour limitations :**
- Utiliser **Firebase Authentication** pour le web
- Utiliser **IndexedDB** ou **LocalStorage** au lieu de `flutter_secure_storage`
- Les notifications push ne sont pas disponibles sur Flutter Web (normale)

---

## 🔧️ Configuration personnalisée

### Variables d'environnement Vercel

Dans Vercel Dashboard → Settings → Environment Variables, ajoute :

```
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key_here
NEXT_PUBLIC_APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1
NEXT_PUBLIC_APPWRITE_PROJECT_ID=69a85fa1000386efe620
```

### Custom Domain

1. Dans Vercel Dashboard → Settings → Domains
2. Ajoute ton domaine : `tallus.app` (ou autre)
3. Configure DNS selon instructions Vercel

---

## 🎯 Recommandations de production

### Option 1 : Vercel (Web public uniquement)
```
✅ Landing Page publique
✅ Authentification web
✅ Profil public
❌ Mobile app
```

### Option 2 : Hybride (Recommandé)
```
✅ Vercel pour le Web (landing page + auth web)
✅ Firebase Hosting pour le Mobile (PWA)
✅ App Store/Play Store pour l'app native
✅ Appwrite Cloud pour le backend commun
```

### Option 3 : Full Vercel (Non recommandé)
```
❌ Vercel pour TOUT
⚠️ Limitations de performance
⚠️ Fonctionnalités manquantes
```

---

## 📊 Monitoring & Analytics

Vercel fournit automatiquement :
- **Analytics** temps réel
- **Monitoring** des erreurs
- **Performance** tracking
- **Deployment logs** détaillés

Activer dans : `vercel.com → Project → Analytics`

---

## 🔄 Déploiement CI/CD (Optionnel)

### GitHub Actions

Crée `.github/workflows/deploy.yml` :

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      - run: flutter pub get
      - run: flutter build web --release
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          working-directory: ./build/web
```

---

## 🔐 Sécurité

Le fichier `vercel.json` inclut déjà :

- ✅ **X-Frame-Options** : Protection contre clickjacking
- ✅ **X-Content-Type-Options** : Protection contre sniffing
- ✅ **X-XSS-Protection** : Protection XSS
- ✅ **Content-Security-Policy** : Politique de contenu stricte
- ✅ **Referrer-Policy** : Protection contre CSRF

---

## 📱 PWA (Progressive Web App)

Pour convertir en PWA (installable) :

1. Modifier `web/manifest.json` :

```json
{
  "short_name": "Tall Us",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#722F37",
  "theme_color": "#722F37"
}
```

2. Ajouter service worker (optionnel pour offline)

---

## ✅ Checklist avant le déploiement

- [ ] Build web réussi (`flutter build web --release`)
- [ ] Fichier `vercel.json` configuré
- [ ] Variables d'environnement définies
- [ ] Domaine custom configuré (optionnel)
- [ ] Analytics activés
- [ ] HTTPS activé (automatique sur Vercel)

---

## 🆘 Support

- **Vercel Documentation** : [vercel.com/docs](https://vercel.com/docs)
- **Flutter Web Guide** : [docs.flutter.dev/platform-web](https://docs.flutter.dev/platform-integration/web)
- **Vercel CLI** : `vercel --help`

---

## 🎉 Après le déploiement

Une fois déployé, ton app sera accessible sur :
- **URL Vercel** : `https://tall-us-web.vercel.app`
- **Domaine custom** : `https://tallus.app` (si configuré)
