import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/notification/domain/entities/notification_entity.dart';
import 'package:tall_us/features/notification/presentation/providers/notification_list_provider.dart';

/// Shows a dropdown-style dialog (anchored top-right) listing the most recent
/// notifications, with a "Voir tout" button at the bottom that opens the full
/// notifications page.
Future<void> showNotificationsDropdown(BuildContext context) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) => const _NotificationsDropdown(),
  );
}

class _NotificationsDropdown extends ConsumerWidget {
  const _NotificationsDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationListProvider);
    final notifs = state.notifications.take(6).toList();

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(top: 70, right: 12),
        width: 380,
        constraints: const BoxConstraints(maxHeight: 520),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: AppTheme.bordeaux,
                      size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                  const Spacer(),
                  if (state.unreadCount > 0)
                    GestureDetector(
                      onTap: () => ref
                          .read(notificationListProvider.notifier)
                          .markAllAsRead(),
                      child: Text(
                        'Tout marquer lu',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.bordeaux,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // List
            Flexible(
              child: state.isLoading && notifs.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.bordeaux, strokeWidth: 2),
                      ),
                    )
                  : notifs.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.notifications_none,
                                  size: 40,
                                  color: AppTheme.navy.withValues(alpha: 0.3)),
                              const SizedBox(height: 8),
                              Text(
                                'Aucune notification',
                                style: TextStyle(
                                  color: AppTheme.navy.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: notifs.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                          itemBuilder: (context, index) {
                            return _NotificationTile(
                              notification: notifs[index],
                              onTap: () {
                                ref
                                    .read(notificationListProvider.notifier)
                                    .markAsRead(notifs[index].id);
                                Navigator.pop(context);
                                context.go('/notifications');
                              },
                            );
                          },
                        ),
            ),

            // Voir tout button
            Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/notifications');
                  },
                  icon: const Icon(Icons.list, size: 18),
                  label: const Text('Voir tout'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.bordeaux,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconForType(notification.type);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : AppTheme.bordeaux.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppTheme.navy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: AppTheme.bordeaux,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.navy.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _timeAgo(notification.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.navy.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.newMatch:
        return (Icons.favorite, AppTheme.bordeaux);
      case NotificationType.newMessage:
        return (Icons.chat_bubble_outline, Colors.blue);
      case NotificationType.superLike:
        return (Icons.star, Colors.orange);
      case NotificationType.profileView:
        return (Icons.visibility, Colors.purple);
      case NotificationType.weeklyDigest:
        return (Icons.analytics, Colors.teal);
      case NotificationType.trialExpiration:
        return (Icons.timer, Colors.orange);
      case NotificationType.subscriptionRenewed:
        return (Icons.workspace_premium, AppTheme.gold);
      case NotificationType.subscriptionCanceled:
        return (Icons.cancel, Colors.red);
      case NotificationType.profileApproved:
        return (Icons.verified, Colors.green);
      case NotificationType.photoVerified:
        return (Icons.verified_user, Colors.green);
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'A l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return '${date.day}/${date.month}/${date.year}';
  }
}
