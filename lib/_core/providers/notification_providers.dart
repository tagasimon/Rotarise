import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/controllers/notification_controller.dart';
import 'package:rotaract/_core/models/notification_model.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/_core/repos/notification_repo.dart';

/// Repository provider for notifications
final notificationRepoProvider = Provider<NotificationRepo>((ref) {
  return NotificationRepo(ref.watch(notificationsCollectionRefProvider));
});

/// Controller provider for notification operations
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) {
  return NotificationController(ref.watch(notificationRepoProvider));
});

/// Provider to get all notifications for the current user
final userNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  return ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);
});

/// Provider to get unread notifications for the current user
final unreadNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  return ref
      .watch(notificationRepoProvider)
      .getUnreadNotificationsByUserId(currentUser.id);
});

/// Provider to get unread notifications count for the current user
final unreadNotificationsCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return 0;

  return ref
      .watch(notificationRepoProvider)
      .getUnreadNotificationsCount(currentUser.id);
});

/// Provider to get notifications by type for the current user
final notificationsByTypeProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, NotificationType>((ref, type) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  return ref
      .watch(notificationRepoProvider)
      .getNotificationsByType(currentUser.id, type);
});

/// Provider to get a specific notification by ID
final notificationByIdProvider = FutureProvider.autoDispose
    .family<NotificationModel?, String>((ref, notificationId) async {
  return ref
      .watch(notificationRepoProvider)
      .getNotificationById(notificationId);
});

/// Provider to get notifications with pagination
final paginatedNotificationsProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, PaginationParams>((ref, params) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  return ref.watch(notificationRepoProvider).getNotificationsWithPagination(
        currentUser.id,
        limit: params.limit,
        lastNotificationId: params.lastNotificationId,
      );
});

/// Provider to search notifications
final searchNotificationsProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, String>((ref, query) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  if (query.trim().isEmpty) {
    // Return all notifications if query is empty
    return ref
        .watch(notificationRepoProvider)
        .getNotificationsByUserId(currentUser.id);
  }

  return ref
      .watch(notificationRepoProvider)
      .searchNotifications(currentUser.id, query);
});

/// Provider to get notifications by date range
final notificationsByDateRangeProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, DateRangeParams>((ref, params) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  return ref.watch(notificationRepoProvider).getNotificationsByDateRange(
        currentUser.id,
        params.startDate,
        params.endDate,
      );
});

/// Provider to get notification statistics for the current user
final notificationStatsProvider =
    FutureProvider.autoDispose<Map<String, int>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return {};

  return ref
      .watch(notificationRepoProvider)
      .getNotificationStats(currentUser.id);
});

/// Provider to get archived notifications for the current user
final archivedNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  // Get all notifications and filter archived ones
  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  return allNotifications
      .where(
          (notification) => notification.status == NotificationStatus.archived)
      .toList();
});

/// Provider to get club-related notifications
final clubNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  return allNotifications.where((notification) {
    return notification.type == NotificationType.clubInvitation ||
        notification.type == NotificationType.membershipApproval ||
        notification.type == NotificationType.membershipRejection ||
        notification.type == NotificationType.roleAssignment ||
        notification.type == NotificationType.roleRemoval ||
        notification.type == NotificationType.newMember ||
        notification.type == NotificationType.memberLeft;
  }).toList();
});

/// Provider to get event-related notifications
final eventNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  return allNotifications.where((notification) {
    return notification.type == NotificationType.eventInvitation ||
        notification.type == NotificationType.eventReminder ||
        notification.type == NotificationType.eventUpdate ||
        notification.type == NotificationType.eventCreated ||
        notification.type == NotificationType.eventCancelled;
  }).toList();
});

/// Provider to get today's notifications
final todayNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

  return ref.watch(notificationRepoProvider).getNotificationsByDateRange(
        currentUser.id,
        startOfDay,
        endOfDay,
      );
});

/// Provider to get this week's notifications
final weekNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfWeekDate =
      DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  final endOfWeek = startOfWeekDate
      .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  return ref.watch(notificationRepoProvider).getNotificationsByDateRange(
        currentUser.id,
        startOfWeekDate,
        endOfWeek,
      );
});

/// Provider to check if user has any unread notifications (boolean)
final hasUnreadNotificationsProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final unreadCount = await ref.watch(unreadNotificationsCountProvider.future);
  return unreadCount > 0;
});

/// Provider to get notification count by type
final notificationCountByTypeProvider =
    FutureProvider.autoDispose.family<int, NotificationType>((ref, type) async {
  final notifications =
      await ref.watch(notificationsByTypeProvider(type).future);
  return notifications.length;
});

/// Provider to get recent notifications (last 7 days)
final recentNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final now = DateTime.now();
  final sevenDaysAgo = now.subtract(const Duration(days: 7));

  return ref.watch(notificationRepoProvider).getNotificationsByDateRange(
        currentUser.id,
        sevenDaysAgo,
        now,
      );
});

