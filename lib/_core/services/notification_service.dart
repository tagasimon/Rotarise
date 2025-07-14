import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/controllers/notification_controller.dart';
import 'package:rotaract/_core/models/notification_model.dart';
import 'package:rotaract/_core/providers/notification_providers.dart';

/// Service class for managing notifications throughout the app
class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  NotificationController get _controller =>
      _ref.read(notificationControllerProvider.notifier);

  /// Club-related notifications

  /// Notify users when someone joins a club
  Future<bool> notifyClubMembersOfNewMember({
    required List<String> memberUserIds,
    required String newMemberName,
    required String clubName,
    required String clubId,
    required String newMemberId,
  }) async {
    return await _controller.createNewMemberNotification(
      userIds: memberUserIds,
      newMemberName: newMemberName,
      clubName: clubName,
      clubId: clubId,
      newMemberId: newMemberId,
    );
  }

  /// Notify user of club invitation
  Future<bool> notifyClubInvitation({
    required String userId,
    required String clubName,
    required String inviterName,
    required String clubId,
    String? inviterImageUrl,
  }) async {
    return await _controller.createClubInvitationNotification(
      userId: userId,
      clubName: clubName,
      inviterName: inviterName,
      clubId: clubId,
      inviterImageUrl: inviterImageUrl,
    );
  }

  /// Notify user of role assignment
  Future<bool> notifyRoleAssignment({
    required String userId,
    required String roleName,
    required String clubName,
    required String assignerName,
    required String clubId,
  }) async {
    return await _controller.createRoleAssignmentNotification(
      userId: userId,
      roleName: roleName,
      clubName: clubName,
      assignerName: assignerName,
      clubId: clubId,
    );
  }

  /// Notify user when they are added to a club
  Future<bool> notifyUserAddedToClub({
    required String userId,
    required String clubName,
    required String clubId,
    required String addedByName,
    String? addedByImageUrl,
  }) async {
    return await _controller.createNotification(
      userId: userId,
      title: 'Added to Club',
      message: '$addedByName added you to $clubName',
      type: NotificationType.membershipApproval,
      actionUserName: addedByName,
      clubId: clubId,
      imageUrl: addedByImageUrl,
      routeName: '/club-details',
      routeParams: {'clubId': clubId},
    );
  }

  /// Event-related notifications

  /// Notify users of event invitation
  Future<bool> notifyEventInvitation({
    required String userId,
    required String eventName,
    required String clubName,
    required String eventId,
    required String clubId,
  }) async {
    return await _controller.createEventInvitationNotification(
      userId: userId,
      eventName: eventName,
      clubName: clubName,
      eventId: eventId,
      clubId: clubId,
    );
  }

  /// Notify users of event reminder
  Future<bool> notifyEventReminder({
    required List<String> userIds,
    required String eventName,
    required DateTime eventDate,
    required String eventId,
    required String clubId,
  }) async {
    return await _controller.createEventReminderNotification(
      userIds: userIds,
      eventName: eventName,
      eventDate: eventDate,
      eventId: eventId,
      clubId: clubId,
    );
  }

  /// Notify users when an event is created
  Future<bool> notifyEventCreated({
    required List<String> userIds,
    required String eventName,
    required String clubName,
    required String eventId,
    required String clubId,
    required DateTime eventDate,
  }) async {
    final formatDate = '${eventDate.day}/${eventDate.month}/${eventDate.year}';
    return await _controller.createBulkNotifications(
      userIds: userIds,
      title: 'New Event',
      message: '$clubName created a new event: $eventName on $formatDate',
      type: NotificationType.eventCreated,
      clubId: clubId,
      eventId: eventId,
      routeName: '/event-details',
      routeParams: {'eventId': eventId},
    );
  }

  /// Notify users when an event is cancelled
  Future<bool> notifyEventCancelled({
    required List<String> userIds,
    required String eventName,
    required String clubName,
    required String eventId,
    required String clubId,
  }) async {
    return await _controller.createBulkNotifications(
      userIds: userIds,
      title: 'Event Cancelled',
      message: '$clubName cancelled the event: $eventName',
      type: NotificationType.eventCancelled,
      clubId: clubId,
      eventId: eventId,
    );
  }

  /// General notifications

  /// Send club announcement
  Future<bool> sendClubAnnouncement({
    required List<String> userIds,
    required String title,
    required String message,
    required String clubId,
    String? imageUrl,
  }) async {
    return await _controller.createAnnouncementNotification(
      userIds: userIds,
      title: title,
      message: message,
      clubId: clubId,
      imageUrl: imageUrl,
    );
  }

  /// Notify membership approval
  Future<bool> notifyMembershipApproval({
    required String userId,
    required String clubName,
    required String clubId,
  }) async {
    return await _controller.createNotification(
      userId: userId,
      title: 'Membership Approved',
      message: 'Your membership to $clubName has been approved!',
      type: NotificationType.membershipApproval,
      clubId: clubId,
      routeName: '/club-details',
      routeParams: {'clubId': clubId},
    );
  }

  /// Notify membership rejection
  Future<bool> notifyMembershipRejection({
    required String userId,
    required String clubName,
    required String clubId,
    String? reason,
  }) async {
    final message = reason != null
        ? 'Your membership to $clubName was rejected. Reason: $reason'
        : 'Your membership to $clubName was rejected.';

    return await _controller.createNotification(
      userId: userId,
      title: 'Membership Rejected',
      message: message,
      type: NotificationType.membershipRejection,
      clubId: clubId,
    );
  }

  /// Notify visit approval
  Future<bool> notifyVisitApproval({
    required String userId,
    required String clubName,
    required String eventName,
    required String clubId,
    required String eventId,
  }) async {
    return await _controller.createNotification(
      userId: userId,
      title: 'Visit Approved',
      message: 'Your visit to $eventName at $clubName has been approved!',
      type: NotificationType.visitApproval,
      clubId: clubId,
      eventId: eventId,
      routeName: '/event-details',
      routeParams: {'eventId': eventId},
    );
  }

  /// Notify achievement/milestone
  Future<bool> notifyAchievement({
    required String userId,
    required String achievementTitle,
    required String achievementMessage,
    String? imageUrl,
  }) async {
    return await _controller.createNotification(
      userId: userId,
      title: achievementTitle,
      message: achievementMessage,
      type: NotificationType.achievement,
      imageUrl: imageUrl,
    );
  }

  /// User interaction methods

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    return await _controller.markAsRead(notificationId);
  }

  /// Mark all notifications as read for current user
  Future<bool> markAllAsRead(String userId) async {
    return await _controller.markAllAsReadForUser(userId);
  }

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    return await _controller.deleteNotification(notificationId);
  }

  /// Archive notification
  Future<bool> archiveNotification(String notificationId) async {
    return await _controller.archiveNotification(notificationId);
  }

  /// Utility methods

  /// Clean up old notifications (older than specified days)
  Future<bool> cleanUpOldNotifications({int daysOld = 30}) async {
    return await _controller.cleanUpOldNotifications(daysOld);
  }
}

/// Provider for the notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});
