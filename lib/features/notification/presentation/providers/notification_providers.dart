import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:tall_us/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:tall_us/features/notification/data/services/firebase_messaging_service.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';
import 'package:tall_us/features/notification/domain/repositories/notification_repository.dart';
import 'package:tall_us/core/utils/logger.dart';

/// Provider for Firebase Messaging
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

/// Provider for Local Notifications
final localNotificationsProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

/// Provider for Firebase Messaging Service
final firebaseMessagingServiceProvider =
    Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService(
    fcm: ref.watch(firebaseMessagingProvider),
    localNotifications: ref.watch(localNotificationsProvider),
  );
});

/// Provider for Notification Remote Datasource
final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
  final fcmServerKey =
      const String.fromEnvironment('FCM_SERVER_KEY', defaultValue: '');
  final courierAuthToken =
      const String.fromEnvironment('COURIER_AUTH_TOKEN', defaultValue: '');

  return NotificationRemoteDatasource(
    database: ref.watch(databasesProvider),
    fcmServerKey: fcmServerKey,
    courierAuthToken: courierAuthToken,
  );
});

/// Provider for Notification Repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDatasource: ref.watch(notificationRemoteDatasourceProvider),
    fcm: ref.watch(firebaseMessagingProvider),
    localNotifications: ref.watch(localNotificationsProvider),
  );
});

/// Provider for notification permissions state
final notificationPermissionsProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final result = await repository.requestPermissions();
  return result.fold(
    (failure) {
      AppLogger.e('Notification permission request failed',
          error: failure.toString());
      return false;
    },
    (granted) => granted,
  );
});

/// Provider for FCM device token
final deviceTokenProvider = FutureProvider.autoDispose<String>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final result = await repository.getDeviceToken();

  return result.fold(
    (failure) {
      AppLogger.e('Failed to get device token', error: failure.toString());
      throw Exception('Failed to get device token');
    },
    (token) => token,
  );
});

/// Notification service state
class NotificationServiceState {
  final bool isEnabled;
  final bool isLoading;
  final String? deviceToken;
  final String? error;

  const NotificationServiceState({
    this.isEnabled = false,
    this.isLoading = false,
    this.deviceToken,
    this.error,
  });

  NotificationServiceState copyWith({
    bool? isEnabled,
    bool? isLoading,
    String? deviceToken,
    String? error,
  }) {
    return NotificationServiceState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      deviceToken: deviceToken ?? this.deviceToken,
      error: error ?? this.error,
    );
  }
}

/// Notification service notifier
class NotificationServiceNotifier
    extends StateNotifier<NotificationServiceState> {
  final NotificationRepository _repository;
  final FirebaseMessagingService _messagingService;

  NotificationServiceNotifier(this._repository, this._messagingService)
      : super(const NotificationServiceState());

  /// Initialize notifications
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    // Initialize Firebase messaging service
    await _messagingService.initialize();

    // Request permissions
    final permissionsResult = await _repository.requestPermissions();
    permissionsResult.fold(
      (failure) {
        AppLogger.e('Failed to request permissions', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.toString(),
        );
      },
      (enabled) {
        state = state.copyWith(isEnabled: enabled);
      },
    );

    // Get device token
    final tokenResult = await _repository.getDeviceToken();
    tokenResult.fold(
      (failure) {
        AppLogger.e('Failed to get device token', error: failure);
      },
      (token) {
        AppLogger.i('FCM token obtained');
        state = state.copyWith(deviceToken: token);
      },
    );

    state = state.copyWith(isLoading: false);
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    final result = await _repository.subscribeToTopic(topic);
    result.fold(
      (failure) => AppLogger.e('Failed to subscribe to topic', error: failure),
      (_) => AppLogger.i('Subscribed to topic: $topic'),
    );
  }

  /// Send notification
  Future<void> sendNotification({
    required String userId,
    required PushNotificationPayload payload,
  }) async {
    final result = await _repository.sendPushNotification(
      userId: userId,
      payload: payload,
    );
    result.fold(
      (failure) => AppLogger.e('Failed to send notification', error: failure),
      (_) => AppLogger.i('Notification sent to user: $userId'),
    );
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (failure) => AppLogger.e('Failed to mark as read', error: failure),
      (_) => AppLogger.i('Notification marked as read: $notificationId'),
    );
  }
}

/// Provider for notification service
final notificationServiceProvider = StateNotifierProvider<
    NotificationServiceNotifier, NotificationServiceState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  final messagingService = ref.watch(firebaseMessagingServiceProvider);
  final notifier = NotificationServiceNotifier(repository, messagingService);

  // Initialize on first use
  notifier.initialize();

  return notifier;
});
