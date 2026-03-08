import 'package:dartz/dartz.dart';
import 'package:tall_us/core/error/failures.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';

/// Notification repository interface
abstract class NotificationRepository {
  /// Request push notification permissions
  Future<Either<Failure, bool>> requestPermissions();

  /// Get FCM device token
  Future<Either<Failure, String>> getDeviceToken();

  /// Subscribe to topic (e.g., "matches", "messages")
  Future<Either<Failure, void>> subscribeToTopic(String topic);

  /// Unsubscribe from topic
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic);

  /// Send push notification to a user
  Future<Either<Failure, void>> sendPushNotification({
    required String userId,
    required PushNotificationPayload payload,
  });

  /// Send push notification to multiple users
  Future<Either<Failure, void>> sendBulkPushNotification({
    required List<String> userIds,
    required PushNotificationPayload payload,
  });

  /// Send notification to topic (e.g., all users in a region)
  Future<Either<Failure, void>> sendNotificationToTopic({
    required String topic,
    required PushNotificationPayload payload,
  });

  /// Get user's notification preferences
  Future<Either<Failure, NotificationPreferences>> getPreferences(String userId);

  /// Update notification preferences
  Future<Either<Failure, void>> updatePreferences({
    required String userId,
    required NotificationPreferences preferences,
  });

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead(String userId);

  /// Get notification history
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification(String notificationId);

  /// Clear all notifications
  Future<Either<Failure, void>> clearAll(String userId);
}

/// Notification preferences
class NotificationPreferences {
  final bool enablePush;
  final bool enableEmail;
  final bool newMatches;
  final bool newMessages;
  final bool superLikes;
  final bool profileViews;
  final bool weeklyDigest;
  final bool promotionalEmails;
  final String? email; // User's email address

  const NotificationPreferences({
    this.enablePush = true,
    this.enableEmail = true,
    this.newMatches = true,
    this.newMessages = true,
    this.superLikes = true,
    this.profileViews = false,
    this.weeklyDigest = true,
    this.promotionalEmails = false,
    this.email,
  });

  NotificationPreferences copyWith({
    bool? enablePush,
    bool? enableEmail,
    bool? newMatches,
    bool? newMessages,
    bool? superLikes,
    bool? profileViews,
    bool? weeklyDigest,
    bool? promotionalEmails,
    String? email,
  }) {
    return NotificationPreferences(
      enablePush: enablePush ?? this.enablePush,
      enableEmail: enableEmail ?? this.enableEmail,
      newMatches: newMatches ?? this.newMatches,
      newMessages: newMessages ?? this.newMessages,
      superLikes: superLikes ?? this.superLikes,
      profileViews: profileViews ?? this.profileViews,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      promotionalEmails: promotionalEmails ?? this.promotionalEmails,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enablePush': enablePush,
      'enableEmail': enableEmail,
      'newMatches': newMatches,
      'newMessages': newMessages,
      'superLikes': superLikes,
      'profileViews': profileViews,
      'weeklyDigest': weeklyDigest,
      'promotionalEmails': promotionalEmails,
      'email': email,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enablePush: json['enablePush'] ?? true,
      enableEmail: json['enableEmail'] ?? true,
      newMatches: json['newMatches'] ?? true,
      newMessages: json['newMessages'] ?? true,
      superLikes: json['superLikes'] ?? true,
      profileViews: json['profileViews'] ?? false,
      weeklyDigest: json['weeklyDigest'] ?? true,
      promotionalEmails: json['promotionalEmails'] ?? false,
      email: json['email'],
    );
  }
}
