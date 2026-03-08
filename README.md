# Tall Us - Dating App for Tall People

Dating app exclusively for tall people (≥180cm men, ≥178cm women).

## 🎯 Project Overview

**Tagline:** See love from above

**Tech Stack:**
- **Flutter 3.41+** with Impeller rendering
- **Appwrite Cloud** (Backend-as-a-Service)
- **Riverpod 3.0** (State Management)
- **Firebase** (Push Notifications)
- **Clean Architecture** (Domain-driven design)

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities and configuration
│   ├── appwrite/           # Appwrite client & config
│   ├── auth/               # Authentication utilities
│   ├── config/             # App configuration
│   ├── errors/             # Error handling (Failures)
│   ├── theme/              # App theme (colors, typography)
│   ├── utils/              # Utilities (Logger, etc.)
│   └── constants/          # App constants
│
├── features/               # Feature modules (Clean Architecture)
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   │   ├── datasources/# API/Local sources
│   │   │   ├── models/     # Data models
│   │   │   └── repositories/# Repository implementations
│   │   ├── domain/         # Business logic
│   │   │   ├── entities/   # Business entities
│   │   │   ├── repositories/# Repository interfaces
│   │   │   └── usecases/   # Business logic (use cases)
│   │   └── presentation/   # UI layer
│   │       ├── providers/  # Riverpod providers
│   │       ├── screens/    # Screens
│   │       └── widgets/    # Reusable widgets
│   │
│   ├── profile/            # User profile feature
│   ├── match/              # Match feature
│   ├── chat/               # Chat feature
│   └── subscription/       # Subscription feature
│
├── shared/                 # Shared widgets
│   └── widgets/            # Common widgets
│
└── main.dart               # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.41+
- Dart 3.4+
- Appwrite Cloud account
- Firebase project (for push notifications)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tall_us_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed, Riverpod, JSON serialization)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure environment variables**

   Create `.env` file in project root:
   ```env
   APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
   APPWRITE_PROJECT_ID=your-project-id
   APPWRITE_DATABASE_ID=your-database-id
   JWT_SECRET=your-jwt-secret
   GOOGLE_CLIENT_ID=your-google-client-id
   APPLE_CLIENT_ID=your-apple-client-id
   ```

5. **Run the app**

   ```bash
   # Development mode
   flutter run

   # With specific device
   flutter run -d <device-id>

   # Release mode
   flutter run --release
   ```

## 📝 Features

### Implemented ✅
- ✅ Clean Architecture setup
- ✅ Appwrite Cloud integration
- ✅ Theme system with brand colors
- ✅ Error handling (Failures)
- ✅ Logging system
- ✅ State management (Riverpod)
- ✅ Splash screen

### In Progress 🚧
- 🚧 Authentication flow
- 🚧 User profile management
- 🚧 Discovery feed
- 🚧 Matching system
- 🚧 Real-time chat

### Planned 📋
- 📋 Push notifications (Firebase)
- 📋 Subscription (Stripe)
- 📋 Group chat
- 📋 Video calls
- 📋 Advanced filters

## 🎨 Design System

### Colors
- **Bordeaux:** `#722F37` (Primary)
- **Navy:** `#1A2332` (Secondary)
- **Gold:** `#C9A962` (Accent)
- **Off-white:** `#FAF8F5` (Surface)

### Typography
- **Headings:** Playfair Display
- **Body:** Inter

### Components
See `lib/core/theme/app_theme.dart` for complete theme configuration.

## 🔧 Configuration

### Appwrite Collections

1. **users** - User accounts
2. **profiles** - User profiles with location
3. **photos** - Profile photos
4. **swipes** - Like/Pass interactions
5. **matches** - Mutual matches
6. **messages** - Chat messages
7. **subscriptions** - Premium subscriptions
8. **presence** - Online status
9. **notifications** - Push notifications

See `specs/Database-API-Backend.md` for complete schema.

## 📱 Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart
```

## 📚 Documentation

- **Product Requirements:** `specs/PRD-Tall-Us.md`
- **Technical Architecture:** `specs/Technical-Architecture.md`
- **Design System:** `specs/Design-System.md`
- **Authentication:** `specs/Auth-User-Management.md`
- **Payments:** `specs/Stripe-Payments-Subscriptions.md`
- **Real-Time:** `specs/Real-Time-Features.md`
- **Database & API:** `specs/Database-API-Backend.md`
- **Postman Collection:** `specs/Postman-Collection.json`

## 🐛 Known Issues

- [ ] Initial setup in progress
- [ ] Firebase configuration needed
- [ ] Appwrite project setup required

## 🤝 Contributing

1. Create feature branch
2. Make your changes
3. Run tests
4. Submit pull request

## 📄 License

Copyright © 2026 Tall Us. All rights reserved.

## 👥 Team

Built with ❤️ by the Tall Us team.

---

**See love from above** 💕
