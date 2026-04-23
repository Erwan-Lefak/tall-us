/// Appwrite Configuration
///
/// Centralized configuration for Appwrite Cloud services
/// Update these values with your Appwrite Cloud project credentials
class AppwriteConfig {
  // Appwrite Cloud Endpoint
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';

  // Project ID - Get from Appwrite Console → Settings → General
  static const String projectId = '69a85fa1000386efe620';

  // Database ID - Get from Appwrite Console → Databases
  static const String databaseId = 'tall_us_db';

  // Storage Bucket IDs
  static const String photosBucketId = 'tall-us-photos';
  static const String avatarsBucketId = 'tall-us-avatars';

  // Collection IDs - Get from Appwrite Console → Databases → Collections
  static const String usersCollection = 'users';
  static const String profilesCollection = 'profiles';
  static const String preferencesCollection = 'preferences';
  static const String photosCollection = 'photos';
  static const String swipesCollection = 'swipes';
  static const String matchesCollection = 'matches';
  static const String messagesCollection = 'messages';
  static const String subscriptionsCollection = 'subscriptions';
  static const String presenceCollection = 'presence';
  static const String notificationsCollection = 'notifications';
  static const String verificationsCollection = 'verifications';

  // New collections for Phase 1 features
  static const String eventsCollection = 'events';
  static const String groupsCollection = 'groups';
  static const String likesCollection = 'likes';
  static const String topPicksCollection = 'top_picks';
  static const String messageReactionsCollection = 'message_reactions';
  static const String userExtendedCollection = 'user_extended';

  // JWT Configuration
  static const String jwtSecret = String.fromEnvironment('JWT_SECRET');
  static const String jwtRefreshSecret =
      String.fromEnvironment('JWT_REFRESH_SECRET');

  // OAuth Providers - Client IDs
  static const String googleClientId =
      String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String appleClientId = String.fromEnvironment('APPLE_CLIENT_ID');

  // Rate Limits
  static const int maxLoginAttempts = 5;
  static const int loginLockoutMinutes = 15;
  static const int maxMessagesPerMinute = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
}
