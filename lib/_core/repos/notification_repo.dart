import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/_core/domain/notification_interface.dart';
import 'package:rotaract/_core/models/notification_model.dart';

/// Repository class that implements notification operations
class NotificationRepo extends NotificationInterface {
  final CollectionReference _ref;

  NotificationRepo(this._ref);

  @override
  Future<void> createNotification(NotificationModel notification) async {
    await _ref.doc(notification.id).set(notification.toMap());
  }

  @override
  Future<void> createBulkNotifications(
      List<NotificationModel> notifications) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final notification in notifications) {
      final docRef = _ref.doc(notification.id);
      batch.set(docRef, notification.toMap());
    }

    await batch.commit();
  }

  @override
  Future<List<NotificationModel>> getNotificationsByUserId(
      String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name])
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<NotificationModel>> getUnreadNotificationsByUserId(
      String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: NotificationStatus.unread.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<NotificationModel>> getNotificationsByType(
    String userId,
    NotificationType type,
  ) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type.name)
        .where('status', whereNotIn: [NotificationStatus.deleted.name])
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    final doc = await _ref.doc(notificationId).get();

    if (doc.exists) {
      return NotificationModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _ref.doc(notificationId).update({
      'status': NotificationStatus.read.name,
      'readAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> markMultipleAsRead(List<String> notificationIds) async {
    final batch = FirebaseFirestore.instance.batch();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (final id in notificationIds) {
      final docRef = _ref.doc(id);
      batch.update(docRef, {
        'status': NotificationStatus.read.name,
        'readAt': now,
        'updatedAt': now,
      });
    }

    await batch.commit();
  }

  @override
  Future<void> markAllAsReadForUser(String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: NotificationStatus.unread.name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': NotificationStatus.read.name,
          'readAt': now,
          'updatedAt': now,
        });
      }

      await batch.commit();
    }
  }

  @override
  Future<void> updateNotificationStatus(
    String notificationId,
    NotificationStatus status,
  ) async {
    await _ref.doc(notificationId).update({
      'status': status.name,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _ref.doc(notificationId).update({
      'status': NotificationStatus.deleted.name,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> deleteMultipleNotifications(List<String> notificationIds) async {
    final batch = FirebaseFirestore.instance.batch();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (final id in notificationIds) {
      final docRef = _ref.doc(id);
      batch.update(docRef, {
        'status': NotificationStatus.deleted.name,
        'updatedAt': now,
      });
    }

    await batch.commit();
  }

  @override
  Future<void> deleteAllNotificationsForUser(String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name]).get();

    if (snapshot.docs.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': NotificationStatus.deleted.name,
          'updatedAt': now,
        });
      }

      await batch.commit();
    }
  }

  @override
  Future<void> archiveNotification(String notificationId) async {
    await _ref.doc(notificationId).update({
      'status': NotificationStatus.archived.name,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<int> getUnreadNotificationsCount(String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: NotificationStatus.unread.name)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  @override
  Future<List<NotificationModel>> getNotificationsWithPagination(
    String userId, {
    int limit = 20,
    String? lastNotificationId,
  }) async {
    Query query = _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name])
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastNotificationId != null) {
      final lastDoc = await _ref.doc(lastNotificationId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<NotificationModel>> searchNotifications(
    String userId,
    String query,
  ) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name])
        .orderBy('createdAt', descending: true)
        .get();

    final notifications = snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();

    // Filter notifications by search query
    return notifications.where((notification) {
      final searchLower = query.toLowerCase();
      return notification.title.toLowerCase().contains(searchLower) ||
          notification.message.toLowerCase().contains(searchLower) ||
          (notification.actionUserName?.toLowerCase().contains(searchLower) ??
              false);
    }).toList();
  }

  @override
  Future<List<NotificationModel>> getNotificationsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name])
        .where('createdAt',
            isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch)
        .where('createdAt', isLessThanOrEqualTo: endDate.millisecondsSinceEpoch)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> cleanUpOldNotifications(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final snapshot = await _ref
        .where('createdAt', isLessThan: cutoffDate.millisecondsSinceEpoch)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  @override
  Future<Map<String, int>> getNotificationStats(String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .where('status', whereNotIn: [NotificationStatus.deleted.name]).get();

    final notifications = snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();

    final stats = <String, int>{
      'total': notifications.length,
      'unread': 0,
      'read': 0,
      'archived': 0,
    };

    for (final notification in notifications) {
      switch (notification.status) {
        case NotificationStatus.unread:
          stats['unread'] = (stats['unread'] ?? 0) + 1;
          break;
        case NotificationStatus.read:
          stats['read'] = (stats['read'] ?? 0) + 1;
          break;
        case NotificationStatus.archived:
          stats['archived'] = (stats['archived'] ?? 0) + 1;
          break;
        case NotificationStatus.deleted:
          // Don't count deleted notifications
          break;
      }
    }

    return stats;
  }
}
