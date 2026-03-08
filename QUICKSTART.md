# Tall Us - Quick Start Guide

Get your Tall Us dating app running in 5 minutes!

## 📋 Prerequisites

Before you start, make sure you have:

- ✅ **Flutter 3.41+** installed (check with `flutter --version`)
- ✅ **Node.js 18+** installed (check with `node --version`)
- ✅ **Appwrite Cloud account** (free at https://cloud.appwrite.io)
- ✅ **VS Code** or **Android Studio** for development

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Create Appwrite Project (2 min)

1. Go to https://cloud.appwrite.io
2. Click **"Create Project"**
3. Enter project name: `Tall Us`
4. Click **"Create"**

### Step 2: Generate API Key (1 min)

1. In your project dashboard, click **Settings** → **API Keys**
2. Click **"Create API Key"**
3. Name it: `Tall Us Setup`
4. Select these permissions:
   - ✅ **Databases**: Read & Write
   - ✅ **Storage**: Read & Write
   - ✅ **Users**: Read & Write
5. Click **"Create"**
6. **Copy the API Key** (you'll need it in the next step!)

### Step 3: Run Setup Script (2 min)

```bash
# Navigate to scripts directory
cd scripts

# Run the setup
./setup-appwrite.sh
```

**What this does:**
- ✅ Creates database with 9 collections
- ✅ Sets up all attributes and indexes
- ✅ Creates storage bucket for photos
- ✅ Configures permissions

**When prompted:**
1. Copy your **Project ID** from Appwrite Console
2. Paste it when asked
3. Copy your **API Key** (from Step 2)
4. Paste it when asked

That's it! 🎉 Your backend is ready!

---

## 🏃 Run the App

```bash
# Go back to project root
cd ..

# Get Flutter dependencies
flutter pub get

# Run the app
flutter run
```

**Available devices:**
- 💻 **Linux**: Press `l` for Linux desktop
- 🤖 **Android**: Connect phone or run emulator, press `a`
- 🐧 **Web**: Press `w` (limited features)

---

## ✅ Test Your Setup

### 1. Create Account
- Open the app
- Click **"Sign Up"**
- Enter email and password
- Fill in your profile

### 2. Verify Backend
Go to https://cloud.appwrite.io and check:
- **Databases** → Should see 9 collections
- **Storage** → Should see `tall-us-photos` bucket
- **Users** → Should see your new account

### 3. Test Features
- ✅ Swipe through profiles
- ✅ Send a message
- ✅ Check notifications

---

## 🏗️ Project Structure

```
tall_us_app/
├── lib/
│   ├── core/
│   │   ├── appwrite/          # Appwrite configuration
│   │   ├── theme/             # App theme & colors
│   │   └── utils/             # Helpers (logger, etc.)
│   ├── features/
│   │   ├── auth/              # Authentication
│   │   ├── discovery/         # Swipe/discovery
│   │   ├── match/             # Match management
│   │   ├── messaging/         # Real-time chat
│   │   ├── profile/           # User profiles
│   │   ├── swipe/             # Swipe actions
│   │   ├── storage/           # Photo uploads
│   │   └── subscription/      # Premium features
│   └── main.dart              # App entry point
├── scripts/
│   ├── setup-appwrite.js      # Backend setup script
│   ├── setup-appwrite.sh      # Quick setup wrapper
│   └── package.json           # Script dependencies
├── .env.example               # Environment variables template
└── QUICKSTART.md              # This file!
```

---

## 🔧 Environment Variables

Create a `.env` file in the project root:

```bash
# Appwrite Configuration
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_API_KEY=your-api-key

# Database & Storage
APPWRITE_DATABASE_ID=tall_us_db
APPWRITE_STORAGE_BUCKET_ID=tall-us-photos
```

**Where to find these:**
- **Project ID**: Appwrite Console → Settings → General
- **API Key**: Appwrite Console → Settings → API Keys (created in Step 2)

---

## 🎨 Customization

### Change App Name

Edit `lib/main.dart`:
```dart
const String appName = 'Tall Us';
```

### Change Colors

Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color bordeaux = Color(0xFF722F37);  // Main brand color
static const Color navy = Color(0xFF1A2332);      // Secondary color
static const Color gold = Color(0xFFC9A962);      // Accent color
```

### Change Height Requirements

Edit your profile preferences in the app:
- Men: Minimum 180cm (5'11")
- Women: Minimum 178cm (5'10")

---

## 🐛 Troubleshooting

### "Appwrite project not found"
**Solution:**
- Check your `.env` file
- Verify `APPWRITE_PROJECT_ID` matches your project
- No extra spaces or quotes

### "API key permissions denied"
**Solution:**
- Go to Appwrite Console → Settings → API Keys
- Edit your API key
- Ensure these are checked:
  - ✅ Databases: Read & Write
  - ✅ Storage: Read & Write
  - ✅ Users: Read & Write

### "No such table" errors
**Solution:**
```bash
cd scripts
./setup-appwrite.sh
```

### Flutter dependencies errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### App crashes on startup
**Solution:**
- Check that Appwrite is reachable
- Verify `.env` file exists
- Check internet connection

---

## 📱 Next Steps

### 1. Add Real Photos
- Upload profile photos via the app
- Or add manually in Appwrite Storage

### 2. Test with Multiple Users
- Create 2-3 test accounts
- Match them together
- Test real-time messaging

### 3. Enable Premium Features (Optional)
- Set up Stripe account
- Add Stripe keys to `.env`
- See `docs/STRIPE_SETUP.md`

### 4. Deploy to Production
- Build Android APK: `flutter build apk`
- Build iOS: `flutter build ios` (mac only)
- See `docs/DEPLOYMENT.md`

---

## 📚 Documentation

- **Full Setup Guide**: `docs/FULL_SETUP.md`
- **API Reference**: `docs/API_REFERENCE.md`
- **Database Schema**: `docs/DATABASE_SCHEMA.md`
- **Architecture**: `docs/ARCHITECTURE.md`

---

## 🆘 Getting Help

### Appwrite Documentation
- Official Docs: https://appwrite.io/docs
- Discord: https://discord.gg/GSeTUeA
- Twitter: @appwrite

### Flutter Documentation
- Official Docs: https://flutter.dev/docs
- Flutter Widgets: https://api.flutter.dev

### Tall Us Community
- GitHub Issues: https://github.com/your-repo/issues
- Discord: [Coming Soon]

---

## ✨ What's Included

### ✅ Implemented
- [x] User authentication (email/password)
- [x] Profile management
- [x] Swipe-based discovery
- [x] Match detection
- [x] Real-time messaging
- [x] Photo uploads
- [x] Online/offline status
- [x] Super Like with animation

### 🚧 Coming Soon
- [ ] Push notifications (FCM)
- [ ] Premium subscriptions (Stripe)
- [ ] Height verification
- [ ] Advanced filters
- [ ] Voice messages
- [ ] Video chat

---

## 📄 License

MIT License - feel free to use this project for learning or your own dating app!

---

**Built with ❤️ using Flutter and Appwrite**
