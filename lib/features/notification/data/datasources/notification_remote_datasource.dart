import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:appwrite/appwrite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tall_us/core/utils/logger.dart';

/// Remote datasource for notifications
/// Integrates Firebase Cloud Messaging (FCM) and Courier for emails
class NotificationRemoteDatasource {
  final Databases _database;
  final String _fcmServerKey;
  final String _courierAuthToken;
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationRemoteDatasource({
    required Databases database,
    required String fcmServerKey,
    required String courierAuthToken,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _database = database,
        _fcmServerKey = fcmServerKey,
        _courierAuthToken = courierAuthToken,
        _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin();

  /// Initialize Android notification channels
  Future<void> initializeChannels() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'tall_us_notifications',
        'Tall Us Notifications',
        description: 'Notifications for Tall Us app',
        importance: Importance.high,
        enableVibration: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      AppLogger.i('Android notification channel created');
    }
  }

  /// Send FCM push notification to a specific device token
  Future<Either<Object, void>> sendFCMNotification({
    required String deviceToken,
    required Map<String, dynamic> payload,
  }) async {
    try {
      AppLogger.i('Sending FCM notification to token: ${deviceToken.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        AppLogger.i('FCM notification sent successfully');
        return const Right(null);
      } else {
        AppLogger.e('FCM notification failed: ${response.statusCode} - ${response.body}');
        return Left(Exception('FCM notification failed: ${response.statusCode}'));
      }
    } catch (e) {
      AppLogger.e('Error sending FCM notification', error: e);
      return Left(e);
    }
  }

  /// Send FCM notification to a topic
  Future<Either<Object, void>> sendFCMToTopic({
    required String topic,
    required Map<String, dynamic> payload,
  }) async {
    try {
      AppLogger.i('Sending FCM notification to topic: $topic');

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
        body: jsonEncode({
          ...payload,
          'to': '/topics/$topic',
        }),
      );

      if (response.statusCode == 200) {
        AppLogger.i('FCM topic notification sent successfully');
        return const Right(null);
      } else {
        AppLogger.e('FCM topic notification failed: ${response.statusCode}');
        return Left(Exception('FCM topic notification failed'));
      }
    } catch (e) {
      AppLogger.e('Error sending FCM topic notification', error: e);
      return Left(e);
    }
  }

  /// Send email notification via Courier
  Future<Either<Object, void>> sendEmailNotification({
    required String email,
    required String template,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.i('Sending email notification to: $email');

      final response = await http.post(
        Uri.parse('https://api.courier.com/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_courierAuthToken',
        },
        body: jsonEncode({
          'event': template,
          'recipient': email,
          'data': data,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        AppLogger.i('Email notification sent successfully');
        return const Right(null);
      } else {
        AppLogger.e('Email notification failed: ${response.statusCode}');
        return Left(Exception('Email notification failed'));
      }
    } catch (e) {
      AppLogger.e('Error sending email notification', error: e);
      return Left(e);
    }
  }

  /// Save notification to database
  Future<Either<Object, void>> saveNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notificationId = 'notif_${DateTime.now().millisecondsSinceEpoch}';

      await _database.createDocument(
        databaseId: 'tall_us_db',
        collectionId: 'notifications',
        documentId: notificationId,
        data: {
          'user_id': userId,
          'type': type,
          'title': title,
          'body': body,
          'data': data != null ? jsonEncode(data) : null,
          'read': false,
        },
        permissions: [
          // User can read their own notifications
          'read("user:$userId")',
          'update("user:$userId")',
        ],
      );

      AppLogger.i('Notification saved to database: $notificationId');
      return const Right(null);
    } catch (e) {
      AppLogger.e('Error saving notification', error: e);
      return Left(e);
    }
  }

  /// Get user's FCM device tokens
  Future<Either<Object, List<String>>> getUserDeviceTokens(String userId) async {
    try {
      // In production, store device tokens in a collection
      // For now, return empty list (tokens are managed client-side)
      AppLogger.i('Fetching device tokens for user: $userId');
      return const Right([]);
    } catch (e) {
      AppLogger.e('Error fetching device tokens', error: e);
      return Left(e);
    }
  }

  /// Subscribe to FCM topic
  Future<Either<Object, void>> subscribeToTopic({
    required String topic,
    required String deviceToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://iid.googleapis.com/iid/v1/$deviceToken/rel/topics/$topic'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_fcmServerKey',
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Subscribed to topic: $topic');
        return const Right(null);
      } else {
        AppLogger.e('Failed to subscribe to topic: ${response.statusCode}');
        return Left(Exception('Failed to subscribe to topic'));
      }
    } catch (e) {
      AppLogger.e('Error subscribing to topic', error: e);
      return Left(e);
    }
  }
}
