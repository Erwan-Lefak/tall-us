/// App Constants
///
/// Centralized constants for Tall Us app
class AppConstants {
  // App Info
  static const String appName = 'Tall Us';
  static const String appTagline = "L'amour vu d'en haut";
  static const String appVersion = '1.0.0';

  // Height Requirements (in cm)
  static const int minHeightMale = 180; // Men: 180cm and above
  static const int minHeightFemale = 178; // Women: 178cm and above
  static const int maxHeight = 250; // Max height for UI purposes

  // Age Requirements
  static const int minAge = 18;
  static const int maxAge = 100;

  // Distance
  static const int defaultDistanceKm = 50;
  static const int maxDistanceKm = 500;

  // Media
  static const int maxPhotosPerProfile = 6;
  static const int maxPhotoSizeMB = 5;
  static const int maxPhotoFileSize = maxPhotoSizeMB * 1024 * 1024;

  // Supported photo formats
  static const List<String> supportedPhotoFormats = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

  // Messages
  static const int maxMessageLength = 1000;
  static const int messageDebounceMs = 300;

  // Bio
  static const int minBioLength = 20;
  static const int maxBioLength = 500;

  // Name
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Pagination
  static const int discoveryPageSize = 20;
  static const int messagesPageSize = 50;
  static const int matchesPageSize = 20;

  // Swipes
  static const int freeWeeklySwipes = 15;
  static const int freeDailySuperLikes = 1;
  static const int premiumDailySuperLikes = 5;

  // Subscription
  static const double monthlyPrice = 14.99;
  static const double yearlyPrice = 119.99;
  static const int trialDays = 7;

  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Debounce Times
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration typingDebounce = Duration(milliseconds: 300);
  static const Duration scrollDebounce = Duration(milliseconds: 100);

  // Timeout Durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 2);

  // Cache
  static const int maxCacheSizeMB = 50;
  static const Duration profileCacheDuration = Duration(hours: 1);
  static const Duration photosCacheDuration = Duration(days: 7);

  // Presence
  static const Duration onlineThreshold = Duration(minutes: 5);
  static const Duration awayThreshold = Duration(minutes: 15);
  static const Duration heartbeatInterval = Duration(seconds: 30);

  // Notifications - quiet hours
  static const int quietHoursStartHour = 22; // 10 PM
  static const int quietHoursEndHour = 7; // 7 AM

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String namePattern = r'^[a-zA-Zà-üÀ-Ü\s-]{2,50}$';

  // Country Code (default)
  static const String defaultCountryCode = 'FR';

  // Pagination keys
  static const String pageKey = 'page';
  static const String limitKey = 'limit';

  // Shared Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // API
  static const int apiRetryAttempts = 3;
  static const Duration apiRetryDelay = Duration(seconds: 2);

  // Assets
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String logoPath = 'assets/images/logo.png';

  // Social Links
  static const String privacyPolicyUrl = 'https://tallus.com/privacy';
  static const String termsOfServiceUrl = 'https://tallus.com/terms';
  static const String supportEmail = 'support@tallus.com';

  // Maximum distance for location-based matching (in km)
  static const int maxMatchingDistance = 100;
}