/// Provider for notification summary (counts for different categories)
final notificationSummaryProvider =
    FutureProvider.autoDispose<NotificationSummary>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) {
    return const NotificationSummary(
      total: 0,
      unread: 0,
      read: 0,
      archived: 0,
      today: 0,
      thisWeek: 0,
      clubRelated: 0,
      eventRelated: 0,
    );
  }

  // Get all data in parallel
  final futures = await Future.wait([
    ref.watch(userNotificationsProvider.future),
    ref.watch(unreadNotificationsCountProvider.future),
    ref.watch(todayNotificationsProvider.future),
    ref.watch(weekNotificationsProvider.future),
    ref.watch(clubNotificationsProvider.future),
    ref.watch(eventNotificationsProvider.future),
    ref.watch(archivedNotificationsProvider.future),
  ]);

  final allNotifications = futures[0] as List<NotificationModel>;
  final unreadCount = futures[1] as int;
  final todayNotifications = futures[2] as List<NotificationModel>;
  final weekNotifications = futures[3] as List<NotificationModel>;
  final clubNotifications = futures[4] as List<NotificationModel>;
  final eventNotifications = futures[5] as List<NotificationModel>;
  final archivedNotifications = futures[6] as List<NotificationModel>;

  final readCount =
      allNotifications.where((n) => n.status == NotificationStatus.read).length;

  return NotificationSummary(
    total: allNotifications.length,
    unread: unreadCount,
    read: readCount,
    archived: archivedNotifications.length,
    today: todayNotifications.length,
    thisWeek: weekNotifications.length,
    clubRelated: clubNotifications.length,
    eventRelated: eventNotifications.length,
  );
});

/// Provider to get notifications for a specific club
final notificationsByClubProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, String>((ref, clubId) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  return allNotifications
      .where((notification) => notification.clubId == clubId)
      .toList();
});

/// Provider to get notifications for a specific event
final notificationsByEventProvider = FutureProvider.autoDispose
    .family<List<NotificationModel>, String>((ref, eventId) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  return allNotifications
      .where((notification) => notification.eventId == eventId)
      .toList();
});

/// Provider to get priority notifications (unread + important types)
final priorityNotificationsProvider =
    FutureProvider.autoDispose<List<NotificationModel>>((ref) async {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) return [];

  final allNotifications = await ref
      .watch(notificationRepoProvider)
      .getNotificationsByUserId(currentUser.id);

  // Priority notification types
  const priorityTypes = {
    NotificationType.membershipApproval,
    NotificationType.membershipRejection,
    NotificationType.roleAssignment,
    NotificationType.eventCancelled,
    NotificationType.warning,
    NotificationType.achievement,
  };

  return allNotifications.where((notification) {
    // Include unread notifications or priority types
    return notification.status == NotificationStatus.unread ||
        priorityTypes.contains(notification.type);
  }).toList();
});

/// Stream provider for real-time notifications (if needed for live updates)
final notificationsStreamProvider =
    StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final currentUser = ref.watch(currentUserNotifierProvider);
  if (currentUser == null) {
    return Stream.value([]);
  }

  // This would typically be a Firestore stream, but for now return a simple stream
  // In a real implementation, you would use:
  // return FirebaseFirestore.instance
  //     .collection('NOTIFICATIONS')
  //     .where('userId', isEqualTo: currentUser.id)
  //     .where('status', whereNotIn: [NotificationStatus.deleted.name])
  //     .orderBy('createdAt', descending: true)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());

  // For now, return a periodic stream that refreshes every 30 seconds
  return Stream.periodic(const Duration(seconds: 30), (_) {
    return ref
        .read(notificationRepoProvider)
        .getNotificationsByUserId(currentUser.id);
  }).asyncMap((future) => future);
});

/// Provider to get the most recent notification
final latestNotificationProvider =
    FutureProvider.autoDispose<NotificationModel?>((ref) async {
  final notifications = await ref.watch(userNotificationsProvider.future);
  return notifications.isNotEmpty ? notifications.first : null;
});

/// Provider to check if notifications need attention (has unread priority notifications)
final notificationsNeedAttentionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final priorityNotifications =
      await ref.watch(priorityNotificationsProvider.future);
  return priorityNotifications
      .any((n) => n.status == NotificationStatus.unread);
});

/// Helper classes for provider parameters

/// Class to represent notification summary statistics
class NotificationSummary {
  final int total;
  final int unread;
  final int read;
  final int archived;
  final int today;
  final int thisWeek;
  final int clubRelated;
  final int eventRelated;

  const NotificationSummary({
    required this.total,
    required this.unread,
    required this.read,
    required this.archived,
    required this.today,
    required this.thisWeek,
    required this.clubRelated,
    required this.eventRelated,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationSummary &&
        other.total == total &&
        other.unread == unread &&
        other.read == read &&
        other.archived == archived &&
        other.today == today &&
        other.thisWeek == thisWeek &&
        other.clubRelated == clubRelated &&
        other.eventRelated == eventRelated;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        unread.hashCode ^
        read.hashCode ^
        archived.hashCode ^
        today.hashCode ^
        thisWeek.hashCode ^
        clubRelated.hashCode ^
        eventRelated.hashCode;
  }

  @override
  String toString() {
    return 'NotificationSummary(total: $total, unread: $unread, read: $read, archived: $archived, today: $today, thisWeek: $thisWeek, clubRelated: $clubRelated, eventRelated: $eventRelated)';
  }
}

class PaginationParams {
  final int limit;
  final String? lastNotificationId;

  const PaginationParams({
    this.limit = 20,
    this.lastNotificationId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationParams &&
        other.limit == limit &&
        other.lastNotificationId == lastNotificationId;
  }

  @override
  int get hashCode => limit.hashCode ^ lastNotificationId.hashCode;
}

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateRangeParams &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}
