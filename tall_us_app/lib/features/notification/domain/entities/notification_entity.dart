import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';
part 'notification_entity.g.dart';

/// Notification types in Tall Us app
enum NotificationType {
  /// New match created
  newMatch,

  /// New message received
  newMessage,

  /// Someone super-liked you
  superLike,

  /// Someone viewed your profile
  profileView,

  /// Weekly digest of activity
  weeklyDigest,

  /// Trial expiring soon
  trialExpiration,

  /// Subscription renewed
  subscriptionRenewed,

  /// Subscription canceled
  subscriptionCanceled,

  /// Profile approved
  profileApproved,

  /// Photo verification completed
  photoVerified,
}

/// Notification entity
@freezed
class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationEntity;

  factory NotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntityFromJson(json);
}

/// Push notification payload (for FCM)
class PushNotificationPayload {
  final String title;
  final String body;
  final NotificationType type;
  final String? userId;
  final Map<String, dynamic>? data;

  const PushNotificationPayload({
    required this.title,
    required this.body,
    required this.type,
    this.userId,
    this.data,
  });

  /// Convert to FCM format
  Map<String, dynamic> toFCMMap() {
    return {
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
        'badge': '1',
      },
      'data': {
        'type': type.name,
        'userId': userId,
        ...?data,
      },
      'android': {
        'priority': 'high',
        'notification': {
          'channel_id': 'tall_us_notifications',
          'sound': 'default',
        },
      },
      'ios': {
        'badge': 1,
        'sound': 'default',
      },
    };
  }

  /// Create notification for new match
  factory PushNotificationPayload.newMatch({
    required String matchedUserName,
    required String matchId,
  }) {
    return PushNotificationPayload(
      title: 'New Match! 🎉',
      body: 'You matched with $matchedUserName',
      type: NotificationType.newMatch,
      data: {
        'matchId': matchId,
        'matchedUserName': matchedUserName,
      },
    );
  }

  /// Create notification for new message
  factory PushNotificationPayload.newMessage({
    required String senderName,
    required String matchId,
    required String messageId,
    String? messagePreview,
  }) {
    return PushNotificationPayload(
      title: senderName,
      body: messagePreview ?? 'Sent you a message 💬',
      type: NotificationType.newMessage,
      data: {
        'matchId': matchId,
        'messageId': messageId,
        'senderName': senderName,
      },
    );
  }

  /// Create notification for super like
  factory PushNotificationPayload.superLike({
    required String superLikerName,
    required String profileId,
  }) {
    return PushNotificationPayload(
      title: 'Super Like! ⭐',
      body: '$superLikerName really likes you!',
      type: NotificationType.superLike,
      data: {
        'superLikerName': superLikerName,
        'profileId': profileId,
      },
    );
  }

  /// Create notification for trial expiration
  factory PushNotificationPayload.trialExpiring({
    required int daysRemaining,
  }) {
    return PushNotificationPayload(
      title: 'Your Trial is Ending',
      body: 'You have $daysRemaining days left on your free trial',
      type: NotificationType.trialExpiration,
      data: {
        'daysRemaining': daysRemaining.toString(),
      },
    );
  }

  /// Create notification for weekly digest
  factory PushNotificationPayload.weeklyDigest({
    required int newMatches,
    required int newMessages,
  }) {
    return PushNotificationPayload(
      title: 'Your Weekly Summary 📊',
      body: 'You had $newMatches new matches and $newMessages messages this week!',
      type: NotificationType.weeklyDigest,
      data: {
        'newMatches': newMatches.toString(),
        'newMessages': newMessages.toString(),
      },
    );
  }
}
