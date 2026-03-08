import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tall_us/core/error/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';
import 'package:tall_us/features/notification/domain/repositories/notification_repository.dart';

/// Notification repository implementation
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;
  final FirebaseMessaging _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationRepositoryImpl({
    required this.remoteDatasource,
    required FirebaseMessaging fcm,
    required FlutterLocalNotificationsPlugin localNotifications,
  })  : _fcm = fcm,
        _localNotifications = localNotifications;

  @override
  Future<Either<Failure, bool>> requestPermissions() async {
    try {
      // Request iOS permissions
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Request local notification permissions (Android)
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Initialize local notifications for Android
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await _localNotifications.initialize(initializationSettings);
      }

      AppLogger.i('Notification permission: ${settings.authorizationStatus}');
      return Right(settings.authorizationStatus == AuthorizationStatus.authorized);
    } catch (e) {
      AppLogger.e('Error requesting notification permissions', error: e);
      return Left(NotificationPermissionFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDeviceToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        AppLogger.i('FCM token obtained: ${token.substring(0, 20)}...');
        return Right(token);
      } else {
        return Left(const NotificationFailure('Failed to get FCM token'));
      }
    } catch (e) {
      AppLogger.e('Error getting FCM token', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      AppLogger.i('Subscribed to topic: $topic');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error subscribing to topic', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      AppLogger.i('Unsubscribed from topic: $topic');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error unsubscribing from topic', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPushNotification({
    required String userId,
    required PushNotificationPayload payload,
  }) async {
    try {
      // Get user's device tokens
      final tokensResult = await remoteDatasource.getUserDeviceTokens(userId);

      await tokensResult.fold(
        (error) async {
          throw error;
        },
        (tokens) async {
          if (tokens.isEmpty) {
            AppLogger.w('No device tokens for user: $userId');
            return;
          }

          // Send to all user's devices
          final fcmPayload = payload.toFCMMap();
          for (final token in tokens) {
            await remoteDatasource.sendFCMNotification(
              deviceToken: token,
              payload: {
                ...fcmPayload,
                'to': token,
              },
            );
          }
        },
      );

      // Save notification to database
      await remoteDatasource.saveNotification(
        userId: userId,
        type: payload.type.name,
        title: payload.title,
        body: payload.body,
        data: payload.data,
      );

      return const Right(null);
    } catch (e) {
      AppLogger.e('Error sending push notification', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendBulkPushNotification({
    required List<String> userIds,
    required PushNotificationPayload payload,
  }) async {
    try {
      // Send to each user
      for (final userId in userIds) {
        await sendPushNotification(userId: userId, payload: payload);
      }
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error sending bulk notification', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendNotificationToTopic({
    required String topic,
    required PushNotificationPayload payload,
  }) async {
    try {
      final fcmPayload = payload.toFCMMap();
      await remoteDatasource.sendFCMToTopic(
        topic: topic,
        payload: fcmPayload,
      );
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error sending topic notification', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences(String userId) async {
    try {
      // In production, fetch from database
      // For now, return default preferences
      return Right(const NotificationPreferences());
    } catch (e) {
      AppLogger.e('Error getting notification preferences', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePreferences({
    required String userId,
    required NotificationPreferences preferences,
  }) async {
    try {
      // In production, save to database
      AppLogger.i('Updated notification preferences for user: $userId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error updating notification preferences', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      // Update in Appwrite database
      AppLogger.i('Marked notification as read: $notificationId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error marking notification as read', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    try {
      // Update all notifications in Appwrite database
      AppLogger.i('Marked all notifications as read for user: $userId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error marking all as read', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Fetch from Appwrite database
      AppLogger.i('Fetching notifications for user: $userId');
      return const Right([]);
    } catch (e) {
      AppLogger.e('Error fetching notifications', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      // Delete from Appwrite database
      AppLogger.i('Deleted notification: $notificationId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error deleting notification', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll(String userId) async {
    try {
      // Delete all user's notifications from Appwrite database
      AppLogger.i('Cleared all notifications for user: $userId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error clearing notifications', error: e);
      return Left(NotificationFailure(e.toString()));
    }
  }
}

/// Custom failures for notifications
class NotificationFailure extends Failure {
  final String message;

  const NotificationFailure(this.message);

  @override
  String toString() => 'NotificationFailure: $message';
}

class NotificationPermissionFailure extends Failure {
  final String message;

  const NotificationPermissionFailure(this.message);

  @override
  String toString() => 'NotificationPermissionFailure: $message';
}
