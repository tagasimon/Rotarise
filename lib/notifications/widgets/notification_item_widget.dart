import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;
  final VoidCallback onArchive;
  final bool isArchived;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.onArchive,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = notification.status == NotificationStatus.unread;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnread ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread
            ? BorderSide(color: theme.primaryColor.withAlphaa(0.3), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              _buildNotificationIcon(theme),
              const SizedBox(width: 12),
              // Notification content
              Expanded(
                child: _buildNotificationContent(theme, isUnread),
              ),
              // Action menu
              _buildActionMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(ThemeData theme) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.clubInvitation:
        iconData = Icons.group_add;
        iconColor = Colors.blue;
        break;
      case NotificationType.eventInvitation:
      case NotificationType.eventReminder:
        iconData = Icons.event;
        iconColor = Colors.green;
        break;
      case NotificationType.eventCreated:
        iconData = Icons.event_available;
        iconColor = Colors.orange;
        break;
      case NotificationType.eventCancelled:
        iconData = Icons.event_busy;
        iconColor = Colors.red;
        break;
      case NotificationType.membershipApproval:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case NotificationType.membershipRejection:
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      case NotificationType.roleAssignment:
        iconData = Icons.badge;
        iconColor = Colors.purple;
        break;
      case NotificationType.newMember:
        iconData = Icons.person_add;
        iconColor = Colors.blue;
        break;
      case NotificationType.announcement:
        iconData = Icons.campaign;
        iconColor = Colors.orange;
        break;
      case NotificationType.achievement:
        iconData = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withAlphaa(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildNotificationContent(ThemeData theme, bool isUnread) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          notification.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
            color: isUnread ? theme.primaryColor : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Message
        Text(
          notification.message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUnread ? Colors.black87 : Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Metadata row
        Row(
          children: [
            // Time
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Text(
              _formatTime(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
            if (notification.actionUserName != null) ...[
              const SizedBox(width: 12),
              Icon(
                Icons.person,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  notification.actionUserName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        // Status indicators
        if (isUnread || isArchived) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              if (isUnread)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isArchived)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'ARCHIVED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'read':
            onMarkAsRead();
            break;
          case 'archive':
            onArchive();
            break;
          case 'delete':
            _showDeleteConfirmation(context);
            break;
        }
      },
      itemBuilder: (context) => [
        if (notification.status == NotificationStatus.unread)
          const PopupMenuItem(
            value: 'read',
            child: Row(
              children: [
                Icon(Icons.mark_email_read, size: 20),
                SizedBox(width: 8),
                Text('Mark as read'),
              ],
            ),
          ),
        if (!isArchived)
          const PopupMenuItem(
            value: 'archive',
            child: Row(
              children: [
                Icon(Icons.archive, size: 20),
                SizedBox(width: 8),
                Text('Archive'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
