import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/models/notification_model.dart';
import 'package:rotaract/_core/repos/notification_repo.dart';
import 'package:uuid/uuid.dart';

/// State notifier for managing notification operations
class NotificationController extends StateNotifier<AsyncValue<void>> {
  final NotificationRepo _repo;
  final Uuid _uuid = const Uuid();

  NotificationController(this._repo) : super(const AsyncData(null));

  /// Create a new notification
  Future<bool> createNotification({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    String? actionUserId,
    String? actionUserName,
    String? clubId,
    String? eventId,
    String? memberId,
    String? imageUrl,
    String? routeName,
    Map<String, dynamic>? routeParams,
  }) async {
    state = const AsyncLoading();
    try {
      final notification = NotificationModel(
        id: _uuid.v4(),
        userId: userId,
        title: title,
        message: message,
        type: type,
        status: NotificationStatus.unread,
        actionUserId: actionUserId,
        actionUserName: actionUserName,
        clubId: clubId,
        eventId: eventId,
        memberId: memberId,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        routeName: routeName,
        routeParams: routeParams,
      );

      await _repo.createNotification(notification);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Create notifications for multiple users
  Future<bool> createBulkNotifications({
    required List<String> userIds,
    required String title,
    required String message,
    required NotificationType type,
    String? actionUserId,
    String? actionUserName,
    String? clubId,
    String? eventId,
    String? memberId,
    String? imageUrl,
    String? routeName,
    Map<String, dynamic>? routeParams,
  }) async {
    state = const AsyncLoading();
    try {
      final notifications = userIds
          .map((userId) => NotificationModel(
                id: _uuid.v4(),
                userId: userId,
                title: title,
                message: message,
                type: type,
                status: NotificationStatus.unread,
                actionUserId: actionUserId,
                actionUserName: actionUserName,
                clubId: clubId,
                eventId: eventId,
                memberId: memberId,
                imageUrl: imageUrl,
                createdAt: DateTime.now(),
                routeName: routeName,
                routeParams: routeParams,
              ))
          .toList();

      await _repo.createBulkNotifications(notifications);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Mark multiple notifications as read
  Future<bool> markMultipleAsRead(List<String> notificationIds) async {
    state = const AsyncLoading();
    try {
      await _repo.markMultipleAsRead(notificationIds);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsReadForUser(String userId) async {
    state = const AsyncLoading();
    try {
      await _repo.markAllAsReadForUser(userId);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _repo.deleteNotification(notificationId);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Delete multiple notifications
  Future<bool> deleteMultipleNotifications(List<String> notificationIds) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteMultipleNotifications(notificationIds);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Archive a notification
  Future<bool> archiveNotification(String notificationId) async {
    try {
      await _repo.archiveNotification(notificationId);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Clean up old notifications
  Future<bool> cleanUpOldNotifications(int daysOld) async {
    state = const AsyncLoading();
    try {
      await _repo.cleanUpOldNotifications(daysOld);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  /// Helper methods for creating specific types of notifications

  /// Create a club invitation notification
  Future<bool> createClubInvitationNotification({
    required String userId,
    required String clubName,
    required String inviterName,
    required String clubId,
    String? inviterImageUrl,
  }) async {
    return createNotification(
      userId: userId,
      title: 'Club Invitation',
      message: '$inviterName invited you to join $clubName',
      type: NotificationType.clubInvitation,
      actionUserName: inviterName,
      clubId: clubId,
      imageUrl: inviterImageUrl,
      routeName: '/club-details',
      routeParams: {'clubId': clubId},
    );
  }

  /// Create an event invitation notification
  Future<bool> createEventInvitationNotification({
    required String userId,
    required String eventName,
    required String clubName,
    required String eventId,
    required String clubId,
  }) async {
    return createNotification(
      userId: userId,
      title: 'Event Invitation',
      message: 'You\'re invited to $eventName by $clubName',
      type: NotificationType.eventInvitation,
      clubId: clubId,
      eventId: eventId,
      routeName: '/event-details',
      routeParams: {'eventId': eventId},
    );
  }

  /// Create a new member notification
  Future<bool> createNewMemberNotification({
    required List<String> userIds,
    required String newMemberName,
    required String clubName,
    required String clubId,
    required String newMemberId,
  }) async {
    return createBulkNotifications(
      userIds: userIds,
      title: 'New Member',
      message: '$newMemberName joined $clubName',
      type: NotificationType.newMember,
      actionUserName: newMemberName,
      clubId: clubId,
      memberId: newMemberId,
    );
  }

  /// Create an event reminder notification
  Future<bool> createEventReminderNotification({
    required List<String> userIds,
    required String eventName,
    required DateTime eventDate,
    required String eventId,
    required String clubId,
  }) async {
    final formatDate = '${eventDate.day}/${eventDate.month}/${eventDate.year}';
    return createBulkNotifications(
      userIds: userIds,
      title: 'Event Reminder',
      message: 'Don\'t forget about $eventName on $formatDate',
      type: NotificationType.eventReminder,
      clubId: clubId,
      eventId: eventId,
      routeName: '/event-details',
      routeParams: {'eventId': eventId},
    );
  }

  /// Create a role assignment notification
  Future<bool> createRoleAssignmentNotification({
    required String userId,
    required String roleName,
    required String clubName,
    required String assignerName,
    required String clubId,
  }) async {
    return createNotification(
      userId: userId,
      title: 'Role Assignment',
      message: '$assignerName assigned you as $roleName in $clubName',
      type: NotificationType.roleAssignment,
      actionUserName: assignerName,
      clubId: clubId,
    );
  }

  /// Create a general announcement notification
  Future<bool> createAnnouncementNotification({
    required List<String> userIds,
    required String title,
    required String message,
    required String clubId,
    String? imageUrl,
  }) async {
    return createBulkNotifications(
      userIds: userIds,
      title: title,
      message: message,
      type: NotificationType.announcement,
      clubId: clubId,
      imageUrl: imageUrl,
    );
  }
}
