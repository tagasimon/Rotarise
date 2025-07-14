import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/models/notification_model.dart';
import 'package:rotaract/_core/providers/notification_providers.dart';
import 'package:rotaract/_core/services/notification_service.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/notifications/widgets/notification_item_widget.dart';
import 'package:rotaract/notifications/widgets/notifications_empty_state.dart';
import 'package:rotaract/notifications/widgets/notifications_error_view.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Show unread count in AppBar
          if (unreadCountAsync.hasValue && unreadCountAsync.value! > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${unreadCountAsync.value} unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    final notificationsAsync = ref.watch(userNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return const NotificationsEmptyState(
            message: 'No notifications yet',
            icon: Icons.notifications_none,
          );
        }

        // Separate unread and read notifications for better organization
        final unreadNotifications = notifications
            .where((n) => n.status == NotificationStatus.unread)
            .toList();
        final readNotifications = notifications
            .where((n) => n.status == NotificationStatus.read)
            .toList();

        return RefreshIndicator(
          onRefresh: _refreshNotifications,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length +
                (unreadNotifications.isNotEmpty && readNotifications.isNotEmpty
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              // Show unread notifications first
              if (index < unreadNotifications.length) {
                final notification = unreadNotifications[index];
                return NotificationItemWidget(
                  notification: notification,
                  onTap: () => _onNotificationTap(notification),
                  onMarkAsRead: () => _markAsRead(notification.id),
                  onDelete: () => _deleteNotification(notification.id),
                  onArchive: () => _archiveNotification(notification.id),
                );
              }

              // Add a divider between unread and read notifications
              if (index == unreadNotifications.length &&
                  readNotifications.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Earlier notifications',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                );
              }

              // Show read notifications
              final readIndex = index -
                  unreadNotifications.length -
                  (readNotifications.isNotEmpty ? 1 : 0);
              if (readIndex >= 0 && readIndex < readNotifications.length) {
                final notification = readNotifications[readIndex];
                return NotificationItemWidget(
                  notification: notification,
                  onTap: () => _onNotificationTap(notification),
                  onMarkAsRead: () => _markAsRead(notification.id),
                  onDelete: () => _deleteNotification(notification.id),
                  onArchive: () => _archiveNotification(notification.id),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => NotificationsErrorView(
        error: error,
        onRetry: () => ref.refresh(userNotificationsProvider),
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    ref.invalidate(userNotificationsProvider);
    ref.invalidate(unreadNotificationsProvider);
    ref.invalidate(unreadNotificationsCountProvider);
  }

  Future<void> _onNotificationTap(NotificationModel notification) async {
    // Mark as read if unread
    if (notification.status == NotificationStatus.unread) {
      await _markAsRead(notification.id);
    }

    // Handle navigation based on notification type and route
    if (notification.routeName != null) {
      _navigateToNotificationTarget(notification);
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    final notificationService = ref.read(notificationServiceProvider);
    final success = await notificationService.markAsRead(notificationId);

    if (success) {
      _refreshNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification marked as read'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    final notificationService = ref.read(notificationServiceProvider);
    final currentUser = ref.read(currentUserNotifierProvider);

    if (currentUser == null) return;

    final success = await notificationService.markAllAsRead(currentUser.id);

    if (success) {
      _refreshNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications marked as read'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    final notificationService = ref.read(notificationServiceProvider);
    final success =
        await notificationService.deleteNotification(notificationId);

    if (success) {
      _refreshNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _archiveNotification(String notificationId) async {
    final notificationService = ref.read(notificationServiceProvider);
    final success =
        await notificationService.archiveNotification(notificationId);

    if (success) {
      _refreshNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification archived'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _navigateToNotificationTarget(NotificationModel notification) {
    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.clubInvitation:
      case NotificationType.membershipApproval:
        if (notification.clubId != null) {
          Navigator.pushNamed(
            context,
            '/club-details',
            arguments: {'clubId': notification.clubId},
          );
        }
        break;
      case NotificationType.eventInvitation:
      case NotificationType.eventReminder:
      case NotificationType.eventCreated:
        if (notification.eventId != null) {
          Navigator.pushNamed(
            context,
            '/event-details',
            arguments: {'eventId': notification.eventId},
          );
        }
        break;
      default:
        // For other types, show notification details
        _showNotificationDetails(notification);
        break;
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              'Received: ${_formatDate(notification.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (notification.actionUserName != null) ...[
              const SizedBox(height: 8),
              Text(
                'From: ${notification.actionUserName}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
