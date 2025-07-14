import 'package:rotaract/_core/models/notification_model.dart';

/// Interface for notification repository operations
abstract class NotificationInterface {
  /// Create a new notification
  Future<void> createNotification(NotificationModel notification);

  /// Create multiple notifications (bulk operation)
  Future<void> createBulkNotifications(List<NotificationModel> notifications);

  /// Get all notifications for a specific user
  Future<List<NotificationModel>> getNotificationsByUserId(String userId);

  /// Get unread notifications for a specific user
  Future<List<NotificationModel>> getUnreadNotificationsByUserId(String userId);

  /// Get notifications by type for a specific user
  Future<List<NotificationModel>> getNotificationsByType(
    String userId,
    NotificationType type,
  );

  /// Get notification by ID
  Future<NotificationModel?> getNotificationById(String notificationId);

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId);

  /// Mark multiple notifications as read
  Future<void> markMultipleAsRead(List<String> notificationIds);

  /// Mark all notifications as read for a user
  Future<void> markAllAsReadForUser(String userId);

  /// Update notification status
  Future<void> updateNotificationStatus(
    String notificationId,
    NotificationStatus status,
  );

  /// Delete a notification
  Future<void> deleteNotification(String notificationId);

  /// Delete multiple notifications
  Future<void> deleteMultipleNotifications(List<String> notificationIds);

  /// Delete all notifications for a user
  Future<void> deleteAllNotificationsForUser(String userId);

  /// Archive a notification
  Future<void> archiveNotification(String notificationId);

  /// Get count of unread notifications for a user
  Future<int> getUnreadNotificationsCount(String userId);

  /// Get notifications with pagination
  Future<List<NotificationModel>> getNotificationsWithPagination(
    String userId, {
    int limit = 20,
    String? lastNotificationId,
  });

  /// Search notifications by title or message
  Future<List<NotificationModel>> searchNotifications(
    String userId,
    String query,
  );

  /// Get notifications by date range
  Future<List<NotificationModel>> getNotificationsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Clean up old notifications (delete notifications older than specified days)
  Future<void> cleanUpOldNotifications(int daysOld);

  /// Get notification statistics for a user
  Future<Map<String, int>> getNotificationStats(String userId);
}
