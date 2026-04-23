import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/notification/presentation/providers/notification_providers.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';

/// Widget that displays incoming push notifications
class NotificationWidget extends ConsumerStatefulWidget {
  const NotificationWidget({super.key});

  @override
  ConsumerState<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends ConsumerState<NotificationWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationServiceProvider);

    // Show notification permission banner if not enabled
    if (!notificationState.isLoading && !notificationState.isEnabled) {
      return _buildPermissionBanner();
    }

    return const SizedBox.shrink();
  }

  Widget _buildPermissionBanner() {
    return Material(
      elevation: 8,
      child: IgnorePointer(
        ignoring: false, // Allow pointer events on the banner itself
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.bordeaux,
                AppTheme.bordeaux.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enable Notifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Get notified when you match or receive messages',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _enableNotifications(),
                  child: const Text(
                    'Enable',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _enableNotifications() async {
    await ref.read(notificationServiceProvider.notifier).initialize();
  }
}

/// Display a single notification card
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification.isRead;

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white
                : AppTheme.bordeaux.withValues(alpha: 0.05),
            border: Border(
              left: BorderSide(
                color: isRead ? Colors.transparent : AppTheme.bordeaux,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon based on type
              _buildNotificationIcon(),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.navy.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                _formatTime(notification.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.navy.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.newMatch:
        icon = Icons.favorite;
        color = AppTheme.bordeaux;
        break;
      case NotificationType.newMessage:
        icon = Icons.chat_bubble;
        color = AppTheme.navy;
        break;
      case NotificationType.superLike:
        icon = Icons.star;
        color = AppTheme.gold;
        break;
      case NotificationType.profileView:
        icon = Icons.visibility;
        color = Colors.blue;
        break;
      case NotificationType.weeklyDigest:
        icon = Icons.bar_chart;
        color = Colors.green;
        break;
      case NotificationType.trialExpiration:
        icon = Icons.timer;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        color = AppTheme.navy;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Empty state for notifications
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.bordeaux.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll let you know when something happens!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification settings screen
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppTheme.bordeaux,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Enable Push Notifications',
            subtitle: 'Get notified on your lock screen',
            value: true,
            onChanged: (value) {},
          ),
          _buildSwitchTile(
            title: 'Enable Email Notifications',
            subtitle: 'Receive updates via email',
            value: true,
            onChanged: (value) {},
          ),
          const Divider(height: 32),
          _buildSectionHeader('Notification Types'),
          _buildSwitchTile(
            title: 'New Matches',
            subtitle: 'When you match with someone',
            value: true,
            onChanged: (value) {},
          ),
          _buildSwitchTile(
            title: 'New Messages',
            subtitle: 'When you receive a message',
            value: true,
            onChanged: (value) {},
          ),
          _buildSwitchTile(
            title: 'Super Likes',
            subtitle: 'When someone super likes you',
            value: true,
            onChanged: (value) {},
          ),
          _buildSwitchTile(
            title: 'Profile Views',
            subtitle: 'When someone views your profile',
            value: false,
            onChanged: (value) {},
          ),
          _buildSwitchTile(
            title: 'Weekly Digest',
            subtitle: 'Summary of your activity',
            value: true,
            onChanged: (value) {},
          ),
          const Divider(height: 32),
          _buildSectionHeader('Marketing'),
          _buildSwitchTile(
            title: 'Promotional Emails',
            subtitle: 'Special offers and updates',
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.bordeaux,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.navy.withValues(alpha: 0.7),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.bordeaux,
    );
  }
}
